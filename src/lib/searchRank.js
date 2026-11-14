// Search ranking for the temple catalogue. Pure functions, no imports, so it
// runs in the browser, in demo mode, and in plain Node for testing.
//
// What it understands that a plain `includes()` does not:
//   - several words in any order  ("shiva temples tamil nadu")
//   - spelling variants           (Siva/Shiva, Thirupathi/Tirupati, Meenakshi/Minakshi)
//   - deity aliases               (Balaji -> Venkateswara, Vinayagar -> Ganesha)
//   - typos                       ("maduria", "chidambram")
//   - ranking: exact name > name prefix > name word > place/deity > description

export const normalize = (value) => String(value ?? "")
  .normalize("NFKD")
  .replace(/[\u0300-\u036f]/g, "") // strip Latin accents only; keep Indic vowel signs
  .toLowerCase()
  .trim();

// \p{M} keeps Devanagari / Tamil / Telugu / Malayalam vowel signs inside words.
export const tokenize = (value) => normalize(value).split(/[^\p{L}\p{M}\p{N}]+/u).filter(Boolean);

/** Collapse common Indic-English transliteration differences into one key. */
export function skeleton(word) {
  let s = normalize(word);
  if (/[^\x00-\x7f]/.test(s)) return s; // non-Latin scripts: compare as-is
  s = s
    .replace(/([bcdfgjklmnpqrstvwxyz])h/g, "$1") // sh th dh kh bh ch -> s t d k b c
    .replace(/w/g, "v")
    .replace(/z/g, "s")
    .replace(/aa+/g, "a")
    .replace(/ee+|ii+/g, "i")
    .replace(/oo+|uu+/g, "u")
    .replace(/(.)\1+/g, "$1")
    .replace(/^(.{3,})a$/, "$1"); // rama/ram, shiva/shiv
  return s;
}

const STOP = new Set([
  "temple", "temples", "mandir", "mandiram", "kovil", "koil", "devalayam", "devasthanam",
  "alayam", "gudi", "devalaya", "in", "of", "the", "near", "at", "to", "for", "and", "a",
  "an", "famous", "best", "old", "ancient", "sri", "shri", "sree", "swami", "swamy",
]);
export const isStopToken = (token) => STOP.has(token);

const ALIAS_GROUPS = [
  ["shiva", "siva", "shiv", "mahadev", "mahadeva", "shankar", "shankara", "shambhu", "nataraja", "eshwar", "ishwara", "easwar", "lingam", "linga", "shaiva", "saiva"],
  ["vishnu", "narayana", "perumal", "hari", "vaishnava", "vaishnavite"],
  ["venkateswara", "venkateshwara", "balaji", "srinivasa", "govinda"],
  ["krishna", "gopala", "kanha", "krishn"],
  ["devi", "amman", "ammavaru", "shakti", "durga", "parvati", "bhavani", "mata", "ambika", "goddess"],
  ["lakshmi", "laxmi"],
  ["ganesha", "ganesh", "ganapati", "vinayaka", "vinayagar", "pillaiyar", "vighneshwara"],
  ["murugan", "muruga", "kartikeya", "karthikeya", "subramanya", "subrahmanya", "skanda", "kumara", "swaminatha", "arumugam"],
  ["hanuman", "anjaneya", "maruti", "bajrang"],
  ["rama", "ram", "raghunatha", "kodanda"],
  ["surya", "sun", "aditya"],
  ["ayyappa", "ayyappan", "sabarimala"],
  ["jagannath", "jagannatha"],
  ["tamilnadu", "tamil nadu"],
  ["andhrapradesh", "andhra pradesh"],
  ["uttarpradesh", "uttar pradesh"],
  ["madhyapradesh", "madhya pradesh"],
];
const ALIASES = new Map(); // skeleton -> Set of alias skeletons
for (const group of ALIAS_GROUPS) {
  const keys = group.flatMap((g) => tokenize(g)).map(skeleton);
  const set = new Set(keys);
  for (const key of keys) ALIASES.set(key, new Set([...(ALIASES.get(key) || []), ...set]));
}

