// deno-lint-ignore-file no-explicit-any
import { createClient } from "npm:@supabase/supabase-js@2";

// TempleVerse staged temple discovery.
// Modes:
// { "mode": "discover", "region": "Varanasi, Uttar Pradesh", "limit": 5 }
// { "mode": "process" }
//
// Authentication: x-ingestion-secret
// External calls are bounded to stay under the Edge Runtime wall-clock limit.
// Stack: SearXNG (search) + Wikipedia + Ollama (AI) + Supabase.
// NOTE: SEARXNG_URL and OLLAMA_BASE_URL must be PUBLIC https URLs
// (e.g. a Cloudflare/ngrok tunnel). Supabase cloud cannot reach localhost.

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-ingestion-secret",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { ...cors, "Content-Type": "application/json" },
  });

const clean = (value: unknown, max = 4000): string =>
  typeof value === "string"
    ? value.replace(/\s+/g, " ").trim().slice(0, max)
    : "";

const slugify = (value: string) =>
  value
    .toLowerCase()
    .normalize("NFKD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "")
    .slice(0, 90);

const unique = <T>(items: T[]): T[] => [...new Set(items)];

const sleep = (ms: number) =>
  new Promise<void>((resolve) => setTimeout(resolve, ms));

const host = (url: string) => {
  try {
    return new URL(url).hostname.replace(/^www\./i, "");
  } catch {
    return "unknown";
  }
};

// Escape LIKE/ILIKE wildcards so names are matched literally.
const escapeLike = (value: string) => value.replace(/[\\%_]/g, "\\$&");

class HttpFailure extends Error {
  status: number;

  constructor(provider: string, status: number, detail: string) {
    super(`${provider} ${status}: ${detail.slice(0, 700)}`);
    this.name = "HttpFailure";
    this.status = status;
  }
}

function isTransient(error: unknown): boolean {
  if (error instanceof HttpFailure) {
    return error.status === 408 || error.status === 429 || error.status >= 500;
  }

  if (error instanceof TypeError) return true; // fetch network failure

  return (
    error instanceof Error &&
    (error.name === "AbortError" ||
      error.name === "TimeoutError" ||
      error.message.includes("network"))
  );
}

// Bounded retries with exponential backoff.
async function fetchWithRetry(
  url: string,
  init: RequestInit,
  provider: string,
  timeoutMs: number,
  attempts = 3,
): Promise<Response> {
  let lastError: unknown;

  for (let attempt = 0; attempt < attempts; attempt++) {
    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), timeoutMs);

    try {
      const response = await fetch(url, {
        ...init,
        signal: controller.signal,
      });

      clearTimeout(timer);

      if (response.ok) return response;

      const detail = await response.text();
      const failure = new HttpFailure(provider, response.status, detail);

      if (!isTransient(failure) || attempt === attempts - 1) {
        throw failure;
      }

      lastError = failure;

      const retryAfter = Number(response.headers.get("retry-after") || 0);
      const delay = retryAfter > 0 ? retryAfter * 1000 : 1200 * 2 ** attempt;

      await sleep(Math.min(delay, 6000));
    } catch (error) {
      clearTimeout(timer);

      if (!isTransient(error) || attempt === attempts - 1) {
        throw error;
      }

      lastError = error;
      await sleep(Math.min(1000 * 2 ** attempt, 5000));
    }
  }

  throw lastError instanceof Error
    ? lastError
    : new Error(`${provider} request failed`);
}

type SearchResult = {
  title: string;
  url: string;
  content: string;
  score: number;
};

type WikiPage = {
  title: string;
  extract: string;
  url: string;
};

type SourceRow = {
  title: string;
  url: string;
  type: string;
};

// -------------------- SEARXNG --------------------

