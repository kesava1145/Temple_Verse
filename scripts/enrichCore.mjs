// Enrichment core: no network, no database. All I/O is injected (`deps`), so
// the whole pipeline can be tested offline.
//
// Principle: never invent. Text is either copied from a cited source (Wikipedia
// sections / sentences), assembled from structured facts (Wikidata), or, as a
// last resort, written by a local LLM that is told to use ONLY supplied sources
// and whose output is rejected unless it is grounded in those sources.

export const TEXT_FIELDS = ["history", "architecture_summary", "cultural_significance"];
export const SHORT_FIELDS = ["main_deity", "architectural_style", "historical_period"];
export const FIELDS = [...TEXT_FIELDS, ...SHORT_FIELDS];
export const MAX_LEN = { history: 4000, architecture_summary: 2500, cultural_significance: 2500 };

export const empty = (v) => v === null || v === undefined || String(v).trim() === "";

export const clean = (s) => (typeof s === "string"
  ? s.replace(/\r/g, "").replace(/\[\d+\]|\[citation needed\]|\[note \d+\]/gi, "")
    .replace(/[ \t]+/g, " ").replace(/ ?\n ?/g, "\n").replace(/\n{3,}/g, "\n\n").trim()
  : "");

/** Cut at the last full sentence within `max` characters. */
export function trimToSentence(text, max) {
  const t = clean(text);
  if (t.length <= max) return t;
  const cut = t.slice(0, max);
  const end = Math.max(cut.lastIndexOf(". "), cut.lastIndexOf("! "), cut.lastIndexOf("? "), cut.lastIndexOf(".\n"));
  if (end > max * 0.5) return cut.slice(0, end + 1).trim();
  return cut.slice(0, cut.lastIndexOf(" ")).trim() + "…";
}

/* ------------------------------------------------------- Wikipedia sections */

export function sectionsOf(text) {
  const out = { intro: [] };
  let cur = "intro";
  for (const line of String(text || "").split("\n")) {
    const h = /^=+\s*(.+?)\s*=+$/.exec(line.trim());
    if (h) { cur = h[1].toLowerCase(); out[cur] ||= []; continue; }
    out[cur].push(line);
  }
  return out;
}

const SKIP_HEADING = /^(intro|references?|external links?|see also|notes?|gallery|further reading|bibliography|sources|citations?)$/;
const HEADING_RE = {
  history: /history|origin|legend|mytholog|background|etymolog|foundation|construction|inscription|patron|dynast|renovat|restor|timeline/,
  architecture_summary: /architect|structure|layout|design|description|features|complex|sanctum|gopura|sculpt|premises|building|\bart\b|plan\b|shrines?$/,
  cultural_significance: /significan|festival|cultur|worship|ritual|tradition|religio|pilgrim|belief|deit|customs|puja|celebrat|devotee|legacy/,
};

/** Merge every section whose heading matches; `used` stops one section feeding two fields. */
export function pickSections(sections, re, max, used = new Set()) {
  const parts = [];
  for (const [key, lines] of Object.entries(sections)) {
    if (SKIP_HEADING.test(key) || used.has(key) || !re.test(key)) continue;
    const body = clean(lines.join("\n"));
    if (body.length < 40) continue;
    used.add(key);
    parts.push(body);
  }
  return parts.length ? trimToSentence(parts.join("\n\n"), max) : null;
}

/* ------------------------------------------- whole-article sentence sorting */

