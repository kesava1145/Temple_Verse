// Makes sure every temple has at least N photos in its gallery (default 3), using only free,
// openly licensed sources: Wikidata/Wikimedia Commons first, then Openverse.
//
// Photos are saved in the existing `images` table with credit, licence and source link.
// Trust tiers:
//   A  Wikidata main image, the temple's Commons category, images used in its Wikipedia article
//      -> published immediately (verified = true)
//   B  Commons photos geotagged within ~400 m,  C  Openverse name matches
//      -> saved as verified = false (hidden) for you to review, unless you pass --publish-all
// Only CC0 / public domain / CC BY / CC BY-SA are accepted. NC and ND are rejected.
//
// Usage:
//   SUPABASE_SERVICE_ROLE_KEY=... node enrich-images.mjs [--dry-run] [--slug=x] [--min=3] [--target=5] [--limit=100] [--publish-all]
import { createClient } from "@supabase/supabase-js";
import { writeFileSync } from "node:fs";
import { makeApi, acceptable, sortCandidates, creditOf, sleep } from "./images-lib.mjs";

const arg = (k, d) => { const a = process.argv.find((x) => x.startsWith(`--${k}=`)); return a ? a.split("=")[1] : d; };
const DRY = process.argv.includes("--dry-run");
const PUBLISH_ALL = process.argv.includes("--publish-all");
const MIN = Number(arg("min", 3));
const TARGET = Math.max(MIN, Number(arg("target", 5)));
const LIMIT = Number(arg("limit", 100000));
const ONLY = arg("slug", "");
const URL_ = process.env.VITE_SUPABASE_URL || "https://yqdbmyvxidwnlzsymcrc.supabase.co";
const KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
if (!KEY) { console.error("Set SUPABASE_SERVICE_ROLE_KEY first."); process.exit(1); }

const db = createClient(URL_, KEY, { auth: { persistSession: false } });
const UA = { "User-Agent": "TempleVerse/1.0 (heritage image enrichment; contact: you@example.com)" };
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
const api = makeApi(getJson);

// ---- load temples + their existing images ----
const temples = [];
for (let from = 0; ; from += 1000) {
  let q = db.from("temples").select("id,slug,name,state,latitude,longitude,image_url,metadata").eq("published", true).order("created_at").range(from, from + 999);
  if (ONLY) q = q.eq("slug", ONLY);
  const { data, error } = await q;
  if (error) { console.error("Read temples failed:", error.message); process.exit(1); }
  temples.push(...data);
  if (data.length < 1000) break;
}
const existing = new Map();
for (let from = 0; ; from += 1000) {
  const { data, error } = await db.from("images").select("temple_id,url,source_url,verified,display_order").not("temple_id", "is", null).range(from, from + 999);
  if (error) { console.error("Read images failed:", error.message); process.exit(1); }
  for (const r of data) { if (!existing.has(r.temple_id)) existing.set(r.temple_id, []); existing.get(r.temple_id).push(r); }
  if (data.length < 1000) break;
}
const verifiedCount = (t) => (existing.get(t.id) || []).filter((r) => r.verified).length;
const todo = temples.filter((t) => verifiedCount(t) < MIN).slice(0, LIMIT);
console.log(`${DRY ? "[dry run] " : ""}${todo.length} of ${temples.length} temples have fewer than ${MIN} photos.`);

// ---- main loop ----
const report = [];
let addedTotal = 0, i = 0;
for (const t of todo) {
  i++;
  const have = existing.get(t.id) || [];
  const seenUrls = new Set(have.flatMap((r) => [r.url, r.source_url]).filter(Boolean));
  const need = TARGET - verifiedCount(t);
  const md = t.metadata || {};
  const wp = (md.sources || []).find((s) => s.type === "Wikipedia")?.url || "";
  let wpTitle = decodeURIComponent(wp.split("/wiki/")[1] || "").replace(/_/g, " ");

  const pool = [];
  const wd = md.wikidata_id ? await api.wikidataMedia(md.wikidata_id) : { images: [], category: null, enwiki: null };
  wpTitle = wpTitle || wd.enwiki || "";
  if (wd.images.length) pool.push(...await api.mainImages(wd.images));
  if (wd.category) pool.push(...await api.categoryImages(wd.category));
  if (wpTitle) pool.push(...await api.articleImages(wpTitle));

  let chosen = pickUnique(pool, seenUrls, need);
  if (chosen.length < need && t.latitude != null && t.longitude != null) {
    pool.push(...await api.nearbyImages(t.latitude, t.longitude));
    chosen = pickUnique(pool, seenUrls, need);
  }
  if (chosen.length < need) {
    pool.push(...await api.openverseImages(t.name, t.state));
    chosen = pickUnique(pool, seenUrls, need);
  }

  const rows = chosen.map((c, k) => {
    const publish = c.tier === "A" || PUBLISH_ALL;
    return {
      temple_id: t.id, url: c.url, caption: c.caption.slice(0, 200),
      credit: creditOf(c, c.provider || "Wikimedia Commons"),
      subject: `${t.name} — ${c.tier === "A" ? "source-linked photo" : c.tier === "B" ? "geotagged nearby (review)" : "keyword match (review)"}`,
      verified: publish, rights_verified: !!c.license, license: c.license, source_url: c.source_url,
      width_px: c.width_px, height_px: c.height_px,
      is_cover: false, display_order: (Math.max(-1, ...have.map((r) => r.display_order ?? 0)) + 1) + k,
    };
  });
  const gained = rows.filter((r) => r.verified).length;
  const pending = rows.length - gained;
  const finalVerified = verifiedCount(t) + gained;

  if (rows.length && !DRY) {
    const { error } = await db.from("images").insert(rows);
    if (error) console.error(`  ${t.slug}: ${error.message}`);
    else {
      addedTotal += rows.length;
      if (!t.image_url && rows.find((r) => r.verified)) {
        const first = rows.find((r) => r.verified);
        await db.from("temples").update({ image_url: first.url, image_credit: first.credit }).eq("id", t.id);
      }
    }
  } else if (rows.length) addedTotal += rows.length;

  if (DRY || i % 20 === 0) console.log(`  ${t.slug}: +${gained} published, +${pending} to review -> ${finalVerified} live`);
  if (finalVerified < MIN) report.push([t.slug, t.name, finalVerified, pending, pool.length ? "few usable open-licence photos" : "no open-licence photos found"]);
  await sleep(200);
}

function pickUnique(pool, seen, need) {
  const out = [], titles = new Set();
  for (const c of sortCandidates(pool.filter((p) => acceptable(p)))) {
    if (out.length >= need) break;
    if (titles.has(c.title) || seen.has(c.url) || seen.has(c.source_url)) continue;
    titles.add(c.title); out.push(c);
  }
  return out;
}

writeFileSync("images-report.csv", "slug,name,live_photos,pending_review,note\n" + report.map((r) => r.map((c) => `"${String(c).replace(/"/g, '""')}"`).join(",")).join("\n"));
console.log(`\nDone. ${DRY ? "Would add" : "Added"} ${addedTotal} photos across ${todo.length} temples.`);
console.log(`${report.length} temples are still below ${MIN} live photos -> images-report.csv`);
console.log(`Photos saved as "to review" are hidden until you set verified = true on them (Supabase > Table editor > images).`);
