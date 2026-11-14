// Temple catalogue service. Supabase is the source of truth when configured;
// local demo records are used only as an explicit development fallback.
import { supabase, isSupabaseConfigured } from "../lib/supabase";
import { TEMPLES, LOCATIONS, GUIDED_STEPS } from "../data/demoData";
import { rankTemples, buildVocabulary, didYouMean } from "../lib/searchRank";

export const dataSource = {
  mode: isSupabaseConfigured ? "supabase" : "demo",
  ready: false,
  lastError: null,
};

let cataloguePromise = null;
const demoLatency = () => new Promise((resolve) => setTimeout(resolve, 200));

const optionalData = (result) => result?.error ? [] : (result?.data || []);

async function fetchFromSupabase() {
  const [
    templesRes, translationsRes, locationsRes, locationTransRes,
    stepsRes, stepTransRes, timelineRes, templeSourcesRes, discoveryRes,
    imagesRes, templeFestivalsRes, templeJatrasRes,
    festivalEventsRes, jatraEventsRes, festivalTranslationsRes, jatraTranslationsRes,
  ] = await Promise.all([
    supabase.from("temples").select("*").eq("published", true).order("name"),
    supabase.from("temple_translations").select("*, languages(code)"),
    supabase.from("temple_locations").select("*").order("display_order"),
    supabase.from("location_translations").select("*, languages(code)"),
    supabase.from("guided_steps").select("*").order("step_number"),
    supabase.from("guided_step_translations").select("*, languages(code)"),
    supabase.from("temple_timeline").select("*").order("display_order"),
    supabase.from("temple_sources").select("temple_id, sources(*)"),
    supabase.from("temple_discovery_metadata").select("*"),
    supabase.from("images").select("*").eq("verified", true).order("display_order"),
    supabase.from("temple_festivals").select("temple_id, local_name, festivals(*)"),
    supabase.from("temple_jatras").select("temple_id, local_name, role, notes, jatras(*)"),
    supabase.from("festival_events").select("*").eq("verification_status", "verified").order("starts_on"),
    supabase.from("jatra_events").select("*").eq("verification_status", "verified").order("starts_on"),
    supabase.from("festival_translations").select("*, languages(code)"),
    supabase.from("jatra_translations").select("*, languages(code)"),
  ]);

  const required = [
    ["temples", templesRes], ["temple_translations", translationsRes],
    ["temple_locations", locationsRes], ["location_translations", locationTransRes],
    ["guided_steps", stepsRes], ["guided_step_translations", stepTransRes],
    ["temple_discovery_metadata", discoveryRes],
  ];
  const failed = required.find(([, result]) => result.error);
  if (failed) throw new Error(`Supabase query failed: ${failed[0]} — ${failed[1].error.message}`);

  const attachTrans = (rows, targetIdField) => {
    const map = {};
    for (const row of rows || []) {
      const targetId = row[targetIdField];
      const code = row.languages?.code || "en";
      if (!map[targetId]) map[targetId] = {};
      map[targetId][code] = { ...row, language_code: code };
    }
    return map;
  };
  const cleanTranslations = (transMap, id) => Object.fromEntries(
    Object.entries(transMap[id] || {}).map(([code, value]) => {
      const { languages, language_id, id: rowId, ...fields } = value;
      return [code, fields];
    }),
  );
  const templeTrans = attachTrans(translationsRes.data, "temple_id");
  const locationTrans = attachTrans(locationTransRes.data, "location_id");
  const stepTrans = attachTrans(stepTransRes.data, "step_id");

  const timelineByTemple = {};
  for (const row of optionalData(timelineRes)) {
    (timelineByTemple[row.temple_id] ||= []).push({
      year: row.year_label, event: row.event, display_order: row.display_order,
    });
  }
  const discoveryByTemple = Object.fromEntries(
    (discoveryRes.data || []).map((row) => [row.temple_id, row]),
  );
  const sourcesByTemple = {};
  for (const row of optionalData(templeSourcesRes)) {
    const source = row.sources;
    if (source) (sourcesByTemple[row.temple_id] ||= []).push({
      id: source.id, title: source.title, url: source.url, type: source.source_type,
    });
  }
  const galleryByTemple = {};
  const galleryByLocation = {};
  for (const image of optionalData(imagesRes)) {
    if (image.temple_id) (galleryByTemple[image.temple_id] ||= []).push(image);
    if (image.location_id) (galleryByLocation[image.location_id] ||= []).push(image);
  }
  const translationsByEntity = (rows, foreignKey) => {
    const map = {};
    for (const row of optionalData({ data: rows })) {
      const code = row.languages?.code || "en";
      (map[row[foreignKey]] ||= {})[code] = Object.fromEntries(
        Object.entries(row).filter(([key]) => !["languages", "language_id", "id"].includes(key)),
      );
    }
    return map;
  };
  const festivalTrans = translationsByEntity(festivalTranslationsRes.data, "festival_id");
  const jatraTrans = translationsByEntity(jatraTranslationsRes.data, "jatra_id");

  const festivalsByTemple = {};
  for (const row of optionalData(templeFestivalsRes)) {
    if (row.festivals) (festivalsByTemple[row.temple_id] ||= []).push({
      ...row.festivals,
      local_name: row.local_name,
      temple_details: {
        duration_days: row.duration_days,
        procession_traditions: row.procession_traditions,
        chariot_festival: row.chariot_festival,
        special_offerings: row.special_offerings,
        cultural_notes: row.cultural_notes,
      },
      translations: festivalTrans[row.festival_id] || {},
      events: optionalData(festivalEventsRes).filter((event) =>
        event.temple_id === row.temple_id && event.festival_id === row.festival_id),
    });
  }
  const jatrasByTemple = {};
  for (const row of optionalData(templeJatrasRes)) {
    if (row.jatras?.verification_status === "verified") {
      (jatrasByTemple[row.temple_id] ||= []).push({
        ...row.jatras,
        local_name: row.local_name,
        role: row.role,
        association_notes: row.notes,
        translations: jatraTrans[row.jatra_id] || {},
        events: optionalData(jatraEventsRes).filter((event) =>
          event.jatra_id === row.jatra_id && (!event.temple_id || event.temple_id === row.temple_id)),
      });
    }
  }

  const temples = (templesRes.data || []).map((row) => ({
    ...row,
    translations: cleanTranslations(templeTrans, row.id),
    timeline: timelineByTemple[row.id] || [],
    sources: sourcesByTemple[row.id] || [],
    gallery: galleryByTemple[row.id] || [],
    festivals: festivalsByTemple[row.id] || [],
    jatras: jatrasByTemple[row.id] || [],
    discovery_metadata: discoveryByTemple[row.id] || {},
  }));
  const locations = (locationsRes.data || []).map((row) => ({
    ...row,
    translations: cleanTranslations(locationTrans, row.id),
    gallery: galleryByLocation[row.id] || [],
  }));
  const guided_steps = (stepsRes.data || []).map((row) => ({
    ...row, translations: cleanTranslations(stepTrans, row.id),
  }));

  return { temples, locations, guided_steps };
}

