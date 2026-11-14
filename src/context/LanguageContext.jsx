import React, { createContext, useContext, useEffect, useMemo, useState } from "react";
import {
  t as translate,
  translateContent,
  translateText as requestTranslation,
  getLocalizedField,
  getLocalizedName,
  getLocalizedDescription,
  LANGUAGE_CODES,
  bcp47,
} from "../services/translationService";
import { changeLanguage as setVoiceLanguage } from "../services/voiceService";

const LanguageContext = createContext(null);
const STORAGE_KEY = "templeverse_lang";

export function LanguageProvider({ children }) {
  const [lang, setLangState] = useState(() => {
    try {
      const saved = localStorage.getItem(STORAGE_KEY);
      return LANGUAGE_CODES.includes(saved) ? saved : "en";
    } catch {
      return "en";
    }
  });

  useEffect(() => {
    try {
      localStorage.setItem(STORAGE_KEY, lang);
    } catch {
      // Continue without persistence when storage is unavailable.
    }
    document.documentElement.lang = bcp47(lang);
    setVoiceLanguage(lang);
  }, [lang]);

  const value = useMemo(() => ({
    lang,
    setLang: setLangState,
    t: (key) => translate(key, lang),
    L: (entity, field) => getLocalizedField(entity, field, lang),
    C: (entity, field) => translateContent(entity, field, lang),
    name: (entity) => getLocalizedName(entity, lang),
    desc: (entity) => getLocalizedDescription(entity, lang),
    // Dynamic content translation; the API key stays on the backend.
    translateText: (text, options) => requestTranslation(text, lang, options),
  }), [lang]);

  return <LanguageContext.Provider value={value}>{children}</LanguageContext.Provider>;
}

export function useLanguage() {
  const context = useContext(LanguageContext);
  if (!context) throw new Error("useLanguage must be used inside <LanguageProvider>");
  return context;
}
