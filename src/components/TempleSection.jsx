import React from "react";
import { ExternalLink } from "lucide-react";
import LiveTranslatedText from "./LiveTranslatedText";

// Where enriched text came from (set by enrich-temples.mjs in metadata.enrichment.fields).
// Wikipedia text is CC BY-SA, so it is always credited.
const PROVENANCE = {
  wikipedia_section: "Adapted from Wikipedia (CC BY-SA 4.0).",
  wikipedia_sentences: "Adapted from Wikipedia (CC BY-SA 4.0).",
  "wikipedia_sentences+wikidata_facts": "Adapted from Wikipedia (CC BY-SA 4.0) and Wikidata.",
  wikidata_facts: "Compiled from Wikidata records.",
  web_search_llm: "Summarised from the web sources listed under Sources & References.",
};

const hostOf = (url = "") => { try { return new URL(url).hostname.replace(/^www\./, ""); } catch { return "source"; } };

/**
 * A titled card for History / Architecture / Cultural Significance.
 * Never renders an empty card: with no text it shows `fallback` plus a link to
 * the best available source.
 */
export default function TempleSection({ title, label, text, fallback, provenance, source, patterned = false }) {
  const hasText = Boolean(String(text || "").trim());
  const credit = hasText ? PROVENANCE[provenance] : null;
  return (
    <section aria-label={label || title}>
      <h2 className="font-display text-2xl font-bold text-midnight sm:text-3xl">{title}</h2>
      <div className="card relative mt-5 overflow-hidden p-6 sm:p-8">
        {patterned && <div className="pattern-lines pointer-events-none absolute inset-0" aria-hidden="true" />}
        <div className="relative">
          {hasText ? (
            <LiveTranslatedText as="p" text={text} className="leading-relaxed whitespace-pre-line text-midnight-700/85" />
          ) : (
            <>
              <LiveTranslatedText as="p" text={fallback} className="leading-relaxed text-midnight-700/70" />
              {source?.url && (
                <a
                  href={source.url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="mt-3 inline-flex items-center gap-1.5 text-sm font-bold text-saffron-700 hover:underline"
                >
                  Read more on {source.type === "Wikipedia" ? "Wikipedia" : hostOf(source.url)}
                  <ExternalLink className="h-3.5 w-3.5" aria-hidden="true" />
                </a>
              )}
            </>
          )}
          {credit && <p className="mt-4 text-xs text-midnight-700/50">{credit}</p>}
        </div>
      </div>
    </section>
  );
}
