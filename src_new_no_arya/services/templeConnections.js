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
