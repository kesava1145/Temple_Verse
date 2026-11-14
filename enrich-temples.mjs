// Fills empty History / Architecture / Cultural significance (plus Deity, Style, Period)
// for every temple, using only Wikipedia + Wikidata (free, no API keys). Nothing is invented.
//
// For each empty field it tries, in order:
//   1. a matching Wikipedia section (History, Architecture, Festivals ...) incl. sub-sections
//   2. verbatim sentences from the article classified by topic (for short articles)
//   3. plain factual sentences built from Wikidata (founder, style, material, deity, heritage status)
// Fields no source can fill stay empty - they are listed in enrich-report.csv and the site shows
// a "not yet published" note instead of a blank box. Existing text is never overwritten.
//
// Usage:
//   SUPABASE_SERVICE_ROLE_KEY=... node enrich-temples.mjs [maxTemples] [--dry-run] [--slug=some-slug]
import { createClient } from "@supabase/supabase-js";
import { writeFileSync } from "node:fs";
import {
  empty, clean, trimToSentence, parseSections, sectionText, splitSentences,
  classifySentences, joinSentences, factSentences, UNIT,
} from "./enrich-lib.mjs";

const args = process.argv.slice(2);
const DRY = args.includes("--dry-run");
const ONLY = (args.find((a) => a.startsWith("--slug=")) || "").slice(7);
const MAX = Number(args.find((a) => /^\d+$/.test(a)) || 5000);
const URL_ = process.env.VITE_SUPABASE_URL || "https://yqdbmyvxidwnlzsymcrc.supabase.co";
const KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
if (!KEY) { console.error("Set SUPABASE_SERVICE_ROLE_KEY first."); process.exit(1); }

const db = createClient(URL_, KEY, { auth: { persistSession: false } });
const UA = { "User-Agent": "TempleVerse/1.0 (heritage enrichment; contact: you@example.com)" };
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const FIELDS = ["history", "architecture_summary", "cultural_significance"];
const LIMITS = { history: 5000, architecture_summary: 3000, cultural_significance: 3000 };

async function getJson(url, tries = 3) {
  for (let i = 0; i < tries; i++) {
    try {
      const r = await fetch(url, { headers: { ...UA, Accept: "application/json" } });
      if (r.ok) return await r.json();
      if (r.status === 404) return null;
    } catch { /* retry */ }
    await sleep(1200 * (i + 1));
  }
  return null;
}

// ---------- Wikidata ----------
async function wikidata(qid) {
  const d = await getJson(`https://www.wikidata.org/w/api.php?action=wbgetentities&ids=${qid}&props=claims|sitelinks&format=json`);
  const ent = d?.entities?.[qid];
  const claims = ent?.claims;
  if (!claims) return { facts: {}, enwiki: null };
  const ids = (p) => (claims[p] || []).map((c) => c.mainsnak?.datavalue?.value?.id).filter(Boolean).slice(0, 3);
  const raw = {
    deities: ids("P825"), styles: ids("P149"), founders: ids("P112"), architects: ids("P84"),
    materials: ids("P186"), heritage: ids("P1435"),
  };
  const heightClaim = claims.P2048?.[0]?.mainsnak?.datavalue?.value;
  const unitId = heightClaim?.unit?.split("/").pop();
  const time = claims.P571?.[0]?.mainsnak?.datavalue?.value?.time;
  const m = time && /^([+-])0*(\d+)-/.exec(time);
  const inception = m ? (m[1] === "-" ? `c. ${m[2]} BCE` : `c. ${m[2]} CE`) : null;

  const all = [...new Set(Object.values(raw).flat())];
  const labels = {};
  for (let i = 0; i < all.length; i += 40) {
    const l = await getJson(`https://www.wikidata.org/w/api.php?action=wbgetentities&ids=${all.slice(i, i + 40).join("|")}&props=labels&languages=en&format=json`);
    for (const id of all.slice(i, i + 40)) labels[id] = l?.entities?.[id]?.labels?.en?.value;
  }
  const names = (arr) => arr.map((x) => labels[x]).filter(Boolean);
  const amount = heightClaim?.amount ? Math.abs(Number(heightClaim.amount)) : null;
  return {
    enwiki: ent?.sitelinks?.enwiki?.title || null,
    facts: {
      deities: names(raw.deities), styles: names(raw.styles), founders: names(raw.founders),
      architects: names(raw.architects), materials: names(raw.materials), heritage: names(raw.heritage),
      inception,
      height: amount && UNIT[unitId] ? `${amount} ${UNIT[unitId]}` : null,
    },
  };
}

// ---------- Wikipedia ----------
async function wikipediaArticle(title) {
  const d = await getJson("https://en.wikipedia.org/w/api.php?action=query&prop=extracts&explaintext=1&redirects=1&format=json&titles=" + encodeURIComponent(title));
  const page = d?.query?.pages && Object.values(d.query.pages)[0];
  return page?.extract ? { title: page.title, text: page.extract } : null;
}
const norm = (s) => s.toLowerCase().normalize("NFKD").replace(/[^a-z0-9]+/g, " ").trim();
async function searchTitle(name) {
  const d = await getJson("https://en.wikipedia.org/w/api.php?action=query&list=search&srlimit=3&format=json&srsearch=" + encodeURIComponent(`${name} temple India`));
  const hit = (d?.query?.search || []).find((r) => norm(r.title) === norm(name) || norm(r.title).includes(norm(name)) || norm(name).includes(norm(r.title)));
  return hit?.title || null;
}