async function getCatalogue() {
  if (cataloguePromise) return cataloguePromise;
  cataloguePromise = (async () => {
    if (isSupabaseConfigured && supabase) {
      try {
        const data = await fetchFromSupabase();
        dataSource.mode = "supabase";
        dataSource.lastError = null;
        dataSource.ready = true;
        return data;
      } catch (error) {
        dataSource.lastError = error instanceof Error ? error.message : String(error);
        console.error("TempleVerse: Supabase catalogue unavailable.", error);
      }
    }
    dataSource.mode = isSupabaseConfigured ? "demo-fallback" : "demo";
    dataSource.ready = true;
    await demoLatency();
    return { temples: TEMPLES, locations: LOCATIONS, guided_steps: GUIDED_STEPS };
  })();
  return cataloguePromise;
}

const hasServerFilters = (filters) => Object.values(filters).some(
  (value) => typeof value === "string" && value.trim(),
);

/** Metadata filters applied locally (demo mode, and the fuzzy fallback). */
function matchesFilters(temple, { state, deity, architecture, dynasty, festival, jatra, category, tradition }) {
  const metadata = temple.metadata || {};
  const discovery = temple.discovery_metadata || temple;
  const match = (needle, haystack) => !needle || String(haystack || "").toLocaleLowerCase().includes(needle.toLocaleLowerCase());
  return match(state, temple.state)
    && match(deity, [temple.main_deity, ...(discovery.associated_deities || [])].join(" "))
    && match(architecture, [temple.architectural_style, metadata.architecture?.architectural_style].join(" "))
    && match(dynasty, [temple.historical_period, ...(discovery.associated_dynasties || []), JSON.stringify(metadata.history || {})].join(" "))
    && match(festival, [...(temple.festivals || []).map((f) => f.canonical_name), JSON.stringify(metadata.festivals || {})].join(" "))
    && match(jatra, (temple.jatras || []).map((j) => j.canonical_name).join(" "))
    && match(category, metadata.identity?.temple_category || temple.temple_category)
    && match(tradition, metadata.identity?.religious_tradition || temple.religious_tradition);
}

