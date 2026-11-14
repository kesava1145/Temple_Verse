// "Not in TempleVerse yet?" assistance. Looks the query up on Wikipedia so a
// search that finds nothing locally still leads somewhere useful.
//
// Uses the public MediaWiki API (CORS-enabled via origin=*): no API key and no
// secret in the browser. The private SearXNG / Ollama pipeline stays
// server-side in the temple-discovery edge function.
import { normalize } from "../lib/searchRank";

const cache = new Map();
const TEMPLE_WORDS = /\b(temple|mandir|kovil|koil|devalayam|devasthanam|shrine|math|matha)\b/i;

const stripHtml = (html = "") => html
  .replace(/<[^>]+>/g, "")
  .replace(/&quot;/g, '"').replace(/&amp;/g, "&").replace(/&#039;/g, "'")
  .replace(/\s+/g, " ").trim();

/**
 * @param {string} query user search text
 * @param {{signal?: AbortSignal, exclude?: string[], limit?: number}} options
 *        `exclude` = names already shown, so we never repeat them.
 * @returns {Promise<Array<{title: string, snippet: string, url: string}>>}
 */
export async function searchWikipediaTemples(query, { signal, exclude = [], limit = 4 } = {}) {
  const q = String(query || "").trim();
  if (q.length < 3) return [];
  const key = normalize(q);

  let results = cache.get(key);
  if (!results) {
    const scoped = TEMPLE_WORDS.test(q) ? `${q} India` : `${q} temple India`;
    const url = "https://en.wikipedia.org/w/api.php?" + new URLSearchParams({
      action: "query", list: "search", srsearch: scoped, srlimit: "8",
      srnamespace: "0", format: "json", origin: "*",
    });
    try {
      const response = await fetch(url, { signal, headers: { Accept: "application/json" } });
      if (!response.ok) return [];
      const data = await response.json();
      results = (data?.query?.search || []).map((hit) => ({
        title: hit.title,
        snippet: stripHtml(hit.snippet),
        url: `https://en.wikipedia.org/wiki/${encodeURIComponent(hit.title.replace(/ /g, "_"))}`,
      }));
      cache.set(key, results);
    } catch {
      return []; // offline, blocked or aborted: assistance is optional
    }
  }

  const seen = new Set(exclude.map(normalize));
  return results.filter((r) => !seen.has(normalize(r.title))).slice(0, limit);
}
