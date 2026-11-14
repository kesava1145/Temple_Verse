// One-time import of Indian Hindu temples from Wikidata + Wikipedia (free, no API keys).
// Usage: SUPABASE_SERVICE_ROLE_KEY=... node import-temples.mjs [maxTemples]
import { createClient } from "@supabase/supabase-js";

const URL_ = process.env.VITE_SUPABASE_URL || "https://yqdbmyvxidwnlzsymcrc.supabase.co";
const KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const MAX = Number(process.argv[2] || 600);
if (!KEY) { console.error("Set SUPABASE_SERVICE_ROLE_KEY first."); process.exit(1); }

const db = createClient(URL_, KEY, { auth: { persistSession: false } });
const UA = { "User-Agent": "TempleVerse/1.0 (heritage import; contact: you@example.com)" };
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const clean = (s, n = 1800) => (typeof s === "string" ? s.replace(/\s+/g, " ").trim().slice(0, n) : "");
const slugify = (s) => s.toLowerCase().normalize("NFKD").replace(/[\u0300-\u036f]/g, "")
  .replace(/[^a-z0-9]+/g, "-").replace(/^-|-$/g, "").slice(0, 90);

const SPARQL = `
SELECT ?item ?itemLabel (SAMPLE(?coord) AS ?c) (SAMPLE(?article) AS ?a) (SAMPLE(?stateLabel) AS ?st) WHERE {
  ?item wdt:P31/wdt:P279* wd:Q842402 ; wdt:P17 wd:Q668 ; wdt:P625 ?coord .
  ?article schema:about ?item ; schema:isPartOf <https://en.wikipedia.org/> .
  OPTIONAL { ?item wdt:P131+ ?state . ?state wdt:P31 wd:Q12443800 . }
  SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
}
GROUP BY ?item ?itemLabel
LIMIT ${MAX * 2}`;

async function getJson(url, tries = 3) {
  for (let i = 0; i < tries; i++) {
    try {
      const r = await fetch(url, { headers: { ...UA, Accept: "application/json" } });
      if (r.ok) return await r.json();
      if (r.status === 404) return null;
    } catch { /* retry */ }
    await sleep(1500 * (i + 1));
  }
  return null;
}

console.log("Querying Wikidata (can take up to a minute)...");
const wd = await getJson("https://query.wikidata.org/sparql?format=json&query=" + encodeURIComponent(SPARQL));
if (!wd) { console.error("Wikidata query failed. Try again in a few minutes."); process.exit(1); }

let rows = wd.results.bindings.map((b) => {
  const m = /Point\(([-\d.]+) ([-\d.]+)\)/.exec(b.c?.value || "");
  return {
    qid: b.item.value.split("/").pop(),
    name: clean(b.itemLabel?.value, 180),
    lon: m ? Number(m[1]) : null,
    lat: m ? Number(m[2]) : null,
    state: clean(b.st?.value, 100) || null,
    wiki: b.a?.value,
  };
}).filter((r) => r.name && !/^Q\d+$/.test(r.name) && r.lat !== null && r.wiki);
console.log(`Wikidata returned ${rows.length} usable temples.`);

const { data: existing } = await db.from("temples").select("slug,name");
const slugs = new Set((existing || []).map((t) => t.slug));
const names = new Set((existing || []).map((t) => t.name.toLowerCase()));

const out = [];
let done = 0;
for (const r of rows) {
  if (out.length >= MAX) break;
  if (names.has(r.name.toLowerCase())) continue;
  const title = decodeURIComponent(r.wiki.split("/wiki/")[1] || "");
  const s = await getJson("https://en.wikipedia.org/api/rest_v1/page/summary/" + encodeURIComponent(title));
  await sleep(120);
  done++;
  if (done % 25 === 0) console.log(`  looked up ${done}...`);
  const extract = clean(s?.extract);
  if (extract.length < 60) continue;

  let slug = slugify(r.name);
  if (!slug) continue;
  if (slugs.has(slug)) slug = `${slug}-${r.qid.toLowerCase()}`;
  if (slugs.has(slug)) continue;
  slugs.add(slug); names.add(r.name.toLowerCase());

  const wikiUrl = s?.content_urls?.desktop?.page || r.wiki;
  const wdUrl = `https://www.wikidata.org/wiki/${r.qid}`;
  const sources = [
    { title: s?.title || r.name, url: wikiUrl, type: "Wikipedia" },
    { title: `${r.name} (Wikidata)`, url: wdUrl, type: "Wikidata" },
  ];
  out.push({
    row: {
      slug, name: r.name, location: [r.state, "India"].filter(Boolean).join(", "),
      state: r.state, country: "India", latitude: r.lat, longitude: r.lon,
      description: extract, history: null,
      image_url: s?.thumbnail?.source || null,
      image_credit: s?.thumbnail?.source ? "Wikipedia / Wikimedia Commons" : null,
      temple_category: "Hindu temple",
      discovery_status: "auto_published", verification_status: "source_supported",
      discovery_sources: sources,
      metadata: { provider: "wikidata_wikipedia_import", wikidata_id: r.qid, sources },
      published: true,
    },
    sources,
  });
}
console.log(`Prepared ${out.length} new temples. Saving...`);

let saved = 0;
for (let i = 0; i < out.length; i += 50) {
  const chunk = out.slice(i, i + 50);
  const { data, error } = await db.from("temples")
    .upsert(chunk.map((c) => c.row), { onConflict: "slug", ignoreDuplicates: true })
    .select("id,slug");
  if (error) { console.error("Insert failed:", error.message); process.exit(1); }
  saved += data.length;

  const bySlug = new Map(data.map((d) => [d.slug, d.id]));
  const urls = [...new Set(chunk.flatMap((c) => c.sources.map((x) => x.url)))];
  const { data: have } = await db.from("sources").select("id,url").in("url", urls);
  const idByUrl = new Map((have || []).map((h) => [h.url, h.id]));
  const missing = chunk.flatMap((c) => c.sources).filter((x) => !idByUrl.has(x.url));
  const uniq = [...new Map(missing.map((m) => [m.url, m])).values()];
  if (uniq.length) {
    const { data: made } = await db.from("sources")
      .insert(uniq.map((m) => ({ title: m.title, url: m.url, source_type: m.type }))).select("id,url");
    (made || []).forEach((m) => idByUrl.set(m.url, m.id));
  }
  const links = chunk.flatMap((c) => {
    const tid = bySlug.get(c.row.slug);
    return tid ? c.sources.map((x) => ({ temple_id: tid, source_id: idByUrl.get(x.url) })).filter((l) => l.source_id) : [];
  });
  if (links.length) await db.from("temple_sources").upsert(links, { onConflict: "temple_id,source_id", ignoreDuplicates: true });
  console.log(`  saved ${saved}/${out.length}`);
}
console.log(`Done. Added ${saved} temples.`);
