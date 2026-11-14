import React, { useEffect, useState } from "react";
import { useLanguage } from "../context/LanguageContext";

/** Renders original text immediately, then replaces it with the API translation. */
export default function LiveTranslatedText({ text = "", as: Tag = "span", className = "", showStatus = true }) {
  const { lang, translateText } = useLanguage();
  const [translated, setTranslated] = useState(text);
  const [status, setStatus] = useState("idle");

  useEffect(() => {
    let active = true;
    const controller = new AbortController();
    const original = String(text ?? "");

    setTranslated(original);
    if (!original.trim() || lang === "en") {
      setStatus("idle");
      return () => controller.abort();
    }

    setStatus("loading");
    translateText(original, { signal: controller.signal })
      .then((result) => {
        if (!active) return;
        setTranslated(result);
        setStatus("translated");
      })
      .catch(() => {
        if (!active) return;
        setTranslated(original);
        setStatus("unavailable");
      });

    return () => {
      active = false;
      controller.abort();
    };
  }, [text, lang, translateText]);

  return (
    <>
      <Tag className={className}>{translated}</Tag>
      {showStatus && status === "loading" && (
        <span className="ml-2 text-xs text-midnight-700/45" role="status">Translating…</span>
      )}
      {showStatus && status === "unavailable" && lang !== "en" && (
        <span className="ml-2 text-xs text-amber-700" title="Showing the original language">
          Translation unavailable — showing original
        </span>
      )}
    </>
  );
}
