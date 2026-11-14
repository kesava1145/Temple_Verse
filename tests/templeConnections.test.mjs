import assert from "node:assert/strict";
import { buildConnections, compareOne, profileOf } from "../src/services/templeProfile.js";

const T = (id, name, state, lat, lon, description = "", extra = {}) => ({
  id, slug: id, name, state, latitude: lat, longitude: lon, description,
  history: "", architecture_summary: "", cultural_significance: "", main_deity: "", architectural_style: "", historical_period: "",
  metadata: { provider: "wikidata_wikipedia_import" }, ...extra,
});
const temples = [
  T("ayikudi", "Ayikudi Balasubramanya Swami Temple", "Tamil Nadu", 8.99, 77.3, "Hindu temple dedicated to Murugan in Tenkasi district."),
  T("thiruchendur", "Thiruchendur Murugan Temple", "Tamil Nadu", 8.49, 78.12, "A temple of Murugan on the shore, one of the Arupadai Veedu. Skanda Sashti is celebrated."),
  T("palani", "Palani Dhandayuthapani Temple", "Tamil Nadu", 10.45, 77.52, "Temple of Murugan, built by the Chera and Pandya kings."),
  T("brihad", "Brihadisvara Temple", "Tamil Nadu", 10.78, 79.13, "Dravidian Shiva temple built by the Chola king in 1010 CE. UNESCO World Heritage Site.", { unesco: true }),
  T("gangai", "Gangaikonda Cholapuram", "Tamil Nadu", 11.2, 79.45, "Shiva temple built by Rajendra Chola in the 11th century. Dravidian vimana. UNESCO."),
  T("konark", "Konark Sun Temple", "Odisha", 19.89, 86.1, "Sun temple of the Eastern Ganga dynasty in Kalinga style, 13th century."),
  T("empty1", "Aami Mandir", "Bihar", 25.9, 84.4, ""),
  T("empty2", "Some Village Temple", "Kerala", 9.9, 76.3, ""),
];
const res = buildConnections(temples);
const of = (id) => res.find((r) => r.temple.id === id).connections;

// 1. The reported failure: a sparse temple must have connections.
const ay = of("ayikudi");
assert.ok(ay.length >= 3, "Ayikudi has connections");
assert.equal(ay[0].temple.id === "thiruchendur" || ay[0].temple.id === "palani", true);
assert.ok(ay.some((c) => c.reasons.some((r) => r.type === "deity")), "deity connection present");
// 2. Deity variants canonicalise (Balasubramanya ~ Murugan).
assert.ok(profileOf(temples[0]).deity.has("murugan"));
// 3. Dynasty + architecture + period from prose.
assert.ok(profileOf(temples[3]).dynasty.has("chola"));
assert.ok(profileOf(temples[3]).period.has("11th century"));
assert.ok(of("brihad").find((c) => c.temple.id === "gangai").reasons.some((r) => r.type === "dynasty"));
assert.ok(of("brihad").find((c) => c.temple.id === "gangai").reasons.some((r) => r.type === "architecture"));
// 4. Completely empty temples still show nearest / same-state neighbours (never blank).
assert.ok(of("empty1").length > 0 && of("empty2").length > 0, "empty temples not blank");
// 5. compareOne shape.
const c = compareOne(temples, "ayikudi");
assert.equal(c.a.id, "ayikudi"); assert.equal(c.rows.length, temples.length - 1);
assert.ok(c.rows[0].score >= c.rows.at(-1).score);
// 6. Shiva must not match every "-eswar" Vishnu etc: Konark (Sun) not linked to Shiva.
assert.ok(!profileOf(temples[5]).deity.has("shiva"));
console.log("templeConnections tests passed");
