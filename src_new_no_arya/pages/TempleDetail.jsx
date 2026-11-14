import React from "react";
import { useCallback, useEffect, useState } from "react";
import { Link, useNavigate, useParams } from "react-router-dom";
import {
  ArrowLeft, ArrowRight, Calendar, CheckCircle2, Compass, Download,
  Flame, Landmark, MapPin, Trash2, ChevronDown, Flower2, ArrowUpDown,
} from "lucide-react";
import { getTempleBySlug } from "../services/templeService";
import { saveTempleOffline, removeTempleOffline, isTempleOffline } from "../lib/offline";
import { useLanguage } from "../context/LanguageContext";
import useSmartBack from "../hooks/useSmartBack";
import LoadingSpinner from "../components/LoadingSpinner";
import ErrorState from "../components/ErrorState";
import SmartImage from "../components/SmartImage";
import LocationCard from "../components/LocationCard";
import TempleMap from "../components/TempleMap";
import SacredThreads from "../components/SacredThreads";
import TempleTraditions from "../components/TempleTraditions";
import { Timeline, Gallery, Sources } from "../components/TempleExtras";
import meenakshiHeroImage from "../assets-meenakshi-hero.jpg";

export default function TempleDetail() {
  const { slug } = useParams();
  const { t, name, C } = useLanguage();
  const navigate = useNavigate();
  const goBack = useSmartBack("/temples");

  const [temple, setTemple] = useState(null);
  const [error, setError] = useState(false);
  const [offline, setOffline] = useState(false);
  const [toast, setToast] = useState("");

  const load = useCallback(() => {
    setError(false);
    setTemple(null);
    getTempleBySlug(slug)
      .then((data) => {
        if (!data) return setError(true);
        setTemple(data);
        setOffline(isTempleOffline(data.slug));
      })
      .catch(() => setError(true));
  }, [slug]);

  useEffect(load, [load]);

  useEffect(() => {
    if (!toast) return;
    const timer = setTimeout(() => setToast(""), 3000);
    return () => clearTimeout(timer);
  }, [toast]);

  if (error) return <ErrorState title={t("common.error.title")} message={t("common.error.desc")} onRetry={load} />;
  if (!temple) return <LoadingSpinner label={t("common.loading.temple")} full />;

  const handleDownload = () => {
    saveTempleOffline({ temple, locations: temple.locations, guided_steps: temple.guided_steps });
    setOffline(true);
    setToast("✓ " + t("temple.offline.yes"));
  };
  const handleRemove = () => {
    removeTempleOffline(temple.slug);
    setOffline(false);
    setToast(t("temple.offline.remove"));
  };

  const history = C(temple, "history");
  const architecture = C(temple, "architecture_summary");
  const culture = C(temple, "cultural_significance");
  const description = C(temple, "description");

  // Dedicated heritage landing page for Meenakshi Amman Temple.
  // Other temple detail pages continue to use the original layout below.
  if (temple.slug === "meenakshi") {
    const heroImage = meenakshiHeroImage;
    const scrollToDetails = () => document.getElementById("meenakshi-details")?.scrollIntoView({ behavior: "smooth" });
    const glance = [
      { icon: Flower2, label: "Deity", value: "Goddess Meenakshi & Lord Sundareswarar" },
      { icon: Calendar, label: "Period", value: "12th Century (present structure)" },
      { icon: Landmark, label: "Architecture", value: "Dravidian" },
      { icon: ArrowUpDown, label: "Height", value: "~52 m (Gopuram)" },
      { icon: Landmark, label: "UNESCO", value: "Not Listed" },
    ];

    return (
      <main className="meenakshi-page">
        {/* First viewport: the hero ends at the scroll arrow. */}
        <section className="meenakshi-hero" aria-label="Welcome to Meenakshi Amman Temple">
          <SmartImage src={heroImage} alt={name(temple)} className="meenakshi-hero-image" showNote={false} />
          <div className="meenakshi-hero-shade" />
          <div className="meenakshi-hero-content">
            <div className="meenakshi-lotus" aria-hidden="true">❀</div>
            <p className="meenakshi-welcome">Welcome to</p>
            <h1>{name(temple)}</h1>
            <p className="meenakshi-location"><MapPin className="h-4 w-4" /> {temple.location}, {temple.state}</p>
            <Link to={`/temple/${temple.slug}/guided`} className="meenakshi-enter">
              Enter Temple <ArrowRight className="h-4 w-4" />
            </Link>
          </div>
          <button className="meenakshi-scroll" onClick={scrollToDetails} aria-label="Scroll to temple details">
            <ChevronDown className="h-6 w-6" />
          </button>
        </section>

        {/* Everything below the arrow is revealed by normal page scrolling. */}
        <div id="meenakshi-details" className="meenakshi-details">
          <section className="meenakshi-glance">
            <h2><span />At a Glance<span /></h2>
            <div className="meenakshi-facts">
              {glance.map((fact) => (
                <div className="meenakshi-fact" key={fact.label}>
                  <fact.icon aria-hidden="true" />
                  <strong>{fact.label}</strong>
                  <p>{fact.value}</p>
                </div>
              ))}
            </div>
          </section>

          <div className="meenakshi-story">
            <section className="meenakshi-story-row">
              <div className="meenakshi-story-copy">
                <h2>Overview</h2>
                <p>{description.text}</p>
                <Link to={`/temple/${temple.slug}/map`} className="meenakshi-read">Explore Temple <ArrowRight className="h-4 w-4" /></Link>
              </div>
              <SmartImage src={heroImage} alt="Meenakshi Amman Temple gopuram" className="meenakshi-story-image" showNote={false} />
            </section>

            <section className="meenakshi-story-row reverse">
              <SmartImage src={heroImage} alt="Sculptural details of Meenakshi Amman Temple" className="meenakshi-story-image" showNote={false} />
              <div className="meenakshi-story-copy">
                <h2>History</h2>
                <p>{history.text}</p>
              </div>
            </section>

            <section className="meenakshi-story-row">
              <div className="meenakshi-story-copy">
                <h2>Architecture</h2>
                <p>{architecture.text}</p>
              </div>
              <SmartImage src={heroImage} alt="Dravidian temple architecture" className="meenakshi-story-image" showNote={false} />
            </section>
          </div>

          <section className="meenakshi-timeline-wrap">
            <h2><span />Historical Timeline<span /></h2>
            <Timeline items={temple.timeline} />
          </section>

          <section className="meenakshi-gallery-wrap">
            <Gallery items={temple.gallery} templeName={name(temple)} />
          </section>

          <TempleTraditions temple={temple} />

          <section className="meenakshi-more">
            <div>
              <h2>Explore the Temple</h2>
              <p>Discover sacred spaces, find your way around the temple complex, or begin a guided visit.</p>
            </div>
            <div className="meenakshi-more-actions">
              <Link to={`/temple/${temple.slug}/map`} className="btn btn-outline"><Landmark className="h-4 w-4" /> View Map</Link>
              <Link to={`/temple/${temple.slug}/guided`} className="btn btn-primary"><Compass className="h-4 w-4" /> Guided Tour</Link>
            </div>
          </section>
          <div className="meenakshi-extra"><SacredThreads templeSlug={temple.slug} limit={3} /><Sources sources={temple.sources} /></div>
        </div>

        {toast && <div className="fade-up fixed bottom-20 left-1/2 z-50 -translate-x-1/2 rounded-xl bg-midnight px-5 py-3 text-sm font-bold text-white shadow-2xl" role="status">{toast}</div>}
      </main>
    );
  }

  const facts = [
    { icon: Calendar, label: t("temple.period"), value: C(temple, "historical_period").text },
    { icon: Flame, label: t("temple.deity"), value: C(temple, "main_deity").text },
    { icon: Landmark, label: t("temple.style"), value: C(temple, "architectural_style").text },
  ];

  return (
    <main>
      {/* ==================== HERO ==================== */}
      <section className="relative">
        <div className="relative h-[56vh] min-h-[440px] w-full overflow-hidden">
          <SmartImage src={temple.image_url} alt={name(temple)} className="h-full w-full object-cover" showNote={false} />
          <div className="absolute inset-0 bg-gradient-to-t from-midnight via-midnight/60 to-midnight/25" />
          <div className="pattern-arch absolute inset-0 opacity-40" aria-hidden="true" />
        </div>

        <div className="absolute inset-x-0 bottom-0">
          <div className="mx-auto max-w-7xl px-4 pb-8 sm:px-6">
            <button
              onClick={goBack}
              className="mb-5 inline-flex items-center gap-2 rounded-lg border border-white/25 bg-white/10 px-3 py-1.5 text-xs font-bold text-white backdrop-blur transition-colors hover:border-saffron/60 hover:text-saffron-300"
            >
              <ArrowLeft className="h-3.5 w-3.5" aria-hidden="true" />
              {t("common.back")}
            </button>

            <h1 className="font-display text-3xl font-bold text-white sm:text-5xl">{name(temple)}</h1>
            <p className="mt-2 flex items-center gap-2 text-sm font-semibold text-white/85">
              <MapPin className="h-4 w-4 text-saffron" aria-hidden="true" />
              {temple.location}, {temple.state}, {temple.country}
            </p>
            <p className="mt-3 max-w-2xl text-sm leading-relaxed text-white/85 sm:text-base">{description.text}</p>

            <div className="mt-4 flex flex-wrap gap-2">
              {temple.unesco && <span className="chip chip-gold">UNESCO World Heritage</span>}
              <span className="chip chip-light">
                {temple.locations.length} {t("temple.shrines")}
              </span>
              {offline && (
                <span className="chip !border-emerald-400/40 !bg-emerald-500/20 !text-emerald-300">
                  <CheckCircle2 className="h-3 w-3" aria-hidden="true" />
                  {t("temple.offline.yes")}
                </span>
              )}
            </div>
          </div>
        </div>
      </section>

      {/* ==================== ACTIONS + FACTS ==================== */}
      <section className="mx-auto max-w-7xl px-4 pt-6 sm:px-6">
        <div className="card flex flex-wrap items-center gap-3 p-4">
          <Link to={`/temple/${temple.slug}/guided`} className="btn btn-primary">
            <Compass className="h-4 w-4" aria-hidden="true" />
            {t("temple.guided")}
          </Link>
          <Link to={`/temple/${temple.slug}/map`} className="btn btn-dark">
            <Landmark className="h-4 w-4" aria-hidden="true" />
            {t("temple.viewMap")}
          </Link>
          {offline ? (
            <button onClick={handleRemove} className="btn btn-outline btn-sm">
              <Trash2 className="h-4 w-4 text-red-500" aria-hidden="true" />
              {t("temple.offline.remove")}
            </button>
          ) : (
            <button onClick={handleDownload} className="btn btn-outline btn-sm">
              <Download className="h-4 w-4" aria-hidden="true" />
              {t("temple.download")}
            </button>
          )}
        </div>

        <div className="mt-6 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
          {facts.map((f) => (
            <div key={f.label} className="card flex items-start gap-3 p-4">
              <span className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-saffron/12 text-saffron-600">
                <f.icon className="h-4 w-4" aria-hidden="true" />
              </span>
              <div className="min-w-0">
                <p className="text-[11px] font-extrabold tracking-wider text-midnight-700/45 uppercase">{f.label}</p>
                <p className="mt-0.5 text-sm font-bold text-midnight">{f.value}</p>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* ==================== MAIN GRID ==================== */}
      <div className="mx-auto max-w-7xl px-4 py-12 sm:px-6">
        <div>
          <div className="min-w-0 space-y-14">
            {/* interactive map */}
            <section aria-label={t("map.title")}>
              <div className="flex flex-wrap items-end justify-between gap-3">
                <div>
                  <h2 className="font-display text-2xl font-bold text-midnight sm:text-3xl">{t("map.title")}</h2>
                  <p className="mt-2 text-sm text-midnight-700/65">{t("map.subtitle")}</p>
                </div>
                <Link to={`/temple/${temple.slug}/map`} className="btn btn-outline btn-sm">
                  {t("temple.viewMap")}
                  <ArrowRight className="h-4 w-4" aria-hidden="true" />
                </Link>
              </div>
              <div className="mt-6">
                <TempleMap
                  temple={temple}
                  locations={temple.locations}
                  onExplore={(loc) => navigate(`/temple/${temple.slug}/location/${loc.id}`)}
                />
              </div>
            </section>

            {/* locations */}
            <section aria-label={t("temple.locations")}>
              <h2 className="font-display text-2xl font-bold text-midnight sm:text-3xl">{t("temple.locations")}</h2>
              <p className="mt-2 text-sm text-midnight-700/65">{t("temple.locations.sub")}</p>
              <div className="mt-6 grid gap-5 sm:grid-cols-2">
                {temple.locations.map((location) => (
                  <LocationCard key={location.id} templeSlug={temple.slug} location={location} />
                ))}
              </div>
            </section>

            {/* history */}
            <section aria-label={t("temple.history")}>
              <h2 className="font-display text-2xl font-bold text-midnight sm:text-3xl">{t("temple.history")}</h2>
              <div className="card relative mt-5 overflow-hidden p-6 sm:p-8">
                <div className="pattern-lines pointer-events-none absolute inset-0" aria-hidden="true" />
                <div className="relative">
                  <p className="leading-relaxed text-midnight-700/85">{history.text}</p>
                </div>
              </div>
            </section>

            {/* architecture */}
            <section aria-label={t("temple.architecture")}>
              <h2 className="font-display text-2xl font-bold text-midnight sm:text-3xl">{t("temple.architecture")}</h2>
              <div className="card mt-5 p-6 sm:p-8">
                <p className="leading-relaxed text-midnight-700/85">{architecture.text}</p>
              </div>
            </section>

            {/* cultural significance */}
            <section aria-label={t("temple.culture")}>
              <h2 className="font-display text-2xl font-bold text-midnight sm:text-3xl">{t("temple.culture")}</h2>
              <div className="card mt-5 p-6 sm:p-8">
                <p className="leading-relaxed text-midnight-700/85">{culture.text}</p>
              </div>
            </section>

            <TempleTraditions temple={temple} />

            <SacredThreads templeSlug={temple.slug} limit={3} />

            <Gallery items={temple.gallery} templeName={name(temple)} />
            <Timeline items={temple.timeline} />
            <Sources sources={temple.sources} />
          </div>

        </div>
      </div>

      {toast && (
        <div className="fade-up fixed bottom-20 left-1/2 z-50 -translate-x-1/2 rounded-xl bg-midnight px-5 py-3 text-sm font-bold text-white shadow-2xl lg:bottom-6" role="status">
          {toast}
        </div>
      )}
    </main>
  );
}
