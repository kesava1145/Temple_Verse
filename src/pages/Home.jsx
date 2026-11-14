import React, { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import {
  ArrowRight, Bot, Sparkles, Search, X, Network,
  BookOpen, Download, Landmark, Compass, Headphones, Square,
} from "lucide-react";
import { getTemples } from "../services/templeService";
import { useLanguage } from "../context/LanguageContext";
import { useGuide } from "../context/GuideContext";
import TempleCard from "../components/TempleCard";
import LoadingSpinner from "../components/LoadingSpinner";
import ErrorState from "../components/ErrorState";
import Reveal from "../components/Reveal";
import AryaAvatar from "../components/AryaAvatar";
import SacredThreads from "../components/SacredThreads";
import heroArtwork from "../assets-home-hero.jpg";

const FEATURES = [
  {
    title: "Explore temples",
    description: "Discover temples across India and find places by name, deity, region or tradition.",
    icon: Compass,
    to: "/temples",
    label: "Explore catalogue",
  },
  {
    title: "Sacred connections",
    description: "See how temples are connected through shared history, deities and traditions.",
    icon: Network,
    to: "/connections",
    label: "View connections",
  },
  {
    title: "Arya – your temple guide",
    description: "Ask questions and learn about temple history, mythology and cultural significance.",
    icon: Bot,
    to: "/guide",
    label: "Meet Arya",
  },
  {
    title: "Guided experiences",
    description: "Explore temple stories and important places through guided information.",
    icon: BookOpen,
    to: "/temples",
    label: "Find a temple",
  },
  {
    title: "Offline access",
    description: "Open temple information that has been saved for offline exploration.",
    icon: Download,
    to: "/offline",
    label: "Explore offline",
  },
  {
    title: "About TempleVerse",
    description: "Learn about the platform and its mission to preserve temple knowledge.",
    icon: Landmark,
    to: "/about",
    label: "Learn more",
  },
];

export default function Home() {
  const { t, name } = useLanguage();
  const { setContext, state, speak, stop } = useGuide();
  const speaking = state === "speaking";
  const greeting = t("guide.hero.sub");
  const navigate = useNavigate();
  const [temples, setTemples] = useState(null);
  const [error, setError] = useState(false);
  const [search, setSearch] = useState("");
  const [searchResults, setSearchResults] = useState([]);
  const [searching, setSearching] = useState(false);
  const [searchError, setSearchError] = useState(false);
  const [showResults, setShowResults] = useState(false);

  // Arya has no selected temple while the visitor is on the homepage.
  useEffect(() => setContext(null, null), [setContext]);

  const load = () => {
    setError(false);
    getTemples().then(setTemples).catch(() => setError(true));
  };
  useEffect(() => { load(); }, []);

  // Search the same catalogue used by the Temple Explorer.
  useEffect(() => {
    const query = search.trim();
    if (!query) {
      setSearchResults([]);
      setSearching(false);
      setSearchError(false);
      return undefined;
    }

    let active = true;
    setSearching(true);
    setSearchError(false);
    const timer = window.setTimeout(() => {
      getTemples({ search: query })
        .then((results) => {
          if (active) setSearchResults(results.slice(0, 6));
        })
        .catch(() => {
          if (active) setSearchError(true);
        })
        .finally(() => {
          if (active) setSearching(false);
        });
    }, 250);

    return () => {
      active = false;
      window.clearTimeout(timer);
    };
  }, [search]);

  const locationTotal = temples?.reduce((sum, temple) => sum + (temple.location_count || 0), 0);

  const submitSearch = (event) => {
    event.preventDefault();
    const query = search.trim();
    if (!query) return;
    if (searchResults.length === 1) {
      navigate(`/temple/${searchResults[0].slug}`);
      return;
    }
    navigate(`/temples?search=${encodeURIComponent(query)}`);
  };

  const openTemple = (temple) => {
    setShowResults(false);
    setSearch("");
    navigate(`/temple/${temple.slug}`);
  };

  return (
    <main>
      {/* Heritage hero: warm temple artwork with live, accessible controls. */}
      <section className="home-heritage-hero relative isolate overflow-hidden">
        <div className="home-heritage-art pointer-events-none absolute inset-y-0 right-0" aria-hidden="true">
          <img src={heroArtwork} alt="" className="h-full w-full object-cover object-right" />
        </div>
        <div className="home-heritage-wash pointer-events-none absolute inset-0" aria-hidden="true" />
        <div className="relative mx-auto grid min-h-[690px] max-w-7xl items-center gap-8 px-4 py-14 sm:px-6 lg:min-h-[740px] lg:grid-cols-[0.95fr_1.05fr] lg:py-16">
          <div className="home-heritage-copy relative z-10 max-w-2xl">
            <span className="inline-flex items-center gap-2 text-xs font-extrabold tracking-[0.2em] text-[#7b351c] uppercase">
              <span className="h-px w-8 bg-[#b88745]" />
              <Sparkles className="h-3.5 w-3.5 text-[#a96a21]" aria-hidden="true" />
              Discover India's sacred heritage
              <span className="h-px w-8 bg-[#b88745]" />
            </span>
            <h1 className="mt-6 max-w-xl font-display text-5xl leading-[1.02] font-bold tracking-tight text-[#542514] sm:text-6xl lg:text-[4.5rem]">
              Where <em className="text-[#28564b]">History</em><br />Meets <em className="text-[#8e281e]">Divinity</em>
            </h1>
            <p className="mt-6 max-w-lg text-base leading-relaxed text-[#593d30]/85 sm:text-lg">
              Explore the timeless stories, sacred architecture, and spiritual wonders of India's temples.
            </p>

            <div className="mt-8 flex flex-wrap gap-3">
              <Link to="/temples" className="home-heritage-primary">
                <Landmark className="h-4 w-4" aria-hidden="true" />
                Explore Temples <ArrowRight className="h-4 w-4" aria-hidden="true" />
              </Link>
              <Link to="/about" className="home-heritage-secondary">
                <Compass className="h-4 w-4" aria-hidden="true" />
                Discover Heritage
              </Link>
            </div>

            <div className="relative mt-9 max-w-xl text-left">
              <form onSubmit={submitSearch} className="flex items-center gap-2 rounded-2xl border border-[#7c4a2b]/20 bg-white/95 p-2 shadow-xl shadow-[#6c391c]/15 backdrop-blur-sm">
                <Search className="ml-3 h-5 w-5 shrink-0 text-[#765b4c]/60" aria-hidden="true" />
                <input
                  type="search"
                  value={search}
                  onFocus={() => setShowResults(true)}
                  onChange={(event) => { setSearch(event.target.value); setShowResults(true); }}
                  placeholder="Search temples by name, deity, city or state..."
                  aria-label="Search temples by name, deity, city or state"
                  className="min-w-0 flex-1 bg-transparent px-1 py-3 text-sm font-semibold text-[#39251c] outline-none placeholder:text-[#806e63] sm:text-base"
                />
                {search && (
                  <button type="button" onClick={() => { setSearch(""); setShowResults(false); }} className="rounded-lg p-2 text-[#765b4c]/60 hover:bg-[#7c4a2b]/10" aria-label="Clear search">
                    <X className="h-4 w-4" />
                  </button>
                )}
                <button type="submit" className="home-heritage-search-btn">
                  <span className="hidden sm:inline">Search</span>
                  <Search className="h-4 w-4 sm:hidden" aria-hidden="true" />
                </button>
              </form>

              {showResults && search.trim() && (
                <div className="absolute z-30 mt-2 w-full overflow-hidden rounded-2xl border border-[#7c4a2b]/15 bg-white text-[#39251c] shadow-2xl">
                  {searching ? (
                    <p className="px-5 py-4 text-sm text-[#765b4c]">Searching the temple catalogue...</p>
                  ) : searchError ? (
                    <p className="px-5 py-4 text-sm text-red-600">Could not search right now. Please try again.</p>
                  ) : searchResults.length ? (
                    <>
                      {searchResults.map((temple) => (
                        <button key={temple.id} type="button" onClick={() => openTemple(temple)} className="flex w-full items-center justify-between gap-4 border-b border-[#7c4a2b]/10 px-5 py-3 text-left transition-colors last:border-0 hover:bg-[#fbf0df]">
                          <span className="min-w-0">
                            <span className="block truncate text-sm font-bold">{name(temple)}</span>
                            <span className="mt-0.5 block truncate text-xs text-[#765b4c]/75">{[temple.city, temple.state].filter(Boolean).join(", ")}</span>
                          </span>
                          <ArrowRight className="h-4 w-4 shrink-0 text-[#a64b22]" aria-hidden="true" />
                        </button>
                      ))}
                      <button type="button" onClick={submitSearch} className="w-full bg-[#7c4a2b]/5 px-5 py-3 text-left text-xs font-extrabold text-[#8e3b20] hover:bg-[#fbf0df]">
                        View all matching temples <ArrowRight className="ml-1 inline h-3 w-3" />
                      </button>
                    </>
                  ) : (
                    <div className="px-5 py-4">
                      <p className="text-sm font-bold">No matching temple found in the current catalogue.</p>
                      <p className="mt-1 text-xs text-[#765b4c]/75">Try another spelling, deity, city or state.</p>
                    </div>
                  )}
                </div>
              )}
            </div>

            <div className="mt-4 flex flex-wrap items-center gap-2 text-xs text-[#765b4c]">
              <span className="font-semibold">Try:</span>
              {["Meenakshi", "Tirumala", "Konark", "Shore Temple"].map((term) => (
                <button key={term} onClick={() => { setSearch(term); setShowResults(true); }} className="rounded-full border border-[#8b674c]/25 bg-white/45 px-3 py-1 transition-colors hover:border-[#a64b22]/60 hover:bg-white/80">{term}</button>
              ))}
            </div>

            <dl className="mt-9 flex max-w-md gap-8 border-t border-[#8b674c]/20 pt-5">
              {[
                { value: temples?.length ?? "—", label: t("hero.stat.temples") },
                { value: locationTotal ?? "—", label: t("hero.stat.locations") },
                { value: "5", label: t("hero.stat.languages") },
              ].map((stat) => (
                <div key={stat.label}>
                  <dt className="sr-only">{stat.label}</dt>
                  <dd className="font-display text-2xl font-bold text-[#a64b22]">{stat.value}</dd>
                  <dd className="mt-0.5 text-xs font-semibold text-[#765b4c]/75">{stat.label}</dd>
                </div>
              ))}
            </dl>
          </div>
          <div className="hidden lg:block" aria-hidden="true" />
        </div>
      </section>

      {/* All platform features are visible from the homepage. */}
      <section className="mx-auto max-w-7xl px-4 pt-20 pb-12 sm:px-6">
        <Reveal>
          <div className="mx-auto max-w-2xl text-center">
            <span className="chip chip-gold"><Sparkles className="mr-1 inline h-3 w-3" /> Discover TempleVerse</span>
            <h2 className="mt-4 font-display text-3xl font-bold text-midnight sm:text-4xl">Everything to explore sacred heritage</h2>
            <p className="mt-3 text-midnight-700/70">Explore temples, understand their stories, discover connections and learn with Arya — all in one place.</p>
          </div>
        </Reveal>
        <div className="mt-10 grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
          {FEATURES.map((feature, index) => {
            const Icon = feature.icon;
            return (
              <Reveal key={feature.title} delay={index * 65}>
                <Link to={feature.to} className="group flex h-full flex-col rounded-2xl border border-midnight/10 bg-white p-6 shadow-sm transition-all hover:-translate-y-1 hover:border-saffron/40 hover:shadow-xl">
                  <span className="flex h-12 w-12 items-center justify-center rounded-xl bg-midnight text-saffron transition-colors group-hover:bg-saffron group-hover:text-midnight">
                    <Icon className="h-5 w-5" aria-hidden="true" />
                  </span>
                  <h3 className="mt-5 font-display text-xl font-bold text-midnight">{feature.title}</h3>
                  <p className="mt-2 flex-1 text-sm leading-relaxed text-midnight-700/65">{feature.description}</p>
                  <span className="mt-5 inline-flex items-center gap-2 text-xs font-extrabold text-saffron-800">{feature.label}<ArrowRight className="h-3.5 w-3.5 transition-transform group-hover:translate-x-1" /></span>
                </Link>
              </Reveal>
            );
          })}
        </div>
      </section>

      {/* Featured temples are data-driven, never hardcoded to one temple. */}
      <section className="mx-auto max-w-7xl px-4 pt-10 pb-16 sm:px-6">
        <Reveal>
          <div className="flex flex-wrap items-end justify-between gap-4">
            <div>
              <span className="chip chip-gold">🛕</span>
              <h2 className="mt-3 font-display text-3xl font-bold text-midnight sm:text-4xl">{t("featured.title")}</h2>
              <p className="mt-2 max-w-2xl text-midnight-700/70">{t("featured.subtitle")}</p>
            </div>
            <Link to="/temples" className="btn btn-outline btn-sm">{t("hero.cta.primary")}<ArrowRight className="h-4 w-4" aria-hidden="true" /></Link>
          </div>
        </Reveal>
        {error ? (
          <ErrorState title={t("common.error.title")} message={t("common.error.desc")} onRetry={load} />
        ) : !temples ? (
          <LoadingSpinner label={t("common.loading.temple")} />
        ) : temples.length ? (
          <div className="mt-10 grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            {temples.slice(0, 3).map((temple, index) => (
              <Reveal key={temple.id} delay={index * 90}><TempleCard temple={temple} /></Reveal>
            ))}
          </div>
        ) : (
          <p className="mt-8 text-center text-sm text-midnight/60">Temple records will appear here when the catalogue is connected.</p>
        )}
      </section>

      <SacredThreads variant="discovery" limit={3} />

      {/* Arya remains a platform-wide guide, not attached to a single temple. */}
      <section className="relative bg-midnight py-20 text-white">
        <div className="pattern-dots-light pointer-events-none absolute inset-0 opacity-25" aria-hidden="true" />
        <div className="relative mx-auto max-w-7xl px-4 sm:px-6">
          <Reveal>
            <div className="grid items-center gap-10 lg:grid-cols-[auto_1fr]">
              <div className="mx-auto lg:mx-0"><AryaAvatar state="idle" size={190} /></div>
              <div>
                <span className="chip chip-light"><Bot className="h-3 w-3 text-saffron" aria-hidden="true" />{t("arya.role")}</span>
                <h2 className="mt-4 font-display text-3xl font-bold sm:text-4xl">{t("guide.hero.title")}</h2>
                <p className="mt-3 max-w-2xl leading-relaxed text-white/80">{t("guide.hero.sub")}</p>
                <div className="mt-6 flex flex-wrap items-center gap-3">
                  <button onClick={() => (speaking ? stop() : speak(greeting))} className="btn btn-primary">
                    {speaking ? <><Square className="h-4 w-4" fill="currentColor" />{t("arya.stop")}</> : <><Headphones className="h-4 w-4" />{t("arya.listen")}</>}
                  </button>
                  <Link to="/guide" className="btn btn-ghost-light"><Bot className="h-4 w-4" />{t("arya.ask")}</Link>
                </div>
                {temples?.length > 0 && (
                  <div className="mt-7">
                    <p className="text-[11px] font-extrabold tracking-wider text-white/40 uppercase">{t("guide.pick")}</p>
                    <div className="mt-2.5 flex flex-wrap gap-2">
                      {temples.slice(0, 8).map((temple) => (
                        <button key={temple.id} onClick={() => navigate(`/temple/${temple.slug}/guided`)} className="rounded-full border border-white/15 bg-white/5 px-3.5 py-1.5 text-xs font-bold text-white/80 transition-colors hover:border-saffron/60 hover:text-saffron-300">{name(temple)}</button>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            </div>
          </Reveal>
        </div>
      </section>

      <section className="mx-auto max-w-7xl px-4 py-16 sm:px-6">
        <Reveal>
          <div className="relative overflow-hidden rounded-3xl bg-gradient-to-br from-midnight-700 to-midnight-900 px-6 py-12 text-center text-white shadow-2xl sm:px-12">
            <div className="pattern-arch pointer-events-none absolute inset-0 opacity-60" aria-hidden="true" />
            <h2 className="relative font-display text-3xl font-bold sm:text-4xl">{t("cta.title")}</h2>
            <p className="relative mx-auto mt-3 max-w-xl text-white/80">{t("cta.subtitle")}</p>
            <div className="relative mt-7 flex flex-wrap justify-center gap-3">
              <Link to="/temples" className="btn btn-primary">{t("cta.button")}<ArrowRight className="h-4 w-4" /></Link>
              <Link to="/guide" className="btn btn-ghost-light"><Bot className="h-4 w-4" />{t("hero.cta.guide")}</Link>
            </div>
          </div>
        </Reveal>
      </section>
    </main>
  );
}
