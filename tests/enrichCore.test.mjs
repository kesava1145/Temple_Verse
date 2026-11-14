import assert from "node:assert/strict";
import { enrichOne, classifySentences, groundedEnough, detectDynasty, trimToSentence, sectionsOf, pickSections } from "../scripts/enrichCore.mjs";

// ---- SYNTHETIC test text (not real temple facts) ----
const RICH = `Test Temple is a Hindu temple in Testville.

== History ==
The temple was built in 1150 by the Chola king Rajaraja. It was renovated in 1650 under Nayak rule.

== Architecture ==
The temple follows the Dravidian style, with a granite gopuram about 40 metres tall and a pillared mandapa.

== Festivals ==
Thousands of devotees gather for the annual Brahmotsavam festival.

== References ==
1. Some book about Test Temple that must be ignored.`;

const STUB = `Stubtown Mandir is a Hindu temple located in Stubtown village, Testdistrict, Bihar. The temple is dedicated to the goddess Durga. According to local tradition, the temple was built in ancient times. It is visited by many devotees during Navratri. The main shrine has a small sanctum and a brick tower.`;

const deps = (article, facts = {}, web = null) => ({
  findTitle: async () => "", wikiArticle: async () => article, wikidataFacts: async () => facts, webResearch: web,
});
const base = { id: 1, name: "X Temple", description: "", metadata: { sources: [{ type: "Wikipedia", url: "https://en.wikipedia.org/wiki/X" }], wikidata_id: "Q1" } };

// 1. headings -> sections, references ignored, dynasty detected
let r = await enrichOne({ ...base, name: "Test Temple" }, deps({ text: RICH }));
assert.match(r.patch.history, /built in 1150/);
assert.match(r.patch.architecture_summary, /granite gopuram/);
assert.match(r.patch.cultural_significance, /Brahmotsavam/);
assert.ok(!Object.values(r.patch).join(" ").includes("must be ignored"));
assert.equal(r.how.history, "wikipedia_section");
assert.equal(r.dynasty, "Chola");

// 2. stub with no headings -> sentence classification (the Aami Mandir case)
r = await enrichOne({ ...base, name: "Stubtown Mandir" }, deps({ text: STUB }));
assert.match(r.patch.history, /local tradition/);
assert.match(r.patch.architecture_summary, /sanctum/);
assert.match(r.patch.cultural_significance, /Navratri/);
assert.ok(!r.patch.history.includes("is a Hindu temple located"), "definitional lead stays in description");
assert.equal(r.how.history, "wikipedia_sentences");

// 3. never overwrite existing text
r = await enrichOne({ ...base, history: "Hand-written history that must survive." }, deps({ text: RICH }));
assert.equal(r.patch.history, undefined);
assert.ok(r.patch.architecture_summary);

// 4. facts only (no article text): sentences from Wikidata, and web tier consulted
let webCalled = 0;
const web = async (t, fields) => { webCalled++; return { fields: { history: "Stubtown Mandir was founded by local Brahmin families according to the temple committee records." }, sources: [{ title: "Committee", url: "https://example.org/c", type: "Web" }] }; };
r = await enrichOne({ ...base }, deps(null, { founded_by: ["Raja Test"], materials: ["Brick"], main_deity: "Durga" }, web));
assert.match(r.patch.architecture_summary, /built of brick/);
assert.equal(r.patch.main_deity, "Durga");
assert.equal(r.how.history, "web_search_llm", "weak fact-only history is improved by the web tier");
assert.equal(webCalled, 1);
assert.equal(r.sources.length, 1);

// 5. web tier disabled
webCalled = 0;
r = await enrichOne({ ...base }, deps(null, {}, web), { web: false });
assert.equal(webCalled, 0);
assert.deepEqual(r.patch, {});

// 6. grounding guard
const src = "The Aami temple was built by King Daksha in ancient times and dedicated to Durga.";
assert.equal(groundedEnough("The temple was built by King Daksha in ancient times, dedicated to Durga worship.", src), true);
assert.equal(groundedEnough("The temple was built by Emperor Ashoka in 1203 and visited by Napoleon Bonaparte often.", src), false);
assert.equal(groundedEnough("I cannot find information about this temple in the sources provided today.", src), false);

// 7. helpers
assert.equal(detectDynasty("Built by the Pallava kings; later Chola. The Chola era saw expansion."), "Chola");
assert.equal(trimToSentence("One sentence here. Another sentence goes on and on without end", 30), "One sentence here.");
const secs = sectionsOf(RICH); assert.ok(secs["history"] && !pickSections(secs, /references?/, 100));
console.log("all enrichment tests passed");
