import { getTemples } from "./templeService";
import {
  DIMENSIONS, strengthOf, profileOf, buildStats, scorePair, haversineKm,
  buildConnections, compareOne,
} from "./templeProfile";

// Similarity is computed from every recorded field (columns, metadata JSON, festivals, jatras)
// plus facts recognised in the description / history text and the temple's location.
// It is a discovery aid, not a claim that two temples share a historical origin.
export { DIMENSIONS, strengthOf };

let memo = { key: null, value: null };
const keyOf = (temples) => `${temples.length}|${temples[0]?.id}|${temples.at(-1)?.id}`;

export async function getTempleConnections() {
  const temples = await getTemples();
  const key = keyOf(temples);
  if (memo.key !== key) memo = { key, value: buildConnections(temples) };
  return memo.value;
}

function summarise(a, b, dimensions) {
  const hits = dimensions.filter((d) => d.shared.length).sort((x, y) => y.weight - x.weight).slice(0, 3);
  if (!hits.length) {
    return `${a.name} and ${b.name} share no recognisable deity, dynasty, tradition, architecture, festival or location link yet.`;
  }
  const bits = hits.map((d) => `${d.label.toLowerCase()} (${d.shared.slice(0, 2).join(", ")})`);
  const joined = bits.length > 1 ? `${bits.slice(0, -1).join(", ")} and ${bits.at(-1)}` : bits[0];
  return `${a.name} and ${b.name} are linked through ${joined}.`;
}

export async function compareTemples(idA, idB) {
  const temples = await getTemples();
  const A = temples.find((t) => t.id === idA || t.slug === idA);
  const B = temples.find((t) => t.id === idB || t.slug === idB);
  if (!A || !B || A.id === B.id) return null;

  const profiles = new Map(temples.map((t) => [t.id, profileOf(t)]));
  const stats = buildStats([...profiles.values()]);
  const pair = (x, y) => scorePair(profiles.get(x.id), profiles.get(y.id), haversineKm(x, y), stats);
  const direct = pair(A, B);

  const bridges = temples
    .filter((t) => t.id !== A.id && t.id !== B.id)
    .map((t) => {
      const ta = pair(A, t), tb = pair(t, B);
      const via = (x) => x.dimensions.filter((d) => d.shared.length).sort((p, q) => q.weight - p.weight)[0];
      return { temple: t, score: Math.min(ta.score, tb.score), withA: via(ta), withB: via(tb) };
    })
    .filter((x) => x.score > 0 && x.withA && x.withB)
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
  return compareOne(temples, idA);
}
