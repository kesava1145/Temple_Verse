import React, { createContext, useContext } from "react";
import {
  t as translate,
  translateContent,
  getLocalizedField,
  getLocalizedName,
  getLocalizedDescription,
} from "../services/translationService";

// The app is English-only. This context is kept (always "en") so that
// components can keep calling t(), name(), desc() and C() unchanged.
const value = {
  lang: "en",
  t: (key) => translate(key),
  L: (entity, field) => getLocalizedField(entity, field),
  C: (entity, field) => translateContent(entity, field),
  name: (entity) => getLocalizedName(entity),
  desc: (entity) => getLocalizedDescription(entity),
};

const LanguageContext = createContext(value);

export function LanguageProvider({ children }) {
  return <LanguageContext.Provider value={value}>{children}</LanguageContext.Provider>;
}

export function useLanguage() {
  return useContext(LanguageContext);
}
