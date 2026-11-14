// ------------------------------------------------------------------
// TempleVerse — demo dataset assembler (English only).
// Each entity exposes its English fields plus an empty `translations`
// object so the shape matches what the Supabase service returns.
// ------------------------------------------------------------------

import { DEMO_TEMPLES } from "./temples";
import { DEMO_LOCATIONS } from "./locations";
import { DEMO_GUIDED_STEPS } from "./guidedSteps";

export const DEMO_LANGUAGES = [
  { code: "en", name: "English", native_name: "English" },
];

const withTranslations = (entity) => ({ ...entity, translations: {} });

export const TEMPLES = DEMO_TEMPLES.map(withTranslations);
export const LOCATIONS = DEMO_LOCATIONS.map(withTranslations);
export const GUIDED_STEPS = DEMO_GUIDED_STEPS.map(withTranslations);