async function searxngSearch(
  query: string,
  baseUrl: string,
  maxResults = 6,
): Promise<SearchResult[]> {
  const endpoint = new URL("/search", baseUrl.replace(/\/+$/, "") + "/");

  endpoint.search = new URLSearchParams({
    q: query,
    format: "json",
    categories: "general",
    language: "en",
  }).toString();

  const response = await fetchWithRetry(
    endpoint.toString(),
    {
      method: "GET",
      headers: {
        "Accept": "application/json",
        "User-Agent": "TempleVerse/1.0 (heritage discovery)",
        "ngrok-skip-browser-warning": "true",
      },
    },
    "SearXNG",
    9000,
    1,
  );

  const payload: any = await response.json();
  const results: any[] = Array.isArray(payload.results) ? payload.results : [];

  return results
    .slice(0, maxResults)
    .map((result: any): SearchResult => ({
      title: clean(result.title, 300),
      url: clean(result.url, 1500),
      content: clean(result.content || result.snippet || result.title, 5000),
      score: Number(result.score || 0),
    }))
    .filter((result) => result.url && result.content);
}

// -------------------- WIKIPEDIA --------------------

async function wikipediaSearch(name: string): Promise<WikiPage[]> {
  const url = new URL("https://en.wikipedia.org/w/api.php");

  url.search = new URLSearchParams({
    action: "query",
    list: "search",
    srsearch: `${name} temple India`,
    format: "json",
    origin: "*",
    srlimit: "2",
  }).toString();

  const response = await fetchWithRetry(
    url.toString(),
    { headers: { "User-Agent": "TempleVerse/1.0 (heritage discovery)" } },
    "Wikipedia",
    9000,
    2,
  );

  const payload: any = await response.json();
  const hits: any[] = payload.query?.search || [];

  const pages = await Promise.all(
    hits.slice(0, 2).map(async (hit: any): Promise<WikiPage | null> => {
      const title = encodeURIComponent(String(hit.title).replace(/ /g, "_"));

      try {
        const summaryResponse = await fetchWithRetry(
          `https://en.wikipedia.org/api/rest_v1/page/summary/${title}`,
          { headers: { "User-Agent": "TempleVerse/1.0 (heritage discovery)" } },
          "Wikipedia summary",
          9000,
          2,
        );

        const summary: any = await summaryResponse.json();

        return {
          title: clean(summary.title, 300),
          extract: clean(summary.extract, 3500),
          url:
            summary.content_urls?.desktop?.page ||
            `https://en.wikipedia.org/wiki/${title}`,
        };
      } catch (error) {
        console.warn("Wikipedia summary failed:", String(error));
        return null;
      }
    }),
  );

  return pages.filter((page): page is WikiPage => page !== null);
}

// -------------------- OLLAMA --------------------

async function ollamaJson(
  prompt: string,
  baseUrl: string,
  model: string,
  opts: { timeoutMs?: number; numCtx?: number; numPredict?: number } = {},
): Promise<any> {
  const { timeoutMs = 55000, numCtx = 4096, numPredict = 900 } = opts;
  const endpoint = `${baseUrl.replace(/\/+$/, "")}/api/generate`;

  console.log("[OLLAMA] model:", model, "prompt chars:", prompt.length);

  const response = await fetchWithRetry(
    endpoint,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "true",
      },
      body: JSON.stringify({
        model,
        prompt:
          `/no_think\nReturn only valid JSON. Do not include markdown fences.\n\n${prompt}`,
        stream: false,
        format: "json",
        think: false,
        keep_alive: "10m",
        options: {
          temperature: 0.1,
          num_ctx: numCtx,
          num_predict: numPredict,
        },
      }),
    },
    `Ollama (${model})`,
    timeoutMs,
    1,
  );

  const payload: any = await response.json();
  const raw: string = typeof payload.response === "string"
    ? payload.response
    : "";

  console.log("[OLLAMA] done:", payload.done, "reason:", payload.done_reason,
    "chars:", raw.length);

  if (!raw.trim()) {
    throw new Error(
      `Ollama returned an empty response for ${model}; done_reason=${
        String(payload.done_reason)
      }, error=${String(payload.error || "none")}`,
    );
  }

  const text = raw.replace(/^```(?:json)?\s*/i, "").replace(/```\s*$/, "")
    .trim();

  try {
    return JSON.parse(text);
  } catch {
    throw new Error(
      `Ollama returned invalid JSON for ${model} (likely cut off; increase num_predict)`,
    );
  }
}

