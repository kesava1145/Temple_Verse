import { createClient } from "npm:@supabase/supabase-js@2";

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-translation-secret",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { ...cors, "Content-Type": "application/json" },
  });

const fieldMap = {
  temple: [
    "name",
    "description",
    "history",
    "architecture_summary",
    "cultural_significance",
    "main_deity",
    "architectural_style",
    "historical_period",
  ],
  location: [
    "name",
    "description",
    "story",
    "architecture",
    "rituals",
    "significance",
  ],
  guided_step: ["title", "description"],
} as const;

const tableMap = {
  temple: {
    base: "temples",
    translation: "temple_translations",
    fk: "temple_id",
  },
  location: {
    base: "temple_locations",
    translation: "location_translations",
    fk: "location_id",
  },
  guided_step: {
    base: "guided_steps",
    translation: "guided_step_translations",
    fk: "step_id",
  },
} as const;

type EntityType = keyof typeof tableMap;
type EntityRow = Record<string, unknown> & { id: string };
type TranslationRow = Record<string, unknown>;

const validEntityTypes: EntityType[] = [
  "temple",
  "location",
  "guided_step",
];

const languageNames: Record<string, string> = {
  hi: "Hindi",
  ta: "Tamil",
  te: "Telugu",
  ml: "Malayalam",
};

const sha256 = async (value: string): Promise<string> => {
  const hash = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(value),
  );

  return [...new Uint8Array(hash)]
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
};

const extractJson = (content: string): Record<string, unknown> => {
  try {
    const parsed: unknown = JSON.parse(content);

    if (parsed && typeof parsed === "object" && !Array.isArray(parsed)) {
      return parsed as Record<string, unknown>;
    }
  } catch {
    // Try extracting a JSON object if the model added surrounding text.
  }

  const start = content.indexOf("{");
  const end = content.lastIndexOf("}");

  if (start === -1 || end <= start) {
    throw new Error("Ollama did not return a valid JSON object");
  }

  const parsed: unknown = JSON.parse(content.slice(start, end + 1));

  if (!parsed || typeof parsed !== "object" || Array.isArray(parsed)) {
    throw new Error("Invalid translation JSON structure");
  }

  return parsed as Record<string, unknown>;
};

