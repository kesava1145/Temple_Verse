import React from "react";
import { useEffect, useMemo, useRef, useState } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { Search, SlidersHorizontal, X, MapPin, Landmark, Sparkles } from "lucide-react";
import { getTemples, getStates } from "../services/templeService";
import { useLanguage } from "../context/LanguageContext";
import TempleCard from "../components/TempleCard";
import LoadingSpinner from "../components/LoadingSpinner";
import ErrorState from "../components/ErrorState";
import Reveal from "../components/Reveal";
import exploreHero from "../assets-explore-temples-hero.png";

export default function Temples() {
  const { t, name } = useLanguage();
  const navigate = useNavigate();
  const [searchParams, setSearchParams] = useSearchParams();
  const [temples, setTemples] = useState(null);
  const [states, setStates] = useState([]);
  const [error, setError] = useState(false);
  const [search, setSearch] = useState(searchParams.get("search") || "");
  const [debounced, setDebounced] = useState(search);
  const [stateFilter, setStateFilter] = useState("");
  const [open, setOpen] = useState(false);
  const [active, setActive] = useState(-1);
  const boxRef = useRef(null);

  // Wait briefly after typing so the list (and the suggestions) don't flicker per keystroke.
  useEffect(() => {
    const id = setTimeout(() => setDebounced(search), 180);
    return () => clearTimeout(id);
  }, [search]);

  const load = () => {
    setError(false);
    Promise.all([getTemples({ search: debounced, state: stateFilter }), getStates()])
      .then(([list, stateList]) => { setTemples(list); setStates(stateList); })
      .catch((err) => {
        console.error("TempleVerse: catalogue search failed.", err);
        setError(true);
      });
  };

  useEffect(load, [debounced, stateFilter]);

  // Keep homepage searches shareable and in sync with the explorer input.
  useEffect(() => {
    const urlSearch = searchParams.get("search") || "";
    if (urlSearch !== search) setSearch(urlSearch);
  }, [searchParams]);

  useEffect(() => {
    const current = searchParams.get("search") || "";
    if (search !== current) {
      const next = new URLSearchParams(searchParams);
      if (search.trim()) next.set("search", search.trim());
      else next.delete("search");
      setSearchParams(next, { replace: true });
    }
  }, [search]);

  const shownCount = useMemo(() => temples?.length ?? 0, [temples]);

  // Suggestions come from the same search results; names that start with the query rank first.
  const suggestions = useMemo(() => {
    const q = search.trim().toLocaleLowerCase();
    if (!q || !temples) return [];
    const rank = (x) => {
      const n = name(x).toLocaleLowerCase();
      return n.startsWith(q) ? 0 : n.includes(q) ? 1 : 2;
    };
    return [...temples].sort((x, y) => rank(x) - rank(y)).slice(0, 8);
  }, [temples, search, name]);

  useEffect(() => { setActive(-1); }, [search]);
  useEffect(() => {
    const close = (e) => { if (boxRef.current && !boxRef.current.contains(e.target)) setOpen(false); };
    document.addEventListener("mousedown", close);
    return () => document.removeEventListener("mousedown", close);
  }, []);

  const openTemple = (temple) => { setOpen(false); navigate(`/temple/${temple.slug}`); };
  const onKeyDown = (e) => {
    if (e.key === "Escape") { setOpen(false); return; }
    if (!suggestions.length) return;
    if (e.key === "ArrowDown") { e.preventDefault(); setOpen(true); setActive((i) => (i + 1) % suggestions.length); }
    else if (e.key === "ArrowUp") { e.preventDefault(); setActive((i) => (i <= 0 ? suggestions.length - 1 : i - 1)); }
    else if (e.key === "Enter" && active >= 0) { e.preventDefault(); openTemple(suggestions[active]); }
    else if (e.key === "Enter") setOpen(false);
  };

  return (
    <main className="temple-explorer-page min-h-screen">
      <section
        className="temple-explorer-hero relative isolate z-20"
        style={{ backgroundImage: `url(${exploreHero})` }}
      >
        <div className="temple-explorer-hero__shade" aria-hidden="true" />
        <div className="relative z-10 mx-auto flex min-h-[440px] max-w-7xl flex-col justify-center px-4 pb-10 pt-14 sm:min-h-[470px] sm:px-6 lg:min-h-[500px]">
          <div className="max-w-xl">
            <span className="inline-flex items-center gap-2 rounded-full border border-saffron-300/50 bg-midnight/45 px-4 py-2 text-xs font-bold uppercase tracking-[0.18em] text-saffron-300 shadow-lg backdrop-blur-sm">
              <Sparkles className="h-4 w-4" aria-hidden="true" /> Discover India's sacred heritage
            </span>
            <h1 className="mt-5 font-display text-4xl font-bold leading-[1.05] text-white drop-shadow-lg sm:text-5xl lg:text-6xl">
              Explore India’s
              <span className="mt-1 block text-saffron-300 italic">Temples</span>
            </h1>
            <p className="mt-5 max-w-md border-l-2 border-saffron-400 pl-4 text-base leading-relaxed text-white/90 drop-shadow sm:text-lg">
              Discover, learn, and connect with the timeless temples across India.
            </p>
          </div>

          <div className="mt-8 grid max-w-4xl gap-3 sm:grid-cols-[minmax(0,1fr)_230px]">
            <div ref={boxRef} className="relative">
              <Search className="pointer-events-none absolute left-5 top-1/2 h-5 w-5 -translate-y-1/2 text-midnight/65" aria-hidden="true" />
              <input
                type="text"
                role="combobox"
                aria-label={t("temples.search")}
                aria-expanded={open && suggestions.length > 0}
                aria-controls="temple-suggestions"
                aria-autocomplete="list"
                autoComplete="off"
                value={search}
                onChange={(e) => { setSearch(e.target.value); setOpen(true); }}
                onFocus={() => setOpen(true)}
                onKeyDown={onKeyDown}
                placeholder="Search temples by name, deity, state or style..."
                className="w-full rounded-2xl border border-white/70 bg-cream px-5 py-4 pl-14 pr-12 text-sm font-semibold text-midnight shadow-[0_12px_35px_rgba(0,0,0,0.22)] outline-none transition focus:border-saffron focus:ring-4 focus:ring-saffron/25 sm:text-base"
              />
              {search && (
                <button
                  type="button"
                  onClick={() => { setSearch(""); setOpen(false); }}
                  className="absolute right-4 top-1/2 -translate-y-1/2 rounded-full p-1 text-midnight/60 transition hover:bg-midnight/10 hover:text-midnight"
                  aria-label="Clear search"
                >
                  <X className="h-4 w-4" aria-hidden="true" />
                </button>
              )}

              {open && search.trim() && (
                <ul
                  id="temple-suggestions"
                  role="listbox"
                  className="absolute left-0 right-0 top-full z-50 mt-2 max-h-[min(60vh,420px)] overflow-y-auto rounded-2xl border border-midnight/10 bg-white py-1.5 shadow-2xl"
                >
                  {suggestions.length ? suggestions.map((temple, i) => (
                    <li key={temple.id} role="option" aria-selected={i === active}>
                      <button
                        type="button"
                        onMouseEnter={() => setActive(i)}
                        onClick={() => openTemple(temple)}
                        className={`flex w-full items-center gap-3 px-4 py-2.5 text-left transition-colors ${i === active ? "bg-[#fbf0df]" : "hover:bg-[#fbf0df]"}`}
                      >
                        <MapPin className="h-4 w-4 shrink-0 text-saffron-600" aria-hidden="true" />
                        <span className="min-w-0">
                          <span className="block truncate text-sm font-bold text-midnight">{name(temple)}</span>
                          {(temple.city || temple.state) && (
                            <span className="block truncate text-xs text-midnight/55">{[temple.city, temple.state].filter(Boolean).join(", ")}</span>
                          )}
                        </span>
                      </button>
                    </li>
                  )) : (
                    <li className="px-4 py-3 text-sm text-midnight/60">{temples ? "No matching temples found." : "Searching…"}</li>
                  )}
                </ul>
              )}
            </div>
            <label className="relative block">
              <span className="sr-only">{t("temples.filter")}</span>
              <SlidersHorizontal className="pointer-events-none absolute left-4 top-1/2 h-4 w-4 -translate-y-1/2 text-midnight/60" aria-hidden="true" />
              <select
                value={stateFilter}
                onChange={(e) => setStateFilter(e.target.value)}
                className="w-full appearance-none rounded-2xl border border-saffron-300/60 bg-midnight/85 py-4 pl-11 pr-9 text-sm font-bold text-white shadow-lg outline-none backdrop-blur transition focus:border-saffron focus:ring-4 focus:ring-saffron/25"
              >
                <option value="">All states</option>
                {states.map((state) => (
                  <option key={state} value={state} className="bg-midnight text-white">
                    {state}
                  </option>
                ))}
              </select>
            </label>
          </div>

          <div className="mt-4 flex flex-wrap items-center gap-2 text-xs text-white/75">
            <span className="mr-1 font-semibold uppercase tracking-wider text-saffron-200">Explore by</span>
            <span className="rounded-full border border-white/25 bg-midnight/35 px-3 py-1.5 backdrop-blur"> <MapPin className="mr-1 inline h-3 w-3"/> State</span>
            <span className="rounded-full border border-white/25 bg-midnight/35 px-3 py-1.5 backdrop-blur"><Landmark className="mr-1 inline h-3 w-3"/> Temple</span>
            <span className="rounded-full border border-white/25 bg-midnight/35 px-3 py-1.5 backdrop-blur">History & heritage</span>
          </div>
        </div>
      </section>

      <section className="temple-explorer-results mx-auto max-w-7xl px-4 pb-16 pt-10 sm:px-6">
        <div className="mb-8 flex flex-col items-center justify-between gap-3 text-center sm:flex-row sm:text-left">
          <div>
            <div className="mb-2 flex items-center justify-center gap-3 sm:justify-start">
              <span className="h-px w-9 bg-saffron-400" />
              <span className="text-xs font-bold uppercase tracking-[0.22em] text-saffron-300">Sacred places of India</span>
              <span className="h-px w-9 bg-saffron-400" />
            </div>
            <h2 className="font-display text-3xl font-bold text-cream sm:text-4xl">{search.trim() ? "Search Results" : "Featured Temples"}</h2>
          </div>
          {temples && (
            <p className="rounded-full border border-saffron-300/35 bg-white/5 px-4 py-2 text-sm font-semibold text-cream/75">
              <span className="text-saffron-300">{shownCount}</span> {t("temples.count")}
            </p>
          )}
        </div>

        {error ? (
          <ErrorState title={t("common.error.title")} message={t("common.error.desc")} onRetry={load} />
        ) : !temples ? (
          <LoadingSpinner label={t("common.loading.temple")} full />
        ) : shownCount === 0 ? (
          <div className="flex flex-col items-center gap-4 rounded-3xl border border-white/10 bg-white/5 px-6 py-20 text-center text-cream">
            <span className="flex h-16 w-16 items-center justify-center rounded-full border border-saffron-300/30 bg-saffron-300/10">
              <Search className="h-7 w-7 text-saffron-300" aria-hidden="true" />
            </span>
            <h2 className="font-display text-2xl font-bold">{t("temples.empty.title")}</h2>
            <p className="max-w-sm text-sm text-cream/65">{t("temples.empty.desc")}</p>
            <button
              className="btn btn-primary btn-sm mt-2"
              onClick={() => {
                setSearch("");
                setStateFilter("");
              }}
            >
              {t("temples.empty.clear")}
            </button>
          </div>
        ) : (
          <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
            {temples.map((temple, i) => (
              <Reveal key={temple.id} delay={i * 100}>
                <TempleCard temple={temple} />
              </Reveal>
            ))}
          </div>
        )}
      </section>
    </main>
  );
}