// -------------------- DISCOVERY --------------------

async function discoverNames(
  region: string,
  results: SearchResult[],
  ollamaUrl: string,
  ollamaModel: string,
) {
  const prompt = `
Identify real Hindu temples located in or clearly associated
with ${region} using ONLY the supplied search results.

Return JSON:
{
  "temples": [
    {
      "name": "...",
      "city": null,
      "state": null,
      "source_urls": ["exact supplied URL"]
    }
  ]
}

Rules:
- Include only individually named temples.
- Do not invent names.
- Maximum 8 temples.
- URLs must exactly match supplied URLs.
- Exclude general tourist attractions.
- Use null for unknown locations.

Search results:
${JSON.stringify(results).slice(0, 8000)}
`;

  const data = await ollamaJson(prompt, ollamaUrl, ollamaModel, {
    timeoutMs: 70000,
    numCtx: 4096,
    numPredict: 1000,
  });
  const allowed = new Set(results.map((result) => result.url));
  const seen = new Set<string>();

  return (Array.isArray(data?.temples) ? data.temples : [])
    .map((temple: any) => ({
      name: clean(temple.name, 180),
      city: clean(temple.city, 100) || null,
      state: clean(temple.state, 100) || null,
      source_urls: Array.isArray(temple.source_urls)
        ? (temple.source_urls as string[]).filter((u) => allowed.has(u))
        : ([] as string[]),
    }))
    .filter((temple: any) => {
      const nameKey = temple.name.toLowerCase();

      if (!temple.name || seen.has(nameKey) || !temple.source_urls.length) {
        return false;
      }

      seen.add(nameKey);
      return true;
    }) as {
      name: string;
      city: string | null;
      state: string | null;
      source_urls: string[];
    }[];
}

// -------------------- EXTRACTION --------------------

async function extractTemple(
  name: string,
  region: string,
  wiki: WikiPage[],
  search: SearchResult[],
  ollamaUrl: string,
  ollamaModel: string,
) {
  const sources = [
    ...wiki.map((item) => ({ source_type: "wikipedia", ...item })),
    ...search.map((item) => ({ source_type: "web_search", ...item })),
  ];

  const prompt = `
You are a conservative heritage data extraction system.

Return ONLY valid JSON with this structure:

{
  "is_temple": boolean,
  "name": string,
  "official_name": string|null,
  "local_name": string|null,
  "city": string|null,
  "district": string|null,
  "state": string|null,
  "description": string|null,
  "history": string|null,
  "architecture_summary": string|null,
  "cultural_significance": string|null,
  "main_deity": string|null,
  "architectural_style": string|null,
  "historical_period": string|null,
  "religious_tradition": string|null,
  "temple_category": string|null,
  "festivals": [
    {
      "name": string,
      "description": string|null,
      "usual_calendar_period": string|null
    }
  ],
  "jatras": [
    {
      "name": string,
      "type": "procession|pilgrimage|chariot|annual_utsav|other",
      "description": string|null,
      "route_description": string|null
    }
  ],
  "confidence": number,
  "conflicts": [string]
}

Rules:
- Use only explicitly supported facts.
- Do not invent addresses, coordinates, dates or history.
- history: founding, builders, dynasties, legends and major events, 2-5 sentences.
- architecture_summary: layout, style, structures, materials and notable
  features, 2-4 sentences.
- cultural_significance: worship, festivals, pilgrimage and community role,
  2-4 sentences.
- For each of these three, write only what the sources state; use null when
  they say nothing about it.
- Keep unknown values null.
- Do not infer geographic information.
- Include festivals and Jatras only when explicitly associated
  with THIS temple.
- Separate historical evidence from religious tradition.
- Lower confidence when sources disagree.

Candidate: ${name}
Region: ${region}

Sources:
${JSON.stringify(sources).slice(0, 12000)}
`;

  return await ollamaJson(prompt, ollamaUrl, ollamaModel, {
    timeoutMs: 100000,
    numCtx: 8192,
    numPredict: 2600,
  });
}

