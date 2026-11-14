import { getTemples } from "./templeService";

// Similarity is computed from approved/recorded metadata. It is a discovery aid,
// not a claim that two temples share a historical origin.
const normalize = (value = "") => String(value)
  .normalize("NFKD")
  .replace(/[\u0300-\u036f]/g, "")
  .toLocaleLowerCase()
  .replace(/[^a-z0-9]+/g, " ")
  .trim();

const asValues = (...items) => [...new Set(items.flat(Infinity)
  .filter((item) => typeof item === "string" && item.trim())
  .map(normalize)
  .filter(Boolean))];

const intersection = (a, b) => a.filter((value) => b.includes(value));
const splitTerms = (...items) => asValues(items.flat(Infinity).flatMap((item) => {
  if (typeof item !== "string") return [];
  const parenthetical = [...item.matchAll(/\(([^)]+)\)/g)].map((match) => match[1]);
  return [item, ...parenthetical, ...item.split(/[,;|\/–—&]|\band\b/gi)];
}));
const titleCase = (value) => value.replace(/\b\w/g, (c) => c.toUpperCase());

function metadataFor(temple) {
  const m = temple.metadata || {};
  const discovery = temple.discovery_metadata || temple;
  return {
    deities: splitTerms(
      temple.main_deity,
      m.identity?.principal_deity,
      m.identity?.secondary_deities,
      m.religious?.consort_deity,
      m.religious?.associated_divine_figures,
      discovery.associated_deities,
    ),
    architecture: splitTerms(
      temple.architectural_style,
      m.architecture?.architectural_style,
      m.architecture?.sculptural_themes,
    ),
    dynasties: asValues(
      m.history?.original_dynasty,
      m.history?.major_ruling_dynasties,
      discovery.associated_dynasties,
    ),
    traditions: asValues(
      temple.religious_tradition,
      m.identity?.religious_tradition,
      m.religious?.agama_tradition,
      m.religious?.worship_tradition,
      m.identity?.temple_category,
    ),
    festivals: asValues(
      m.festivals?.major_annual_festivals,
      m.festivals?.festival_calendar,
      discovery.festivals,
    ),
    jatras: asValues(m.festivals?.jatra_names, temple.jatras),
    periods: asValues(
      temple.historical_period,
      m.history?.historical_period,
      m.history?.foundation_date,
    ),
  };
}

export async function getTempleConnections() {
  const temples = await getTemples();
  const indexed = temples.map((temple) => ({ temple, meta: metadataFor(temple) }));

  return indexed.map(({ temple, meta }) => {
    const connections = indexed
      .filter((other) => other.temple.id !== temple.id)
      .map((other) => {
        const reasons = [];
        const add = (type, label, shared) => {
          if (shared.length) reasons.push({
            type, label,
            detail: shared.map(titleCase).join(", "),
            matched_values: shared,
          });
        };
        add("deity", "Shared deity metadata", intersection(meta.deities, other.meta.deities));
        add("architecture", "Shared architectural metadata", intersection(meta.architecture, other.meta.architecture));
        add("dynasty", "Shared dynasty metadata", intersection(meta.dynasties, other.meta.dynasties));
        add("story", "Shared religious tradition or story metadata", intersection(meta.traditions, other.meta.traditions));
        add("festival", "Shared festival metadata", intersection(meta.festivals, other.meta.festivals));
        add("jatra", "Shared Jatra metadata", intersection(meta.jatras, other.meta.jatras));
        add("period", "Related historical period", intersection(meta.periods, other.meta.periods));

        const weights = { deity: 4, dynasty: 3, story: 3, architecture: 2, festival: 2, jatra: 2, period: 1 };
        const score = reasons.reduce((sum, reason) => sum + (weights[reason.type] || 1), 0);
        return { temple: other.temple, reasons, score };
      })
      .filter((item) => item.score > 0)
      .sort((a, b) => b.score - a.score || a.temple.name.localeCompare(b.temple.name));

    return { temple, connections };
  });
}

// ---------------------------------------------------------------------------
// Pairwise comparison: "how are Temple A and Temple B connected?"
// Everything below is derived from recorded metadata only (temples columns,
// temples.metadata JSONB, temple_discovery_metadata view, festivals, jatras).
// ---------------------------------------------------------------------------