Deno.serve(async (request: Request) => {
  if (request.method === "OPTIONS") {
    return new Response("ok", { headers: cors });
  }

  if (request.method !== "POST") {
    return json({ error: "POST required" }, 405);
  }

  const secret = Deno.env.get("TRANSLATION_CRON_SECRET");

  if (
    !secret ||
    request.headers.get("x-translation-secret") !== secret
  ) {
    return json({ error: "Unauthorized" }, 401);
  }

  const url = Deno.env.get("SUPABASE_URL");
  const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

  const ollamaBaseUrl =
    Deno.env.get("OLLAMA_BASE_URL") ||
    "http://host.docker.internal:11434";

  const model = Deno.env.get("OLLAMA_MODEL") || "qwen3:4b";

  if (!url || !serviceKey) {
    return json({ error: "Missing Supabase server configuration" }, 500);
  }

  const body = await request.json().catch(() => ({}));

  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return json({ error: "Invalid JSON body" }, 400);
  }

  const input = body as Record<string, unknown>;
  const language = String(input.language || "");

  if (!Object.hasOwn(languageNames, language)) {
    return json(
      { error: "language must be hi, ta, te or ml" },
      400,
    );
  }

  const entityTypes: EntityType[] = Array.isArray(input.entity_types)
    ? input.entity_types.filter(
      (value): value is EntityType =>
        typeof value === "string" &&
        validEntityTypes.includes(value as EntityType),
    )
    : validEntityTypes;

  const requestedLimit = Number(input.limit || 10);
  const limit = Number.isFinite(requestedLimit)
    ? Math.max(1, Math.min(Math.floor(requestedLimit), 20))
    : 10;

  const db = createClient(url, serviceKey, {
    auth: { persistSession: false },
  });

  // Dynamic table and column names are restricted to the maps above.
  const dynamicDb = db as any;

  const { data: lang, error: langError } = await db
    .from("languages")
    .select("id")
    .eq("code", language)
    .single();

  if (langError || !lang) {
    return json(
      { error: langError?.message || "Language not found" },
      500,
    );
  }

  let created = 0;
  let skipped = 0;
  const errors: string[] = [];

  for (const entityType of entityTypes) {
    const config = tableMap[entityType];
    const fields: readonly string[] = fieldMap[entityType];
    const selectedFields = ["id", ...fields].join(",");

    let baseQuery = dynamicDb
      .from(config.base)
      .select(selectedFields);

    if (entityType === "temple") {
      baseQuery = baseQuery.eq("published", true);
    }

    const { data: rawEntities, error: entityError } =
      await baseQuery.limit(limit);

    if (entityError) {
      errors.push(`${entityType}: ${entityError.message}`);
      continue;
    }

    const entities = (rawEntities || []) as EntityRow[];
    const ids = entities.map((entity) => entity.id);

    if (ids.length === 0) {
      continue;
    }

    const { data: rawExisting, error: existingError } =
      await dynamicDb
        .from(config.translation)
        .select(`${config.fk},${fields.join(",")}`)
        .eq("language_id", lang.id)
        .in(config.fk, ids);

    if (existingError) {
      errors.push(
        `${entityType} translations: ${existingError.message}`,
      );
      continue;
    }

    const existing = (rawExisting || []) as TranslationRow[];

    const translatedById = new Map<string, TranslationRow>(
      existing.map((row) => [
        String(row[config.fk]),
        row,
      ]),
    );

    for (const entity of entities) {
      const current = translatedById.get(entity.id) || {};
      const missing: Record<string, string> = {};

      for (const field of fields) {
        const sourceValue = entity[field];
        const currentValue = current[field];

        if (
          typeof sourceValue === "string" &&
          sourceValue.trim() &&
          !(
            typeof currentValue === "string" &&
            currentValue.trim()
          )
        ) {
          missing[field] = sourceValue;
        }
      }

      if (Object.keys(missing).length === 0) {
        skipped++;
        continue;
      }

      try {
        const ollamaResponse = await fetch(
          `${ollamaBaseUrl.replace(/\/+$/, "")}/api/chat`,
          {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify({
              model,
              stream: false,
              think: false,
              format: "json",
              messages: [
                {
                  role: "system",
                  content:
                    `You are an expert translator specializing in Indian languages, ` +
                    `temple history, culture and religious terminology. ` +
                    `Translate the supplied JSON values into ${languageNames[language]}. ` +
                    "Produce natural, fluent, grammatically correct translations. " +
                    "Do not translate word-for-word if that produces unnatural language. " +
                    "Preserve the original meaning, names, dates, numbers, deity names " +
                    "and culturally specific terms. Use correct native sentence structure " +
                    "and respectful religious terminology. Return ONLY a valid JSON object " +
                    "with exactly the same keys as the input. Every value must be a " +
                    "translated string. Do not add explanations, facts or additional keys. " +
                    'Example: "Welcome to the temple" in Hindi is ' +
                    '"मंदिर में आपका स्वागत है।".',
                },
                {
                  role: "user",
                  content: JSON.stringify(missing),
                },
              ],
              options: {
                temperature: 0,
                num_predict: 2048,
              },
            }),
          },
        );

        if (!ollamaResponse.ok) {
          const errorText = await ollamaResponse.text();
          throw new Error(
            `Ollama HTTP ${ollamaResponse.status}: ${errorText}`,
          );
        }

        const payload = await ollamaResponse.json();
        const translatedText = payload.message?.content;

        if (
          typeof translatedText !== "string" ||
          !translatedText.trim()
        ) {
          throw new Error("Ollama returned an empty response");
        }

        const translated = extractJson(translatedText);

        for (const [field, sourceText] of Object.entries(missing)) {
          const draftText = translated[field];

          if (
            typeof draftText !== "string" ||
            !draftText.trim()
          ) {
            errors.push(
              `${entityType}/${entity.id}/${field}: Missing translation`,
            );
            continue;
          }

          const sourceHash = await sha256(
            `${language}:${entityType}:${entity.id}:${field}:${sourceText}`,
          );

          const { error: insertError } = await dynamicDb
            .from("content_translation_drafts")
            .upsert(
              {
                entity_type: entityType,
                entity_id: entity.id,
                field_name: field,
                source_language: "en",
                target_language: language,
                source_text: sourceText,
                draft_text: draftText,
                source_hash: sourceHash,
                model_name: model,
                review_status: "pending",
              },
              {
                onConflict:
                  "entity_type,entity_id,field_name,target_language,source_hash",
                ignoreDuplicates: true,
              },
            );

          if (insertError) {
            throw insertError;
          }

          created++;
        }
      } catch (error) {
        errors.push(
          `${entityType}/${entity.id}: ${String(error)}`,
        );
      }
    }
  }

  return json({
    success: errors.length === 0,
    provider: "ollama",
    model,
    language,
    created_drafts: created,
    skipped,
    errors,
  });
});