// ---------- decide the text for each empty field ----------
function build(temple, article, facts) {
  const out = {}, how = {};
  const secs = article ? parseSections(article.text) : [];
  const keyMap = { history: "history", architecture_summary: "architecture", cultural_significance: "culture" };

  // 1. matching sections
  for (const f of FIELDS) {
    const t = secs.length ? sectionText(secs, keyMap[f], LIMITS[f]) : null;
    if (t) { out[f] = t; how[f] = "wikipedia_section"; }
  }
  // 2. classified sentences (first without the intro, which is already shown as the description)
  if (article && FIELDS.some((f) => !out[f])) {
    const intro = article.text.split(/\n=+\s/)[0];
    const body = article.text.split("\n").filter((l) => !/^=+\s*(references?|see also|external links?|notes?|bibliography|further reading)\s*=+$/i.test(l.trim())).join("\n");
    const noIntro = splitSentences(body).filter((s) => !intro.includes(s));
    for (const pass of [noIntro, splitSentences(body)]) {
      const b = classifySentences(pass);
      for (const f of FIELDS) {
        if (out[f]) continue;
        const need = pass === noIntro ? 2 : 1;
        const t = b[keyMap[f]].length >= need ? joinSentences(b[keyMap[f]].slice(0, 6), LIMITS[f]) : null;
        if (t) { out[f] = t; how[f] = "wikipedia_sentences"; }
      }
    }
  }
  // 3. Wikidata facts
  const fs = factSentences(temple.name, facts || {});
  for (const f of FIELDS) {
    const list = fs[keyMap[f]];
    if (!out[f] && list.length) { out[f] = list.join(" "); how[f] = "wikidata_facts"; }
  }
  return { out, how };
}

// ---------- main ----------
const rows = [];
for (let from = 0; ; from += 1000) {
  let q = db.from("temples").select("id,slug,name,history,architecture_summary,cultural_significance,main_deity,architectural_style,historical_period,metadata").order("created_at").range(from, from + 999);
  if (ONLY) q = q.eq("slug", ONLY);
  const { data, error } = await q;
  if (error) { console.error("Read failed:", error.message); process.exit(1); }
  rows.push(...data);
  if (data.length < 1000) break;
}
const todo = rows.filter((t) => [...FIELDS, "main_deity", "architectural_style", "historical_period"].some((k) => empty(t[k]))).slice(0, MAX);
console.log(`${DRY ? "[dry run] " : ""}Enriching ${todo.length} of ${rows.length} temples...`);

const stats = { wikipedia_section: 0, wikipedia_sentences: 0, wikidata_facts: 0 };
const stillMissing = [];
let updated = 0, i = 0;
for (const t of todo) {
  i++;
  const md = t.metadata || {};
  const qid = md.wikidata_id;
  const wp = (md.sources || []).find((s) => s.type === "Wikipedia")?.url || "";
  let title = decodeURIComponent(wp.split("/wiki/")[1] || "").replace(/_/g, " ");

  const wd = qid ? await wikidata(qid) : { facts: {}, enwiki: null };
  title = title || wd.enwiki || (await searchTitle(t.name)) || "";
  const article = title ? await wikipediaArticle(title) : null;
  const { out, how } = build(t, article, wd.facts);

  const patch = {};
  for (const f of FIELDS) if (empty(t[f]) && out[f]) patch[f] = out[f];
  if (empty(t.main_deity) && wd.facts.deities?.length) patch.main_deity = wd.facts.deities.join(", ");
  if (empty(t.architectural_style) && wd.facts.styles?.length) patch.architectural_style = wd.facts.styles.join(", ");
  if (empty(t.historical_period) && wd.facts.inception) patch.historical_period = `Established ${wd.facts.inception}`;

  const filled = Object.keys(patch).filter((k) => FIELDS.includes(k));
  filled.forEach((k) => stats[how[k]]++);
  if (filled.length) patch.metadata = { ...md, enrichment: { ...(md.enrichment || {}), ...Object.fromEntries(filled.map((k) => [k, how[k]])), enriched_at: new Date().toISOString() } };

  const missing = FIELDS.filter((f) => empty(t[f]) && !patch[f]);
  if (missing.length) stillMissing.push([t.slug, t.name, missing.join("|"), title ? "" : "no wikipedia article found"]);

  if (DRY) {
    if (Object.keys(patch).length) updated++;
    if (filled.length || missing.length) console.log(`  ${t.slug}: fill [${filled.map((k) => `${k}:${how[k]}`).join(", ")}] missing [${missing.join(", ")}]`);
  } else if (Object.keys(patch).length) {
    const { error } = await db.from("temples").update(patch).eq("id", t.id);
    if (error) console.error(`  ${t.name}: ${error.message}`); else updated++;
  }
  if (i % 20 === 0) console.log(`  ${i}/${todo.length} checked, ${updated} updated`);
  await sleep(150);
}

writeFileSync("enrich-report.csv", "slug,name,still_missing,note\n" + stillMissing.map((r) => r.map((c) => `"${String(c).replace(/"/g, '""')}"`).join(",")).join("\n"));
console.log(`\nDone. ${DRY ? "Would update" : "Updated"} ${updated} of ${todo.length} temples.`);
console.log("Fields filled by source:", stats);
console.log(`${stillMissing.length} temples still have at least one empty field -> enrich-report.csv`);