// Values so generic that sharing them says nothing useful.
const GENERIC = new Set([
  "hindu", "hinduism", "temple", "india", "unknown", "none", "n a", "na",
  "not specified", "not recorded", "other", "various",
]);

// Like splitTerms, but keeps a human-readable label next to the normalized key.
function labelled(...items) {
  const out = new Map();
  for (const item of items.flat(Infinity)) {
    if (typeof item !== "string" || !item.trim()) continue;
    const parts = [
      item,
      ...[...item.matchAll(/\(([^)]+)\)/g)].map((m) => m[1]),
      ...item.split(/[,;|\/–—&]|\band\b/gi),
    ];
    for (const part of parts) {
      const label = part.trim();
      const key = normalize(label);
      if (key.length < 2 || GENERIC.has(key) || out.has(key)) continue;
      out.set(key, label.charAt(0).toUpperCase() + label.slice(1));
    }
  }
  return out;
}

const ordinal = (n) => {
  const v = n % 100;
  if (v >= 11 && v <= 13) return `${n}th`;
  return `${n}${({ 1: "st", 2: "nd", 3: "rd" })[n % 10] || "th"}`;
};

// "built in the 12th century" -> "12th century" so differently worded
// historical_period strings can still be matched on the century.
const centuries = (...items) => {
  const out = new Map();
  for (const item of items.flat(Infinity)) {
    if (typeof item !== "string") continue;
    for (const m of item.matchAll(/(\d{1,2})(?:st|nd|rd|th)\s+century(?:\s+(BCE|CE))?/gi)) {
      const label = `${ordinal(Number(m[1]))} century${m[2] ? ` ${m[2].toUpperCase()}` : ""}`;
      out.set(normalize(label), label);
    }
  }
  return out;
};

export const DIMENSIONS = [
  { id: "deity", label: "Deity", weight: 4 },
  { id: "dynasty", label: "Dynasty & patrons", weight: 3 },
  { id: "tradition", label: "Religious tradition", weight: 3 },
  { id: "mythology", label: "Mythology & Puranas", weight: 3 },
  { id: "architecture", label: "Architecture", weight: 2 },
  { id: "festival", label: "Festivals", weight: 2 },
  { id: "jatra", label: "Jatras", weight: 2 },
  { id: "heritage", label: "Heritage status", weight: 1 },
  { id: "region", label: "Region & geography", weight: 1 },
  { id: "period", label: "Historical period", weight: 1 },
];

function richMetadata(temple) {
  const m = temple.metadata || {};
  const d = temple.discovery_metadata || {};
  const list = (v) => (Array.isArray(v) ? v : [v]);
  return {
    deity: labelled(
      temple.main_deity, m.identity?.principal_deity, m.identity?.secondary_deities,
      m.religious?.consort_deity, m.religious?.associated_divine_figures, d.associated_deities,
    ),
    dynasty: labelled(
      m.history?.original_dynasty, m.history?.major_ruling_dynasties,
      m.history?.patron_kings, d.associated_dynasties,
    ),
    tradition: labelled(
      temple.religious_tradition, m.identity?.religious_tradition,
      m.religious?.agama_tradition, m.religious?.worship_tradition,
      m.identity?.temple_category, temple.temple_category,
    ),
    mythology: labelled(
      m.mythology?.associated_puranas, m.mythology?.associated_sages,
      m.mythology?.sacred_place_names,
    ),
    architecture: labelled(
      temple.architectural_style, m.architecture?.architectural_style,
      m.architecture?.main_sanctum_type, m.architecture?.vimana_type,
      m.architecture?.pillar_carving_style, m.architecture?.sculptural_themes,
      m.architecture?.decorative_motifs,
    ),
    festival: labelled(
      m.festivals?.major_annual_festivals, m.festivals?.festival_calendar,
      d.festivals, (temple.festivals || []).map((f) => f.canonical_name),
    ),
    jatra: labelled(
      m.festivals?.jatra_names, (temple.jatras || []).map((j) => j.canonical_name),
    ),
    heritage: labelled(
      m.conservation?.heritage_designation, m.conservation?.protected_monument_status,
      temple.unesco ? "UNESCO World Heritage Site" : null,
    ),
    region: labelled(
      temple.state, m.geography?.state, m.geography?.district, m.geography?.nearby_river,
    ),
    period: new Map([
      ...labelled(temple.historical_period, m.history?.historical_period),
      ...centuries(temple.historical_period, m.history?.historical_period, m.history?.foundation_date),
    ]),
  };
}

