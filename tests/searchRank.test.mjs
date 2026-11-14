import assert from "node:assert/strict";
import { rankTemples, buildVocabulary, didYouMean, skeleton } from "../src/lib/searchRank.js";

const T = (name, city, state, deity, style = "", desc = "") =>
  ({ id: name, name, city, state, main_deity: deity, architectural_style: style, description: desc, temple_category: "Hindu temple" });
const temples = [
  T("Meenakshi Amman Temple", "Madurai", "Tamil Nadu", "Meenakshi, Sundareswarar", "Dravidian"),
  T("Brihadisvara Temple", "Thanjavur", "Tamil Nadu", "Shiva", "Chola Dravidian"),
  T("Tirumala Venkateswara Temple", "Tirupati", "Andhra Pradesh", "Venkateswara", "Dravidian"),
  T("Jagannath Temple", "Puri", "Odisha", "Jagannath", "Kalinga"),
  T("Kashi Vishwanath Temple", "Varanasi", "Uttar Pradesh", "Shiva", "Nagara"),
  T("Aami Mandir", "Aami", "Bihar", "", "", "A Hindu temple in Saran district."),
  T("Ramanathaswamy Temple", "Rameswaram", "Tamil Nadu", "Shiva", "Dravidian"),
  T("Chidambaram Nataraja Temple", "Chidambaram", "Tamil Nadu", "Nataraja", "Dravidian"),
];
const top = (q, n = 1) => rankTemples(temples, q).slice(0, n).map((t) => t.name);

// exact / prefix
assert.equal(top("Aami Mandir")[0], "Aami Mandir");
assert.equal(top("meenak")[0], "Meenakshi Amman Temple");
// typos
assert.equal(top("maduria")[0], "Meenakshi Amman Temple");
assert.equal(top("chidambram")[0], "Chidambaram Nataraja Temple");
assert.equal(top("brihadeeswara")[0], "Brihadisvara Temple");
// spelling variants + aliases
assert.equal(top("Thirupathi")[0], "Tirumala Venkateswara Temple");
assert.equal(top("balaji temple")[0], "Tirumala Venkateswara Temple");
assert.equal(top("Minakshi")[0], "Meenakshi Amman Temple");
// intent queries: AND across fields, word order irrelevant
const shivaTN = rankTemples(temples, "shiva temples in tamil nadu").map((t) => t.name);
assert.deepEqual(new Set(shivaTN), new Set(["Brihadisvara Temple", "Ramanathaswamy Temple", "Chidambaram Nataraja Temple"]));
assert.ok(!shivaTN.includes("Kashi Vishwanath Temple"), "wrong state must be excluded");
assert.deepEqual(rankTemples(temples, "tamilnadu shiva").length, 3);
// bare stopword still searches
assert.ok(rankTemples(temples, "temple").length > 0);
// nonsense matches nothing
assert.equal(rankTemples(temples, "zzzqqq").length, 0);
// keepUnmatched keeps server rows
assert.equal(rankTemples(temples, "zzzqqq", { keepUnmatched: true }).length, temples.length);
// did you mean
const vocab = buildVocabulary(temples);
assert.equal(didYouMean("maduria", vocab), "madurai");
assert.equal(didYouMean("thanjavoor", vocab), null); // valid variant via skeleton, no correction needed
assert.equal(didYouMean("tamil nadu", vocab), null);
assert.equal(didYouMean("mee", vocab), null); // still typing
assert.equal(didYouMean("tanjvur", vocab), "thanjavur");
assert.equal(skeleton("Shiva"), skeleton("Siva"));
// perf: 2000 temples x 20 queries
const big = Array.from({ length: 2000 }, (_, i) => T(`Temple ${i} Kovil`, `City${i % 90}`, "Tamil Nadu", i % 3 ? "Shiva" : "Vishnu", "Dravidian", "x ".repeat(200)));
const t0 = performance.now();
for (let i = 0; i < 20; i++) rankTemples(big, ["shiva tamil", "city7", "temple 99", "vishnu dravidian"][i % 4]);
console.log(`perf: 20 queries over 2000 temples = ${(performance.now() - t0).toFixed(0)} ms`);
console.log("all search tests passed");

// regression: degenerate input must not match stray one-letter tokens ("Pandya's" -> "s")
const withApostrophe = [...temples, T("Test Temple", "X", "Y", "Z", "", "Built by the Pandya's dynasty")];
assert.equal(rankTemples(withApostrophe, "zzzz").length, 0);
assert.equal(rankTemples(withApostrophe, "ssss").length, 0);
console.log("regression tests passed");
