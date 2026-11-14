// ------------------------------------------------------------------
// TempleVerse — text lookup (English only).
// The app is English-only, so this just resolves UI strings and
// content fields. The function names are kept so existing components
// keep working unchanged.
// ------------------------------------------------------------------

import { UI_STRINGS } from "../data/uiStrings";
import { EXTRA_STRINGS } from "../data/uiStringsMore";

const EN = { ...UI_STRINGS.en, ...EXTRA_STRINGS.en };

/** UI string lookup. */
export function t(key) {
  return EN[key] ?? key;
}

/** Resolve a content field. Always English. */
export function translateContent(entity, field) {
  if (!entity) return { text: "", untranslated: false, language: "en" };
  return { text: entity[field] ?? "", untranslated: false, language: "en" };
}

export function getLocalizedField(entity, field) {
  return translateContent(entity, field).text;
}

export function getLocalizedName(entity) {
  return getLocalizedField(entity, "name") || entity?.name || "";
}

export function getLocalizedDescription(entity) {
  return getLocalizedField(entity, "description");
}