// Drop a combined value (e.g. "Dravidian (Chola)") when its parts already matched.
function prune(keys) {
  return keys.filter((k) => !keys.some((j) => j !== k && ` ${k} `.includes(` ${j} `)));
}

function scorePair(metaA, metaB) {
  const dimensions = DIMENSIONS.map((dim) => {
    const a = metaA[dim.id], b = metaB[dim.id];
    const shared = prune([...a.keys()].filter((k) => b.has(k)));
    const sharedSet = new Set(shared);
    // A combined value that only matched through its parts is not "unique" either.
    const covered = (k) => sharedSet.has(k) || shared.some((s) => ` ${k} `.includes(` ${s} `));
    return {
      ...dim,
      shared: shared.map((k) => a.get(k)),
      only_a: [...a.keys()].filter((k) => !b.has(k) && !covered(k)).map((k) => a.get(k)),
      only_b: [...b.keys()].filter((k) => !a.has(k) && !covered(k)).map((k) => b.get(k)),
      has_data: a.size > 0 || b.size > 0,
    };
  });
  const score = dimensions.reduce((sum, d) => sum + (d.shared.length ? d.weight * Math.min(d.shared.length, 3) : 0), 0);
  return { dimensions, score };
}

export const strengthOf = (score) =>
  score >= 12 ? "strong" : score >= 6 ? "moderate" : score > 0 ? "light" : "none";

function summarise(a, b, dimensions) {
  const hits = dimensions.filter((d) => d.shared.length)
    .sort((x, y) => y.weight - x.weight).slice(0, 3);
  if (!hits.length) {
    return `No shared deity, dynasty, tradition, architecture, festival or heritage metadata is recorded for ${a.name} and ${b.name} yet.`;
  }
  const bits = hits.map((d) => `${d.label.toLowerCase()} (${d.shared.slice(0, 2).join(", ")})`);
  const joined = bits.length > 1 ? `${bits.slice(0, -1).join(", ")} and ${bits.at(-1)}` : bits[0];
  return `${a.name} and ${b.name} are linked through ${joined}.`;
}

export async function compareTemples(idA, idB) {
  const temples = await getTemples();
  const A = temples.find((t) => t.id === idA);
  const B = temples.find((t) => t.id === idB);
  if (!A || !B || A.id === B.id) return null;

  const metas = new Map(temples.map((t) => [t.id, richMetadata(t)]));
  const direct = scorePair(metas.get(A.id), metas.get(B.id));

  // "Bridge" temples: connected to both A and B, which helps when the two
  // temples share little directly (e.g. same dynasty through a third temple).
  const bridges = temples
    .filter((t) => t.id !== A.id && t.id !== B.id)
    .map((t) => {
      const ta = scorePair(metas.get(A.id), metas.get(t.id));
      const tb = scorePair(metas.get(t.id), metas.get(B.id));
      const via = (x) => x.dimensions.filter((d) => d.shared.length)
        .sort((p, q) => q.weight - p.weight)[0];
      return { temple: t, score: Math.min(ta.score, tb.score), withA: via(ta), withB: via(tb) };
    })
    .filter((x) => x.score > 0)
    .sort((x, y) => y.score - x.score || x.temple.name.localeCompare(y.temple.name))
    .slice(0, 3);

  return {
    a: A, b: B,
    score: direct.score,
    strength: strengthOf(direct.score),
    dimensions: direct.dimensions,
    summary: summarise(A, B, direct.dimensions),
    bridges,
  };
}

// One temple against every other temple in the catalogue, strongest first.
export async function compareWithAll(idA) {
  const temples = await getTemples();
  const A = temples.find((t) => t.id === idA || t.slug === idA);
  if (!A) return null;
  const metaA = richMetadata(A);
  const rows = temples
    .filter((t) => t.id !== A.id)
    .map((t) => {
      const { dimensions, score } = scorePair(metaA, richMetadata(t));
      return {
        temple: t, score, strength: strengthOf(score), dimensions,
        matched: dimensions.filter((d) => d.shared.length).sort((x, y) => y.weight - x.weight),
      };
    })
    .sort((x, y) => y.score - x.score || x.temple.name.localeCompare(y.temple.name));
  return { a: A, rows };
}