export async function getTemples({
  search = "", state = "", deity = "", architecture = "", dynasty = "",
  festival = "", jatra = "", category = "", tradition = "",
} = {}) {
  const catalogue = await getCatalogue();
  let rows = catalogue.temples;
  const query = search.trim();

  const filters = { search, state, deity, architecture, dynasty, festival, jatra, category, tradition };
  if (dataSource.mode === "supabase" && hasServerFilters(filters)) {
    const { data, error } = await supabase.rpc("search_temples", {
      p_query: search || null, p_state: state || null, p_deity: deity || null,
      p_architecture: architecture || null, p_dynasty: dynasty || null,
      p_festival: festival || null, p_jatra: jatra || null,
      p_category: category || null, p_tradition: tradition || null,
      p_limit: 100, p_offset: 0,
    });
    if (error) throw new Error(`Temple search failed: ${error.message}`);
    // Use the catalogue's own objects so ranking indexes are reused, then
    // re-rank: the server sorts alphabetically, which buries the best match.
    const byId = new Map(rows.map((temple) => [temple.id, temple]));
    rows = (data || []).map((row) => byId.get(row.id) || { ...row, translations: {} });
    if (query) rows = rankTemples(rows, query, { keepUnmatched: true });
    // Typos and variant spellings return nothing from SQL: fall back to fuzzy
    // matching over the catalogue we already hold, honouring the same filters.
    if (query && rows.length === 0) {
      rows = rankTemples(catalogue.temples.filter((t) => matchesFilters(t, filters)), query);
    }
  } else if (query) {
    rows = rankTemples(rows.filter((t) => matchesFilters(t, filters)), query);
  } else {
    rows = rows.filter((t) => matchesFilters(t, filters));
  }

  const locationCounts = new Map();
  for (const location of catalogue.locations) {
    locationCounts.set(location.temple_id, (locationCounts.get(location.temple_id) || 0) + 1);
  }
  return rows.map((temple) => ({
    ...temple,
    location_count: locationCounts.get(temple.id) || 0,
    language_codes: ["en", ...Object.keys(temple.translations || {}).filter((code) => code !== "en")],
  }));
}

/**
 * Instant suggestions while typing: best-matching temples plus a spelling
 * correction. Runs on the already-loaded catalogue, so it makes no request.
 */
export async function getSearchAssist(query, { limit = 6 } = {}) {
  const q = String(query || "").trim();
  if (q.length < 2) return { suggestions: [], correction: null };
  const { temples } = await getCatalogue();
  const suggestions = rankTemples(temples, q).slice(0, limit);
  const correction = didYouMean(q, buildVocabulary(temples));
  return { suggestions, correction };
}

export async function getTempleBySlug(slug) {
  const { temples, locations, guided_steps } = await getCatalogue();
  const temple = temples.find((item) => item.slug === slug);
  if (!temple) return null;
  return {
    ...temple,
    locations: locations.filter((item) => item.temple_id === temple.id)
      .sort((a, b) => a.display_order - b.display_order),
    guided_steps: guided_steps.filter((item) => item.temple_id === temple.id)
      .sort((a, b) => a.step_number - b.step_number),
  };
}