const ABBREV = /\b(?:c|ca|st|dr|mr|mrs|sri|no|vs|cf|approx|r|b|d|m|km|ft|lit|fl)\.$/i;
export function splitSentences(text) {
  const raw = clean(text).replace(/\n+/g, " ").split(/(?<=[.!?])\s+(?=[A-Z0-9"“‘(])/);
  const out = [];
  for (const piece of raw) {
    if (out.length && ABBREV.test(out[out.length - 1])) out[out.length - 1] += " " + piece;
    else out.push(piece);
  }
  return out.map((s) => s.trim()).filter((s) => s.length >= 25);
}

const TOPIC_RE = {
  history: /\b(built|build|founded|constructed|erected|established|consecrated|renovat\w+|restor\w+|rebuilt|expanded|patron\w*|king|queen|emperor|dynast\w+|empire|rule[dr]?|reign\w*|legend|according to|tradition holds|mytholog\w+|century|centuries|inscription\w*|ancient|medieval|colonial|\b(?:1\d{3}|[5-9]\d{2}|20[0-2]\d)\b|BCE|CE)\b/gi,
  architecture_summary: /\b(architect\w*|style|gopura\w*|shikhara|shikhar|vimana|mandapa\w*|sanctum|garbhagriha|tower|spire|dome|pillar\w*|carved|carving\w*|sculpt\w+|stone|granite|sandstone|brick|marble|wood\w*|hall|courtyard|tank|walls?|gate\w*|entrance|facade|dravidian|nagara|vesara|height|metres?|meters?|feet|ft|storeys?|stories|plan|layout|structure|rectangular|square|circular)\b/gi,
  cultural_significance: /\b(festival\w*|worship\w*|pilgrim\w*|devotee\w*|ritual\w*|puja|aarti|celebrat\w+|annual\w*|visited|sacred|holy|belief|believed|significan\w+|important|revered|popular|faith|prayer\w*|offering\w*|procession\w*|fair|mela|navratri|shivaratri|diwali|community|villagers|local)\b/gi,
};

/** Sort an article's sentences into the three topics, keeping article order. */
export function classifySentences(text, description = "") {
  const intro = clean(description).slice(0, 120);
  const out = { history: [], architecture_summary: [], cultural_significance: [] };
  for (const [i, sentence] of splitSentences(text).entries()) {
    if (i === 0 && /\bis (a|an|the)\b/i.test(sentence)) continue; // definitional lead = description
    if (intro && sentence.startsWith(intro.slice(0, 60))) continue;
    let best = null;
    for (const field of TEXT_FIELDS) {
      const hits = (sentence.match(TOPIC_RE[field]) || []).length;
      if (hits && (!best || hits > best.hits)) best = { field, hits };
    }
    if (best) out[best.field].push(sentence);
  }
  return out;
}

/* ------------------------------------------------------------ Wikidata facts */

const list = (arr) => (arr.length <= 1 ? arr[0] || "" : `${arr.slice(0, -1).join(", ")} and ${arr[arr.length - 1]}`);

/** Plain factual sentences from structured data. Only states what the data says. */
export function factSentences(name, f = {}) {
  const history = [];
  const architecture = [];
  const culture = [];
  if (f.founded_by?.length) history.push(`${name} is recorded as founded by ${list(f.founded_by)}.`);
  if (f.commissioned_by?.length) history.push(`${name} is recorded as commissioned by ${list(f.commissioned_by)}.`);
  if (f.inception) history.push(`Sources record its establishment as c. ${f.inception}.`);
  if (f.architect?.length) architecture.push(`The architect is recorded as ${list(f.architect)}.`);
  if (f.materials?.length) architecture.push(`It is recorded as built of ${list(f.materials).toLowerCase()}.`);
  if (f.architectural_style) architecture.push(`Its architectural style is recorded as ${f.architectural_style}.`);
  if (f.heritage?.length) culture.push(`It carries the heritage designation: ${list(f.heritage)}.`);
  if (f.main_deity) culture.push(`The temple is dedicated to ${f.main_deity}.`);
  return { history, architecture_summary: architecture, cultural_significance: culture };
}

/* ---------------------------------------------------------------- dynasties */

const DYNASTIES = ["Chola", "Pandya", "Pallava", "Chera", "Chalukya", "Hoysala", "Vijayanagara", "Nayak", "Kakatiya",
  "Rashtrakuta", "Gupta", "Maratha", "Eastern Ganga", "Ganga", "Gajapati", "Solanki", "Chandela", "Pala", "Sena", "Ahom",
  "Kalachuri", "Maurya", "Satavahana", "Paramara", "Kadamba", "Maukhari", "Licchavi", "Rajput", "Mughal", "Sunga", "Kushan"];

export function detectDynasty(...texts) {
  const text = texts.filter(Boolean).join(" ");
  const counts = DYNASTIES.map((d) => [d, (text.match(new RegExp(`\\b${d}\\b`, "g")) || []).length]).filter(([, n]) => n);
  counts.sort((a, b) => b[1] - a[1] || b[0].length - a[0].length);
  return counts.length ? counts[0][0] : null;
}

/* ------------------------------------------------------- LLM output guarding */

const BOILERPLATE = /as an ai|i cannot|i can't|no information (is )?(available|provided)|not (specified|mentioned|provided) in the sources|unable to/i;

/**
 * Reject model text that mentions names or years absent from the sources.
 * Cheap but effective against the most common failure: confident invention.
 */
export function groundedEnough(output, sourceText, threshold = 0.8) {
  const out = clean(output);
  if (out.length < 60 || BOILERPLATE.test(out)) return false;
  const haystack = String(sourceText || "").toLowerCase();
  const tokens = [...new Set(out.match(/(?<![.!?]\s)(?<!^)\b(?:[A-Z][a-zA-Z'’-]{2,}|\d{3,4})\b/g) || [])];
  if (!tokens.length) return true;
  const found = tokens.filter((tk) => haystack.includes(tk.toLowerCase())).length;
  return found / tokens.length >= threshold;
}

/* ----------------------------------------------------------------- pipeline */

export const wikiTitleFrom = (metadata) => {
  const url = (metadata?.sources || []).find((s) => s.type === "Wikipedia")?.url || "";
  const raw = url.split("/wiki/")[1];
  try { return raw ? decodeURIComponent(raw) : ""; } catch { return ""; }
};

/**
 * Work out what to write for one temple. Only fields that are empty are touched.
 * deps: { findTitle?(t), wikiArticle(title), wikidataFacts(qid), webResearch?(t, fields, articleText) }
 */
export async function enrichOne(t, deps, { web = true } = {}) {
  const patch = {};
  const how = {};
  const sources = [];
  const weak = new Set(); // filled from bare facts only; the web tier may improve these
  const wanted = (f) => empty(t[f]) && empty(patch[f]);
  const set = (f, value, method) => {
    if (wanted(f) && !empty(value)) { patch[f] = value; how[f] = method; return true; }
    return false;
  };

  let title = wikiTitleFrom(t.metadata);
  if (!title && deps.findTitle) title = (await deps.findTitle(t)) || "";
  const article = title ? await deps.wikiArticle(title) : null;
  const qid = t.metadata?.wikidata_id || article?.qid;
  const facts = qid ? (await deps.wikidataFacts(qid)) || {} : {};
  if (article?.url && !t.metadata?.sources?.some((s) => s.url === article.url)) {
    sources.push({ title: article.title, url: article.url, type: "Wikipedia" });
  }

  // Short facts
  set("main_deity", facts.main_deity, "wikidata");
  set("architectural_style", facts.architectural_style, "wikidata");
  if (facts.inception) set("historical_period", `Established c. ${facts.inception}`, "wikidata");

  // Tier 1: whole sections under matching headings
  if (article?.text) {
    const sections = sectionsOf(article.text);
    const used = new Set();
    for (const f of TEXT_FIELDS) {
      if (wanted(f)) set(f, pickSections(sections, HEADING_RE[f], MAX_LEN[f], used), "wikipedia_section");
    }
  }

  // Tiers 2 + 3: sentences from the article body, plus facts as plain sentences
  const sentences = article?.text ? classifySentences(article.text, t.description) : {};
  const fs = factSentences(t.name, { ...facts, architectural_style: facts.architectural_style || t.architectural_style, main_deity: facts.main_deity || t.main_deity });
  for (const f of TEXT_FIELDS) {
    if (!wanted(f)) continue;
    const fromArticle = sentences[f] || [];
    const fromFacts = (fs[f] || []).filter((s) => !fromArticle.some((x) => x.includes(s.slice(0, 30))));
    const text = trimToSentence([...fromArticle, ...fromFacts].join(" "), MAX_LEN[f]);
    // Article sentences need some substance; a single recorded fact is short but true.
    if (text.length >= (fromArticle.length ? 40 : 20)) {
      const method = fromArticle.length ? (fromFacts.length ? "wikipedia_sentences+wikidata_facts" : "wikipedia_sentences") : "wikidata_facts";
      set(f, text, method);
      if (!fromArticle.length || text.length < 150) weak.add(f);
    }
  }

  // Tier 4: local search + LLM, grounded or discarded
  const needWeb = TEXT_FIELDS.filter((f) => empty(t[f]) && (empty(patch[f]) || weak.has(f)));
  if (web && deps.webResearch && needWeb.length) {
    const result = await deps.webResearch(t, needWeb, article?.text || "");
    for (const f of needWeb) {
      const text = result?.fields?.[f];
      if (empty(text)) continue;
      patch[f] = trimToSentence(text, MAX_LEN[f]);
      how[f] = "web_search_llm";
    }
    if (Object.values(how).includes("web_search_llm")) sources.push(...(result.sources || []));
  }

  // Helps the Connections page: a recorded dynasty
  const dynasty = detectDynasty(patch.history, t.history, patch.historical_period, t.historical_period);
  const existing = t.metadata?.history?.original_dynasty;
  return { patch, how, sources, title, qid, dynasty: empty(existing) ? dynasty : null };
}
