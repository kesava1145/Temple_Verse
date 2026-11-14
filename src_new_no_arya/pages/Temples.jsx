import React from "react";
import { useEffect, useMemo, useState } from "react";
import { useSearchParams } from "react-router-dom";
import { Search, SlidersHorizontal, X, MapPin, Landmark, Sparkles } from "lucide-react";
import { getTemples, getStates, getTempleFilterOptions } from "../services/templeService";
import { useLanguage } from "../context/LanguageContext";
import TempleCard from "../components/TempleCard";
import LoadingSpinner from "../components/LoadingSpinner";
import ErrorState from "../components/ErrorState";
import Reveal from "../components/Reveal";
import exploreHero from "../assets-explore-temples-hero.png";

export default function Temples() {
  const { t } = useLanguage();
  const [searchParams, setSearchParams] = useSearchParams();
  const [temples, setTemples] = useState(null);
  const [states, setStates] = useState([]);
  const [facets, setFacets] = useState({});
  const [error, setError] = useState(false);
  const [search, setSearch] = useState(searchParams.get("search") || "");
  const [stateFilter, setStateFilter] = useState("");
  const [metadataFilters, setMetadataFilters] = useState({
    deity: "", architecture: "", dynasty: "", festival: "", jatra: "",
    category: "", tradition: "",
  });

  const load = () => {
    setError(false);
    setTemples(null);
    Promise.all([
      getTemples({ search, state: stateFilter, ...metadataFilters }),
      getStates(),
      getTempleFilterOptions(),
    ])
      .then(([list, stateList, filterOptions]) => {
        setTemples(list);
        setStates(stateList);
        setFacets(filterOptions || {});
      })
      .catch((err) => {
        console.error("TempleVerse: catalogue search failed.", err);
        setError(true);
      });
  };

  useEffect(load, [search, stateFilter, ...Object.values(metadataFilters)]);

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

  return (
    <main className="temple-explorer-page min-h-screen">
      <section
        className="temple-explorer-hero relative isolate overflow-hidden"
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
            <label className="relative block">
              <span className="sr-only">{t("temples.search")}</span>
              <Search className="absolute left-5 top-1/2 h-5 w-5 -translate-y-1/2 text-midnight/65" aria-hidden="true" />
              <input
                type="search"
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                placeholder="Search temples by name, deity, state or style..."
                className="w-full rounded-2xl border border-white/70 bg-cream px-5 py-4 pl-14 pr-12 text-sm font-semibold text-midnight shadow-[0_12px_35px_rgba(0,0,0,0.22)] outline-none transition focus:border-saffron focus:ring-4 focus:ring-saffron/25 sm:text-base"
              />
              {search && (
                <button
                  type="button"
                  onClick={() => setSearch("")}
                  className="absolute right-4 top-1/2 -translate-y-1/2 rounded-full p-1 text-midnight/60 transition hover:bg-midnight/10 hover:text-midnight"
                  aria-label="Clear search"
                >
                  <X className="h-4 w-4" aria-hidden="true" />
                </button>
              )}
            </label>
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

      <section className="mx-auto -mt-5 max-w-7xl px-4 sm:px-6">
        <details className="group rounded-2xl border border-midnight/10 bg-white p-4 shadow-sm">
          <summary className="flex cursor-pointer list-none items-center justify-between gap-3 font-bold text-midnight">
            <span className="flex items-center gap-2"><SlidersHorizontal className="h-4 w-4 text-saffron-700"/> Advanced metadata filters</span>
            <span className="text-xs font-semibold text-midnight/50 group-open:hidden">Show filters</span>
            <span className="hidden text-xs font-semibold text-midnight/50 group-open:inline">Hide filters</span>
          </summary>
          <div className="mt-4 grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
            {[
              ["deity", "Deity", facets.deities],
              ["architecture", "Architecture", facets.architectures],
              ["dynasty", "Dynasty", facets.dynasties],
              ["festival", "Festival", facets.festivals],
              ["jatra", "Jatra", facets.jatras],
              ["category", "Temple category", facets.categories],
              ["tradition", "Religious tradition", facets.traditions],
            ].map(([key, label, values]) => (
              <label key={key} className="text-xs font-bold text-midnight/65">
                {label}
                <select
                  value={metadataFilters[key]}
                  onChange={(e) => setMetadataFilters((current) => ({ ...current, [key]: e.target.value }))}
                  className="mt-1 block w-full rounded-xl border border-midnight/15 bg-cream px-3 py-3 text-sm font-semibold text-midnight outline-none focus:border-saffron focus:ring-2 focus:ring-saffron/20"
                >
                  <option value="">All {label.toLowerCase()}</option>
                  {(values || []).map((value) => <option key={value} value={value}>{value}</option>)}
                </select>
              </label>
            ))}
            <button
              type="button"
              onClick={() => { setStateFilter(""); setMetadataFilters({ deity: "", architecture: "", dynasty: "", festival: "", jatra: "", category: "", tradition: "" }); }}
              className="self-end rounded-xl border border-midnight/15 px-4 py-3 text-sm font-bold text-midnight/70 hover:border-saffron hover:text-saffron-700"
            >Clear filters</button>
          </div>
        </details>
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
                setMetadataFilters({ deity: "", architecture: "", dynasty: "", festival: "", jatra: "", category: "", tradition: "" });
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