export async function getStates() {
  const { temples } = await getCatalogue();
  return [...new Set(temples.map((temple) => temple.state).filter(Boolean))].sort();
}

export async function getTempleFilterOptions() {
  if (isSupabaseConfigured && supabase) {
    const { data, error } = await supabase.rpc("get_temple_filter_options");
    if (!error && data) return data;
    if (error) console.warn("TempleVerse: using local filter facets.", error.message);
  }
  const { temples } = await getCatalogue();
  const collect = (getter) => [...new Set(temples.flatMap(getter).filter(Boolean))].sort();
  return {
    states: collect((t) => [t.state]),
    deities: collect((t) => [t.main_deity, ...(t.discovery_metadata?.associated_deities || [])]),
    architectures: collect((t) => [t.architectural_style, t.metadata?.architecture?.architectural_style]),
    dynasties: collect((t) => [...(t.discovery_metadata?.associated_dynasties || []), t.metadata?.history?.original_dynasty]),
    festivals: collect((t) => [...(t.festivals || []).map((f) => f.canonical_name), ...(t.discovery_metadata?.festivals || [])]),
    jatras: collect((t) => (t.jatras || []).map((j) => j.canonical_name)),
    categories: collect((t) => [t.temple_category, t.metadata?.identity?.temple_category]),
    traditions: collect((t) => [t.religious_tradition, t.metadata?.identity?.religious_tradition]),
  };
}


/** Server-paginated search for the scalable catalogue and future filter UI. */
export async function searchTemplePage({
  search = "", state = "", deity = "", architecture = "", dynasty = "",
  festival = "", jatra = "", category = "", tradition = "", limit = 24, offset = 0,
} = {}) {
  if (!isSupabaseConfigured || !supabase) {
    const all = await getTemples({ search, state, deity, architecture, dynasty, festival, jatra, category, tradition });
    const start = Math.max(0, Number(offset) || 0);
    return { items: all.slice(start, start + limit), hasMore: start + limit < all.length };
  }
  const pageSize = Math.max(1, Math.min(Number(limit) || 24, 99));
  const { data, error } = await supabase.rpc("search_temples", {
    p_query: search || null, p_state: state || null, p_deity: deity || null,
    p_architecture: architecture || null, p_dynasty: dynasty || null,
    p_festival: festival || null, p_jatra: jatra || null,
    p_category: category || null, p_tradition: tradition || null,
    p_limit: pageSize + 1, p_offset: Math.max(0, Number(offset) || 0),
  });
  if (error) throw new Error(`Temple search failed: ${error.message}`);
  const resultRows = data || [];
  const hasMore = resultRows.length > pageSize;
  const rows = resultRows.slice(0, pageSize);
  const ids = rows.map((row) => row.id);
  if (!ids.length) return { items: [], hasMore: false };
  const [translationsRes, discoveryRes, locationsRes] = await Promise.all([
    supabase.from("temple_translations").select("*, languages(code)").in("temple_id", ids),
    supabase.from("temple_discovery_metadata").select("*").in("temple_id", ids),
    supabase.from("temple_locations").select("temple_id").in("temple_id", ids),
  ]);
  if (translationsRes.error) throw translationsRes.error;
  if (discoveryRes.error) throw discoveryRes.error;
  if (locationsRes.error) throw locationsRes.error;
  const translations = {};
  for (const row of translationsRes.data || []) {
    const code = row.languages?.code || "en";
    const { languages, language_id, id: rowId, ...fields } = row;
    (translations[row.temple_id] ||= {})[code] = fields;
  }
  const discovery = Object.fromEntries((discoveryRes.data || []).map((row) => [row.temple_id, row]));
  const counts = {};
  for (const row of locationsRes.data || []) counts[row.temple_id] = (counts[row.temple_id] || 0) + 1;
  return {
    items: rows.map((row) => ({
      ...row, translations: translations[row.id] || {},
      discovery_metadata: discovery[row.id] || {},
      location_count: counts[row.id] || 0,
      language_codes: ["en", ...Object.keys(translations[row.id] || {}).filter((code) => code !== "en")],
    })),
    hasMore,
  };
}

export function resetTempleCatalogueCache() {
  cataloguePromise = null;
}
