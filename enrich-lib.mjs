// Pure helpers for enrich-temples.mjs (no network, no database) so they can be tested offline.

export const empty = (v) => v === null || v === undefined || String(v).trim() === "";

export const clean = (s) => (typeof s === "string"
  ? s.replace(/[ \t]+/g, " ").replace(/\n{3,}/g, "\n\n").trim() : "");

// Cut at a sentence boundary instead of mid-word.
export function trimToSentence(text, max) {
  const t = clean(text);
  if (t.length <= max) return t;
  const cut = t.slice(0, max);
  const end = Math.max(cut.lastIndexOf(". "), cut.lastIndexOf(".\n"), cut.lastIndexOf("।"));
  return (end > max * 0.5 ? cut.slice(0, end + 1) : cut.replace(/\s+\S*$/, "") + "…").trim();
}

// ---- Wikipedia plain-text article -> sections with heading levels ----
const SKIP = /^(references?|see also|external links?|notes?|further reading|bibliography|gallery|sources?|citations?|footnotes?)$/i;

export function parseSections(text) {
  const sections = [{ level: 1, title: "intro", text: [] }];
  for (const line of String(text || "").split("\n")) {
    const h = /^(=+)\s*(.+?)\s*=+$/.exec(line.trim());
    if (h) { sections.push({ level: h[1].length, title: h[2], text: [] }); continue; }
    sections.at(-1).text.push(line);
  }
  // attach parent heading so "=== Construction ===" under "== History ==" counts as history
  const stack = [];
  for (const s of sections) {
    while (stack.length && stack.at(-1).level >= s.level) stack.pop();
    s.parents = stack.map((p) => p.title).filter((t) => t !== "intro");
    stack.push(s);
    s.body = clean(s.text.join("\n"));
  }
  return sections.filter((s) => s.title !== "intro" && s.body && !SKIP.test(s.title) && !s.parents.some((p) => SKIP.test(p)));
}

export const CATEGORY_HEADINGS = {
  history: /(histor|origin|legend|mytholog|background|etymolog|inscription|patron|reconstruct|renovat|construction|foundation|archaeolog|dynast|period)/i,
  architecture: /(architect|structure|layout|design|description|features|complex|sanctum|gopura|shrine|sculpture|plan|premises|campus|temple tank|interior|exterior)/i,
  culture: /(significan|festival|cultur|worship|ritual|tradition|religio|pilgrim|practice|belief|custom|administration|puja|pooja|rites|devotion|celebration)/i,
};

export function sectionText(sections, key, max) {
  const re = CATEGORY_HEADINGS[key];
  const hits = sections.filter((s) => re.test(s.title) || s.parents.some((p) => re.test(p)));
  // top-level matches already contain their own text; take each section once, in article order
  const body = hits.map((s) => s.body).join("\n\n");
  return body ? trimToSentence(body, max) : null;
}

// ---- Sentence classification fallback (verbatim sentences from the article) ----
export function splitSentences(text) {
  const raw = clean(text).replace(/\n+/g, " ")
    .split(/(?<=[.!?])\s+(?=[A-Z0-9"“‘(])/);
  const out = [];
  for (const piece of raw) {
    // glue back fragments created by abbreviations like "c." or "St."
    if (out.length && (/\b(c|ca|St|Dr|Mr|Sri|Smt|No|vs|approx)\.$/.test(out.at(-1)) || out.at(-1).length < 25)) out[out.length - 1] += " " + piece;
    else out.push(piece);
  }
  return out.filter((s) => s.length >= 40 && s.length <= 600);
}

const KW = {
  architecture: /\b(architectur\w*|style|gopura\w*|vimana\w*|shikhara|sikhara|sanctum|sanctorum|garbhagriha|mandapa\w*|pillars?|towers?|spires?|granite|sandstone|laterite|bricks?|carv\w+|sculpt\w+|prakara\w*|courtyards?|tank|domes?|storeys?|stories|tiered|dravidian|nagara|vesara|hoysala|chalukya\w*|height|metres|meters|feet|walls?|layout|entrance|halls?|gateway|structure|built of|made of)\b/i,
  culture: /\b(festivals?|worship\w*|devotees?|pilgrim\w*|rituals?|pujas?|poojas?|traditions?|celebrat\w+|ceremon\w+|offerings?|priests?|prayers?|annual\w*|beliefs?|sacred|holy|devotion|jatra|utsav\w*|brahmotsav\w*|navratri|shivaratri|visit(?:ed|ors)|thousands)\b/i,
  history: /\b(built|constructed|founded|established|erected|consecrated|commissioned|reconstructed|renovated|restored|destroyed|rebuilt|patron\w*|dynast\w+|kings?|rulers?|empire|centur(?:y|ies)|inscriptions?|era|period|legend|according to|mythology)\b|\b(?:1\d{3}|[3-9]\d{2})\b/i,
};
const ORDER = ["architecture", "culture", "history"]; // earlier wins ties so "history" doesn't swallow everything

export function classifySentences(sentences) {
  const buckets = { history: [], architecture: [], culture: [] };
  for (const s of sentences) {
    let best = null, bestScore = 0;
    for (const key of ORDER) {
      const m = s.match(new RegExp(KW[key].source, "gi"));
      const score = m ? new Set(m.map((x) => x.toLowerCase())).size : 0;
      if (score > bestScore) { best = key; bestScore = score; }
    }
    if (best) buckets[best].push(s);
  }
  return buckets;
}

export function joinSentences(list, max) {
  return list.length ? trimToSentence(list.join(" "), max) : null;
}

// ---- Wikidata facts -> short factual sentences ----
const UNIT = { Q11573: "metres", Q3710: "feet" };

export function factSentences(name, f) {
  const list = (a) => a.length > 1 ? `${a.slice(0, -1).join(", ")} and ${a.at(-1)}` : a[0];
  const history = [], architecture = [], culture = [];
  if (f.inception) history.push(`${name} is recorded as having been established ${f.inception}.`);
  if (f.founders?.length) history.push(`It is associated with ${list(f.founders)} as founder.`);
  if (f.architects?.length) architecture.push(`The temple is attributed to ${list(f.architects)} as architect.`);
  if (f.styles?.length) architecture.push(`Its architecture follows the ${list(f.styles)} style.`);
  if (f.materials?.length) architecture.push(`It is built using ${list(f.materials).toLowerCase()}.`);
  if (f.height) architecture.push(`Its recorded height is ${f.height}.`);
  if (f.deities?.length) culture.push(`The temple is dedicated to ${list(f.deities)}.`);
  if (f.heritage?.length) culture.push(`It holds the heritage designation: ${list(f.heritage)}.`);
  return { history, architecture, culture };
}

export { UNIT };
