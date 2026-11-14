// Helpers + API wrappers for enrich-images.mjs. No database code here, so it can be tested offline.
// Sources: Wikidata (P18 image, Commons category), Wikimedia Commons, Openverse. All free, no keys.

export const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

// ---------- licence + relevance rules ----------
// Only licences that allow reuse on a public site with credit. Anything NC/ND is rejected.
export function licenseOk(name) {
  const n = String(name || "").trim();
  if (!n) return false;
  if (/\b(NC|ND)\b|non-?commercial|no derivat/i.test(n)) return false;
  return /^(CC0|CC[- ]BY(-SA)?\b|Public domain|PD\b|Attribution)/i.test(n) || /public domain|cc0/i.test(n);
}

const BAD_TITLE = /\b(map|maps|logo|icon|flag|symbol|coat of arms|locator|diagram|plan|stamp|poster|screenshot|banner|signature|emblem|sketch|drawing|painting|print|engraving|lithograph|manuscript|scan|postcard|stub)\b|\.(svg|gif|tif|tiff|pdf|djvu|ogg|webm)$/i;
export const badTitle = (t) => BAD_TITLE.test(String(t || ""));

export function stripTags(html) {
  return String(html || "")
    .replace(/<[^>]*>/g, " ")
    .replace(/&amp;/g, "&").replace(/&quot;/g, '"').replace(/&#0?39;/g, "'").replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&nbsp;/g, " ")
    .replace(/\s+/g, " ").trim();
}

export const captionFromTitle = (title) =>
  String(title || "").replace(/^File:/i, "").replace(/\.[a-z0-9]{3,4}$/i, "").replace(/[_]+/g, " ").replace(/\s+/g, " ").trim();

const GENERIC = new Set(["temple", "temples", "mandir", "mandiram", "kovil", "koil", "devasthanam", "devalayam", "shri", "sri", "sree", "shree", "swamy", "swami", "of", "the", "at", "in", "and", "mandapam"]);
const norm = (s) => String(s || "").toLowerCase().normalize("NFKD").replace(/[\u0300-\u036f]/g, "").replace(/[^a-z0-9]+/g, " ").trim();
export const distinctiveTokens = (name) => norm(name).split(" ").filter((w) => w.length > 2 && !GENERIC.has(w));

// For keyword-search sources (Openverse): every distinctive word of the temple's name must appear.
export function mentionsTemple(text, name) {
  const tokens = distinctiveTokens(name);
  if (!tokens.length) return false;
  const hay = norm(text);
  return tokens.every((t) => hay.includes(t));
}

// ---------- candidate shaping ----------
export function toCandidate(page, tier, rank = 50) {
  const info = page?.imageinfo?.[0];
  if (!info) return null;
  const meta = info.extmetadata || {};
  const license = stripTags(meta.LicenseShortName?.value);
  const width = info.thumbwidth && info.width > 1280 ? info.thumbwidth : info.width;
  return {
    title: String(page.title).replace(/_/g, " ").replace(/\s+/g, " ").trim(),
    url: info.thumburl || info.url,
    source_url: info.descriptionurl,
    width_px: info.thumbwidth || info.width,
    height_px: info.thumbheight || info.height,
    orig_width: info.width, orig_height: info.height,
    mime: info.mime,
    caption: stripTags(meta.ObjectName?.value) || captionFromTitle(page.title),
    author: stripTags(meta.Artist?.value) || "Unknown author",
    license, license_url: meta.LicenseUrl?.value || null,
    tier, rank,
  };
}

export function acceptable(c, { minWidth = 800 } = {}) {
  if (!c || !c.url) return false;
  if (!/^image\/(jpeg|png|webp)$/i.test(c.mime || "")) return false;
  if ((c.orig_width || 0) < minWidth) return false;
  if (badTitle(c.title)) return false;
  return licenseOk(c.license);
}

// Better = bigger (capped) and landscape; lower rank first (P18 before category before article).
export function quality(c) {
  const area = Math.min((c.orig_width || 0) * (c.orig_height || 0), 4_000_000) / 4_000_000;
  return area + ((c.orig_width || 0) >= (c.orig_height || 0) ? 0.25 : 0);
}
export const sortCandidates = (list) => [...list].sort((a, b) => a.rank - b.rank || quality(b) - quality(a));

export function creditOf(c, sourceLabel = "Wikimedia Commons") {
  return [c.author, c.license, sourceLabel].filter(Boolean).join(" · ");
}

// ---------- API wrappers ----------
const COMMONS = "https://commons.wikimedia.org/w/api.php";
const IIPROPS = "iiprop=url|size|mime|extmetadata&iiurlwidth=1280&iiextmetadatafilter=ObjectName|Artist|LicenseShortName|LicenseUrl";

export function makeApi(getJson) {
  async function commonsInfo(titles, tier, rank) {
    const out = [];
    for (let i = 0; i < titles.length; i += 40) {
      const chunk = titles.slice(i, i + 40);
      const d = await getJson(`${COMMONS}?action=query&format=json&formatversion=2&prop=imageinfo&${IIPROPS}&titles=${encodeURIComponent(chunk.join("|"))}`);
      for (const p of d?.query?.pages || []) { const c = toCandidate(p, tier, rank); if (c) out.push(c); }
    }
    return out;
  }

  return {
    // Wikidata: main image (P18), Commons category (P373 / commonswiki sitelink)
    async wikidataMedia(qid) {
      const d = await getJson(`https://www.wikidata.org/w/api.php?action=wbgetentities&ids=${qid}&props=claims|sitelinks&format=json`);
      const ent = d?.entities?.[qid];
      const images = (ent?.claims?.P18 || []).map((c) => c.mainsnak?.datavalue?.value).filter(Boolean);
      const cat = ent?.claims?.P373?.[0]?.mainsnak?.datavalue?.value || ent?.sitelinks?.commonswiki?.title?.replace(/^Category:/, "") || null;
      return { images, category: cat, enwiki: ent?.sitelinks?.enwiki?.title || null };
    },
    mainImages: (files) => commonsInfo(files.map((f) => `File:${f}`), "A", 0),

    async categoryImages(category) {
      const d = await getJson(`${COMMONS}?action=query&format=json&formatversion=2&generator=categorymembers&gcmtitle=${encodeURIComponent("Category:" + category)}&gcmtype=file&gcmlimit=40&prop=imageinfo&${IIPROPS}`);
      return (d?.query?.pages || []).map((p) => toCandidate(p, "A", 10)).filter(Boolean);
    },

    async articleImages(title) {
      const d = await getJson(`https://en.wikipedia.org/w/api.php?action=query&format=json&formatversion=2&prop=images&imlimit=60&redirects=1&titles=${encodeURIComponent(title)}`);
      const files = (d?.query?.pages?.[0]?.images || []).map((i) => i.title).filter((t) => !badTitle(t));
      return files.length ? commonsInfo(files.slice(0, 40), "A", 20) : [];
    },

    // Photos geotagged within ~400 m of the temple. Needs a human glance: could be a neighbour.
    async nearbyImages(lat, lon) {
      const d = await getJson(`${COMMONS}?action=query&format=json&formatversion=2&list=geosearch&gscoord=${lat}|${lon}&gsradius=400&gsnamespace=6&gslimit=40`);
      const titles = (d?.query?.geosearch || []).map((g) => g.title).filter((t) => !badTitle(t));
      return titles.length ? commonsInfo(titles, "B", 30) : [];
    },

    async openverseImages(name, state) {
      const q = encodeURIComponent(`${name}${state ? " " + state : ""}`);
      const d = await getJson(`https://api.openverse.org/v1/images/?q=${q}&category=photograph&license_type=commercial&page_size=20&excluded_source=wikimedia,wikimedia_audio`);
      return (d?.results || [])
        .filter((r) => ["cc0", "pdm", "by", "by-sa"].includes(String(r.license).toLowerCase()))
        .filter((r) => mentionsTemple(`${r.title} ${(r.tags || []).map((t) => t.name).join(" ")}`, name))
        .filter((r) => (r.width || 0) >= 800 && !badTitle(r.title))
        .map((r) => ({
          title: r.title, url: r.url, source_url: r.foreign_landing_url || r.url,
          width_px: r.width, height_px: r.height, orig_width: r.width, orig_height: r.height, mime: "image/jpeg",
          caption: r.title, author: r.creator || "Unknown author",
          license: `${r.license === "cc0" ? "CC0" : r.license === "pdm" ? "Public domain" : "CC " + r.license.toUpperCase()}${r.license_version ? " " + r.license_version : ""}`,
          license_url: r.license_url || null, tier: "C", rank: 40, provider: r.source || r.provider || "Openverse",
        }));
    },
  };
}