// -------------------- DATABASE HELPERS --------------------

function checkDbError(error: any, operation: string) {
  if (error) {
    throw new Error(`${operation}: ${error.message || String(error)}`);
  }
}

// -------------------- EDGE FUNCTION --------------------

Deno.serve(async (request: Request) => {
  if (request.method === "OPTIONS") {
    return new Response("ok", { headers: cors });
  }

  if (request.method !== "POST") {
    return json({ error: "POST required" }, 405);
  }

  const expected = Deno.env.get("INGESTION_CRON_SECRET");

  if (!expected || request.headers.get("x-ingestion-secret") !== expected) {
    return json({ error: "Unauthorized" }, 401);
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  const searxngUrl = Deno.env.get("SEARXNG_URL");
  const ollamaUrl = Deno.env.get("OLLAMA_BASE_URL");
  const ollamaModel = Deno.env.get("OLLAMA_MODEL") || "qwen3:4b";

  const missing = Object.entries({
    SUPABASE_URL: supabaseUrl,
    SUPABASE_SERVICE_ROLE_KEY: serviceKey,
    SEARXNG_URL: searxngUrl,
    OLLAMA_BASE_URL: ollamaUrl,
  })
    .filter(([, value]) => !value)
    .map(([name]) => name);

  if (!supabaseUrl || !serviceKey || !searxngUrl || !ollamaUrl) {
    return json(
      { error: `Missing server secrets: ${missing.join(", ")}` },
      500,
    );
  }

  let body: any;

  try {
    body = await request.json();
  } catch {
    return json({ error: "Invalid JSON request body" }, 400);
  }

  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return json({ error: "Request body must be a JSON object" }, 400);
  }

  const mode: string = body.mode || "discover";

  if (!["discover", "process"].includes(mode)) {
    return json({ error: "Invalid mode. Use discover or process." }, 400);
  }

  const db = createClient(supabaseUrl, serviceKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  // =====================================================
  // MODE 1: DISCOVER
  // =====================================================

  if (mode === "discover") {
    const requestedRegion = clean(body.region, 180);
    const limit = Math.max(1, Math.min(Number(body.limit || 5), 8));

    const regionQuery = requestedRegion
      ? db
        .from("discovery_region_queue")
        .select("*")
        .eq("region_name", requestedRegion)
        .eq("enabled", true)
        .maybeSingle()
      : db
        .from("discovery_region_queue")
        .select("*")
        .eq("enabled", true)
        .order("priority")
        .order("completed_at", { ascending: true, nullsFirst: true })
        .limit(1)
        .maybeSingle();

    const { data: region, error: regionError }: any = await regionQuery;

    if (regionError) {
      return json({ error: regionError.message }, 500);
    }

    if (!region) {
      return json({
        error: requestedRegion
          ? "Region not found in enabled queue"
          : "No enabled regions remain",
      }, 404);
    }

    const { data: run, error: runError }: any = await db
      .from("ingestion_runs")
      .insert({
        run_type: "searxng_wikipedia_ollama_temple_discovery",
        source_scope: region.region_name,
        status: "running",
        started_at: new Date().toISOString(),
      })
      .select()
      .single();

    if (runError || !run) {
      return json({ error: runError?.message || "Could not create run" }, 500);
    }

    try {
      const results = await searxngSearch(
        `major Hindu temples in ${region.region_name} India official temple history`,
        searxngUrl,
        6,
      );

      if (!results.length) {
        throw new Error("SearXNG returned no usable search results");
      }

      const candidates = await discoverNames(
        region.region_name,
        results,
        ollamaUrl,
        ollamaModel,
      );

      let insertedCount = 0;
      let existingCount = 0;

      for (const candidate of candidates.slice(0, limit)) {
        const row = {
          region_name: region.region_name,
          candidate_name: candidate.name,
          candidate_slug: slugify(candidate.name),
          city: candidate.city,
          state: candidate.state || region.state_name || null,
          discovery_source_urls: candidate.source_urls,
          status: "queued",
          updated_at: new Date().toISOString(),
        };

        const { data, error }: any = await db
          .from("temple_discovery_tasks")
          .upsert(row, {
            onConflict: "region_name,candidate_slug",
            ignoreDuplicates: true,
          })
          .select("id");

        checkDbError(error, "Queue candidate");

        if (data && data.length > 0) {
          insertedCount++;
        } else {
          existingCount++;
        }
      }

      await db
        .from("ingestion_runs")
        .update({
          status: "completed",
          completed_at: new Date().toISOString(),
          summary: {
            mode,
            region: region.region_name,
            candidates_found: candidates.length,
            newly_queued: insertedCount,
            already_existing: existingCount,
          },
        })
        .eq("id", run.id);

      return json({
        run_id: run.id,
        mode,
        region: region.region_name,
        candidates_found: candidates.length,
        newly_queued: insertedCount,
        already_existing: existingCount,
        next_step: "Call again with mode=process to research one queued temple.",
      });
    } catch (error) {
      const message = String(error);

      await db
        .from("ingestion_runs")
        .update({
          status: "failed",
          completed_at: new Date().toISOString(),
          error_message: message,
        })
        .eq("id", run.id);

      return json({
        run_id: run.id,
        mode,
        region: region.region_name,
        error: message,
      }, 502);
    }
  }

  // =====================================================
  // MODE 2: PROCESS ONE QUEUED CANDIDATE
  // =====================================================

  const { data: task, error: claimError }: any = await db.rpc(
    "claim_temple_discovery_task",
  );

  if (claimError) {
    return json({ error: claimError.message }, 500);
  }

  const item: any = Array.isArray(task) ? task[0] : task;

  if (!item) {
    return json({ mode, message: "No queued discovery tasks." });
  }

  const { data: processRun, error: processRunError }: any = await db
    .from("ingestion_runs")
    .insert({
      run_type: "temple_candidate_research",
      source_scope: item.region_name,
      status: "running",
      started_at: new Date().toISOString(),
    })
    .select()
    .single();

  if (processRunError || !processRun) {
    const message = processRunError?.message || "Could not create run";

    await db
      .from("temple_discovery_tasks")
      .update({
        status: "queued",
        last_error: message,
        updated_at: new Date().toISOString(),
      })
      .eq("id", item.id);

    return json({ task_id: item.id, error: message }, 500);
  }

  try {
    // Duplicate check (by slug, then by case-insensitive exact name).
    const bySlug: any = await db
      .from("temples")
      .select("id,slug,name")
      .eq("slug", item.candidate_slug)
      .limit(1)
      .maybeSingle();

    checkDbError(bySlug.error, "Duplicate check (slug)");

    let existing = bySlug.data;

    if (!existing) {
      const byName: any = await db
        .from("temples")
        .select("id,slug,name")
        .ilike("name", escapeLike(String(item.candidate_name)))
        .limit(1)
        .maybeSingle();

      checkDbError(byName.error, "Duplicate check (name)");
      existing = byName.data;
    }

    if (existing) {
      await db
        .from("temple_discovery_tasks")
        .update({
          status: "completed",
          temple_id: existing.id,
          last_error: null,
          updated_at: new Date().toISOString(),
        })
        .eq("id", item.id);

      await db
        .from("ingestion_runs")
        .update({
          status: "completed",
          completed_at: new Date().toISOString(),
          summary: { outcome: "duplicate", temple_id: existing.id },
        })
        .eq("id", processRun.id);

      return json({
        mode,
        task_id: item.id,
        candidate: item.candidate_name,
        outcome: "duplicate",
        temple_id: existing.id,
      });
    }

    // Gather independent source material.
    const [wiki, search] = await Promise.all([
      wikipediaSearch(item.candidate_name).catch((error): WikiPage[] => {
        console.warn("Wikipedia failed:", String(error));
        return [];
      }),

      searxngSearch(
        `"${item.candidate_name}" temple ${item.region_name} official history architecture festivals`,
        searxngUrl,
        5,
      ).catch((error): SearchResult[] => {
        console.warn("SearXNG research failed:", String(error));
        return [];
      }),
    ]);

    const extracted: any = await extractTemple(
      item.candidate_name,
      item.region_name,
      wiki,
      search,
      ollamaUrl,
      ollamaModel,
    );

    const sourceRows: SourceRow[] = [
      ...((item.discovery_source_urls || []) as string[]).map((url) => ({
        title: String(item.candidate_name),
        url,
        type: "SearXNG discovery",
      })),
      ...wiki.map((source) => ({
        title: source.title || String(item.candidate_name),
        url: source.url,
        type: "Wikipedia",
      })),
      ...search.map((source) => ({
        title: source.title || String(item.candidate_name),
        url: source.url,
        type: "Web search",
      })),
    ].filter((source) => source.url);

    // De-duplicate by URL.
    const sourceMap = new Map<string, SourceRow>();
    for (const source of sourceRows) {
      if (!sourceMap.has(source.url)) sourceMap.set(source.url, source);
    }
    const sources: SourceRow[] = [...sourceMap.values()];

    const hosts = unique(sources.map((source) => host(source.url))).filter(
      (value) => value !== "unknown",
    );

    const name = clean(extracted?.name, 180);

    // Fuzzy name match: ignore case, punctuation and generic words.
    const STOP = new Set([
      "temple", "mandir", "mandira", "devi", "sri", "shri", "the", "of",
      "shree", "sree", "dham", "ji",
    ]);
    const tokens = (value: string) =>
      slugify(value).split("-").filter((t) => t && !STOP.has(t));
    const a = tokens(name);
    const b = tokens(String(item.candidate_name));
    const overlap = a.filter((t) => b.includes(t)).length;
    const nameMatches =
      name.length > 0 &&
      (name.toLowerCase() === String(item.candidate_name).toLowerCase() ||
        (Math.min(a.length, b.length) > 0 &&
          overlap >= Math.min(a.length, b.length)));

    const confidence = Number(extracted?.confidence || 0);
    const conflictCount = Array.isArray(extracted?.conflicts)
      ? extracted.conflicts.length
      : 0;

    const reasons: string[] = [];
    if (extracted?.is_temple !== true) reasons.push("not_a_temple");
    if (!nameMatches) reasons.push(`name_mismatch(${name})`);
    if (wiki.length + search.length < 2) reasons.push("too_few_sources");
    if (hosts.length < 2) reasons.push("too_few_domains");
    if (confidence < 0.7) reasons.push(`low_confidence(${confidence})`);
    if (conflictCount > 2) reasons.push(`conflicts(${conflictCount})`);

    const good = reasons.length === 0;

    // Hold insufficient evidence.
    if (!good) {
      const { error }: any = await db.from("temple_candidates").insert({
        ingestion_run_id: processRun.id,
        proposed_name: name || item.candidate_name,
        proposed_slug: item.candidate_slug,
        location_text: [item.city, item.state, "India"].filter(Boolean).join(
          ", ",
        ),
        source_url: sources[0]?.url || "",
        extracted_metadata: { ...extracted, sources, hold_reasons: reasons },
        review_status: "needs_research",
      });

      checkDbError(error, "Save research candidate");

      await db
        .from("temple_discovery_tasks")
        .update({
          status: "held",
          extracted_metadata: { ...extracted, sources, hold_reasons: reasons },
          last_error: reasons.join(", "),
          updated_at: new Date().toISOString(),
        })
        .eq("id", item.id);

      await db
        .from("ingestion_runs")
        .update({
          status: "completed",
          completed_at: new Date().toISOString(),
          summary: {
            outcome: "held_for_research",
            sources: sources.length,
            reasons,
          },
        })
        .eq("id", processRun.id);

      return json({
        mode,
        task_id: item.id,
        candidate: item.candidate_name,
        outcome: "held_for_research",
        sources: sources.length,
        reasons,
      });
    }

    // Slug collision check for the extracted name.
    const finalSlug = slugify(name);
    const slugClash: any = await db
      .from("temples")
      .select("id")
      .eq("slug", finalSlug)
      .limit(1)
      .maybeSingle();

    checkDbError(slugClash.error, "Slug check");

    if (slugClash.data) {
      await db
        .from("temple_discovery_tasks")
        .update({
          status: "completed",
          temple_id: slugClash.data.id,
          last_error: null,
          updated_at: new Date().toISOString(),
        })
        .eq("id", item.id);

      await db
        .from("ingestion_runs")
        .update({
          status: "completed",
          completed_at: new Date().toISOString(),
          summary: { outcome: "duplicate", temple_id: slugClash.data.id },
        })
        .eq("id", processRun.id);

      return json({
        mode,
        task_id: item.id,
        candidate: item.candidate_name,
        outcome: "duplicate",
        temple_id: slugClash.data.id,
      });
    }

    // Publish sufficiently supported temple.
    const city = clean(extracted.city, 100) || item.city;
    const state = clean(extracted.state, 100) || item.state;

    const metadata = {
      ...extracted,
      provider: "searxng_wikipedia_ollama",
      region: item.region_name,
      sources,
      extracted_at: new Date().toISOString(),
    };

    const { data: inserted, error: insertError }: any = await db
      .from("temples")
      .insert({
        slug: finalSlug,
        name,
        official_name: clean(extracted.official_name, 180) || name,
        local_name: clean(extracted.local_name, 180) || null,
        location: [city, state, "India"].filter(Boolean).join(", "),
        city,
        state,
        country: "India",
        latitude: null,
        longitude: null,
        description: clean(extracted.description, 1800) || null,
        history: clean(extracted.history, 5000) || null,
        architecture_summary: clean(extracted.architecture_summary, 2500) || null,
        cultural_significance: clean(extracted.cultural_significance, 2500) || null,
        main_deity: clean(extracted.main_deity, 180) || null,
        architectural_style: clean(extracted.architectural_style, 180) || null,
        historical_period: clean(extracted.historical_period, 180) || null,
        religious_tradition: clean(extracted.religious_tradition, 180) || null,
        temple_category:
          clean(extracted.temple_category, 100) || "Hindu temple",
        discovery_status: "auto_published",
        discovery_sources: sources,
        metadata,
        verification_status: "source_supported",
        published: true,
      })
      .select("id")
      .single();

    checkDbError(insertError, "Insert temple");

    if (!inserted) {
      throw new Error("Temple insert returned no data");
    }

    // Save source records and associations.
    for (const source of sources) {
      const prior: any = await db
        .from("sources")
        .select("id")
        .eq("url", source.url)
        .limit(1)
        .maybeSingle();

      checkDbError(prior.error, "Find source");

      let sourceId: string | undefined = prior.data?.id;

      if (!sourceId) {
        const created: any = await db
          .from("sources")
          .insert({
            title: source.title,
            url: source.url,
            source_type: source.type,
          })
          .select("id")
          .single();

        checkDbError(created.error, "Insert source");
        sourceId = created.data?.id;
      }

      if (sourceId) {
        const { error }: any = await db
          .from("temple_sources")
          .upsert(
            { temple_id: inserted.id, source_id: sourceId },
            { onConflict: "temple_id,source_id" },
          );

        checkDbError(error, "Associate source");
      }
    }

    // Save festivals.
    const festivals: any[] = Array.isArray(extracted.festivals)
      ? extracted.festivals.slice(0, 10)
      : [];

    for (const festival of festivals) {
      const festivalName = clean(festival?.name, 180);
      if (!festivalName) continue;

      const festivalResult: any = await db
        .from("festivals")
        .upsert(
          {
            canonical_name: festivalName,
            description: clean(festival.description, 1200) || null,
            usual_calendar_period:
              clean(festival.usual_calendar_period, 120) || null,
          },
          { onConflict: "canonical_name" },
        )
        .select("id")
        .single();

      checkDbError(festivalResult.error, "Save festival");

      if (festivalResult.data?.id) {
        const { error }: any = await db
          .from("temple_festivals")
          .upsert(
            { temple_id: inserted.id, festival_id: festivalResult.data.id },
            { onConflict: "temple_id,festival_id" },
          );

        checkDbError(error, "Associate festival");
      }
    }

    // Save Jatras as pending verification.
    const jatraTypes = [
      "procession",
      "pilgrimage",
      "chariot",
      "annual_utsav",
      "other",
    ];

    const jatras: any[] = Array.isArray(extracted.jatras)
      ? extracted.jatras.slice(0, 8)
      : [];

    for (const jatra of jatras) {
      const jatraName = clean(jatra?.name, 180);
      if (!jatraName) continue;

      const jatraResult: any = await db
        .from("jatras")
        .upsert(
          {
            canonical_name: jatraName,
            jatra_type: jatraTypes.includes(jatra.type) ? jatra.type : "other",
            description: clean(jatra.description, 1200) || null,
            route_description: clean(jatra.route_description, 1000) || null,
            verification_status: "pending",
          },
          { onConflict: "canonical_name" },
        )
        .select("id")
        .single();

      checkDbError(jatraResult.error, "Save Jatra");

      if (jatraResult.data?.id) {
        const { error }: any = await db
          .from("temple_jatras")
          .upsert(
            {
              temple_id: inserted.id,
              jatra_id: jatraResult.data.id,
              role: "associated",
            },
            { onConflict: "temple_id,jatra_id,role" },
          );

        checkDbError(error, "Associate Jatra");
      }
    }

    // Mark task complete only after all associations succeed.
    const { error: taskUpdateError }: any = await db
      .from("temple_discovery_tasks")
      .update({
        status: "completed",
        temple_id: inserted.id,
        extracted_metadata: metadata,
        last_error: null,
        updated_at: new Date().toISOString(),
      })
      .eq("id", item.id);

    checkDbError(taskUpdateError, "Complete discovery task");

    await db
      .from("ingestion_runs")
      .update({
        status: "completed",
        completed_at: new Date().toISOString(),
        summary: {
          outcome: "published",
          temple_id: inserted.id,
          sources: sources.length,
        },
      })
      .eq("id", processRun.id);

    return json({
      mode,
      task_id: item.id,
      candidate: name,
      outcome: "published",
      temple_id: inserted.id,
      sources: sources.length,
    });
  } catch (error) {
    const message = String(error);

    // Preserve the task for retry unless its retry limit is reached.
    const attempts = Number(item.attempts || 1);
    const nextStatus = attempts >= 3 ? "failed" : "queued";

    await db
      .from("temple_discovery_tasks")
      .update({
        status: nextStatus,
        last_error: message.slice(0, 1500),
        updated_at: new Date().toISOString(),
      })
      .eq("id", item.id);

    await db
      .from("ingestion_runs")
      .update({
        status: "failed",
        completed_at: new Date().toISOString(),
        error_message: message,
      })
      .eq("id", processRun.id);

    return json({
      mode,
      task_id: item.id,
      candidate: item.candidate_name,
      error: message,
      retry_scheduled: nextStatus === "queued",
    }, 502);
  }
});