/** Levenshtein distance that gives up early once it exceeds `max`. */
export function editDistance(a, b, max = 2) {
  if (a === b) return 0;
  if (Math.abs(a.length - b.length) > max) return max + 1;
  let prev = Array.from({ length: b.length + 1 }, (_, i) => i);
  for (let i = 1; i <= a.length; i++) {
    const cur = [i];
    let rowMin = i;
    for (let j = 1; j <= b.length; j++) {
      cur[j] = Math.min(prev[j] + 1, cur[j - 1] + 1, prev[j - 1] + (a[i - 1] === b[j - 1] ? 0 : 1));
      if (cur[j] < rowMin) rowMin = cur[j];
    }
    if (rowMin > max) return max + 1;
    prev = cur;
  }
  return prev[b.length];
}
const maxTypos = (len) => (len >= 8 ? 2 : len >= 4 ? 1 : 0);

/* ---------------------------------------------------------------- index */

const WEIGHTS = { name: 10, place: 5, deity: 5, style: 3, period: 2, description: 2, extra: 1 };
const indexCache = new WeakMap();

const MAX_INDEXED_CHARS = 3000; // keep long histories from dominating index time
const makeField = (weight, ...texts) => {
  const words = [...new Set(texts.flat(Infinity).flatMap((t) => tokenize(typeof t === "string" ? t.slice(0, MAX_INDEXED_CHARS) : t)))];
  return { weight, words, skels: words.map(skeleton) };
};

function buildIndex(temple) {
  const cached = indexCache.get(temple);
  if (cached) return cached;
  const meta = temple.metadata || {};
  const discovery = temple.discovery_metadata || {};
  const translated = Object.values(temple.translations || {});
  const index = {
    nameText: normalize([temple.name, temple.official_name, temple.local_name].filter(Boolean).join(" | ")),
    names: [temple.name, temple.official_name, temple.local_name, ...translated.map((t) => t?.name)]
      .filter(Boolean).map(normalize),
    fields: [
      makeField(WEIGHTS.name, temple.name, temple.official_name, temple.local_name, ...translated.map((t) => t?.name)),
      makeField(WEIGHTS.place, temple.city, temple.district, temple.state, temple.location),
      makeField(WEIGHTS.deity, temple.main_deity, discovery.associated_deities,
        meta.identity?.principal_deity, ...translated.map((t) => t?.main_deity)),
      makeField(WEIGHTS.style, temple.architectural_style, meta.architecture?.architectural_style,
        temple.temple_category, temple.religious_tradition),
      makeField(WEIGHTS.period, temple.historical_period, discovery.associated_dynasties,
        meta.history?.original_dynasty),
      makeField(WEIGHTS.description, temple.description, ...translated.map((t) => t?.description)),
      makeField(WEIGHTS.extra, temple.history, temple.architecture_summary, temple.cultural_significance,
        (temple.festivals || []).map((f) => f.canonical_name), JSON.stringify(meta).slice(0, 4000)),
    ],
  };
  indexCache.set(temple, index);
  return index;
}

/** Strength 0..1 of one query word against one indexed field. */
function matchWord(qWord, qSkel, field) {
  let best = 0;
  const typos = maxTypos(qWord.length);
  for (let i = 0; i < field.words.length; i++) {
    const w = field.words[i];
    if (w === qWord) return 1;
    let s = 0;
    if (qWord.length >= 2 && w.startsWith(qWord)) s = 0.85;
    else if (qWord.length >= 3 && w.includes(qWord)) s = 0.5;
    if (s < 0.8) {
      const ws = field.skels[i];
      // A skeleton shorter than 3 chars is noise ("zzzz" -> "s"), never a match.
      if (qSkel.length >= 3 && ws === qSkel) s = Math.max(s, 0.8);
      else if (qSkel.length >= 3 && ws.startsWith(qSkel)) s = Math.max(s, 0.7);
      else if (typos && qSkel.length >= 4 && editDistance(qSkel, ws, typos) <= typos) s = Math.max(s, 0.5);
    }
    if (s > best) best = s;
    if (best >= 0.85) break;
  }
  return best;
}

/** Everything a single query token may stand for: itself plus its aliases. */
function expandToken(token) {
  const sk = skeleton(token);
  const out = [{ word: token, skel: sk, factor: 1 }];
  for (const alias of ALIASES.get(sk) || []) {
    if (alias !== sk) out.push({ word: alias, skel: alias, factor: 0.9 });
  }
  return out;
}

/* ---------------------------------------------------------------- scoring */

export function parseQuery(query) {
  const all = tokenize(query);
  const content = all.filter((t) => !isStopToken(t));
  const required = content.length ? content : all; // "temple" alone must still search
  return {
    normalized: normalize(query),
    tokens: required.map((word) => ({ word, variants: expandToken(word) })),
    optional: content.length ? all.filter(isStopToken) : [],
  };
}

/** Returns 0 when the temple does not match every required word. */
export function scoreTemple(temple, parsed) {
  if (!parsed.tokens.length) return 0;
  const index = buildIndex(temple);
  let total = 0;
  for (const token of parsed.tokens) {
    let best = 0;
    for (const variant of token.variants) {
      for (const field of index.fields) {
        // Aliases only make sense against identity fields, not free text.
        if (variant.factor < 1 && field.weight < WEIGHTS.style) continue;
        const s = matchWord(variant.word, variant.skel, field) * field.weight * variant.factor;
        if (s > best) best = s;
      }
    }
    if (best === 0) return 0; // every real word must match somewhere
    total += best;
  }
  const q = parsed.normalized;
  if (q) {
    if (index.names.some((n) => n === q)) total += 120;
    else if (index.names.some((n) => n.startsWith(q))) total += 80;
    else if (index.nameText.includes(q)) total += 40;
  }
  for (const word of parsed.optional) {
    if (index.fields[0].words.includes(word)) total += 1;
  }
  return total;
}

/**
 * Rank temples for a query. With `keepUnmatched`, rows that the server already
 * accepted stay in the list (after the scored ones) instead of being dropped.
 */
export function rankTemples(temples, query, { keepUnmatched = false } = {}) {
  const parsed = parseQuery(query);
  if (!parsed.tokens.length) return temples;
  const scored = temples.map((temple, order) => ({ temple, order, score: scoreTemple(temple, parsed) }));
  const hits = scored.filter((s) => s.score > 0).sort((a, b) => b.score - a.score || a.order - b.order);
  if (!keepUnmatched) return hits.map((s) => s.temple);
  const rest = scored.filter((s) => s.score === 0);
  return [...hits, ...rest].map((s) => s.temple);
}

/* ------------------------------------------------------------ did you mean */

const vocabCache = new WeakMap();

/** Words people are likely to search for, with how often each appears. */
export function buildVocabulary(temples) {
  if (vocabCache.has(temples)) return vocabCache.get(temples);
  const counts = new Map();
  for (const t of temples) {
    for (const text of [t.name, t.official_name, t.city, t.state, t.main_deity, t.architectural_style]) {
      for (const w of tokenize(text)) {
        if (w.length >= 3 && !isStopToken(w) && !/^\d+$/.test(w)) counts.set(w, (counts.get(w) || 0) + 1);
      }
    }
  }
  const vocab = { counts, words: [...counts.keys()].map((word) => ({ word, skel: skeleton(word) })) };
  vocabCache.set(temples, vocab);
  return vocab;
}

/** Suggest a corrected query ("maduria temple" -> "madurai temple") or null. */
export function didYouMean(query, vocab) {
  const tokens = tokenize(query);
  let changed = false;
  const fixed = tokens.map((tok) => {
    if (tok.length < 4 || isStopToken(tok) || vocab.counts.has(tok)) return tok;
    const sk = skeleton(tok);
    if (vocab.words.some((v) => v.word.startsWith(tok) || v.skel === sk)) return tok; // still typing / valid variant
    if (ALIASES.has(sk)) return tok;
    const max = maxTypos(tok.length);
    let best = null;
    for (const v of vocab.words) {
      const d = editDistance(sk, v.skel, max);
      if (d <= max && (!best || d < best.d || (d === best.d && vocab.counts.get(v.word) > best.count))) {
        best = { word: v.word, d, count: vocab.counts.get(v.word) };
      }
    }
    if (best) { changed = true; return best.word; }
    return tok;
  });
  return changed ? fixed.join(" ") : null;
}
