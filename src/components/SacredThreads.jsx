import React, { useEffect, useMemo, useState } from "react";
import { Link } from "react-router-dom";
import { ArrowRight, BookOpen, Landmark, Users, Sparkles, MapPin, CalendarDays } from "lucide-react";
import { getTempleConnections } from "../services/templeConnections";
import { useLanguage } from "../context/LanguageContext";
import SmartImage from "./SmartImage";

const TYPE_META = {
  deity: { Icon: Users, text: (d) => `Dedicated to ${d}` },
  architecture: { Icon: Landmark, text: (d) => `Similar architecture: ${d}` },
  dynasty: { Icon: Landmark, text: (d) => `Linked to the ${d} dynasty` },
  story: { Icon: BookOpen, text: (d) => `Shared tradition: ${d}` },
  festival: { Icon: CalendarDays, text: (d) => `Shared festival: ${d}` },
  jatra: { Icon: CalendarDays, text: (d) => `Shared jatra: ${d}` },
  period: { Icon: BookOpen, text: (d) => `Same era: ${d}` },
  region: { Icon: MapPin, text: (d) => `Same region: ${d}` },
};

const reasonLine = (reason) => {
  const meta = TYPE_META[reason.type] || TYPE_META.story;
  return { Icon: meta.Icon, text: reason.detail ? meta.text(reason.detail) : "Related cultural theme" };
};

/**
 * Related temples. Each card shows ONE temple (the suggested one) and a
 * short, plain reason why it is related. No side-by-side comparison.
 */
export default function SacredThreads({ templeSlug, limit = 3, variant = "related" }) {
  const { name } = useLanguage();
  const [groups, setGroups] = useState([]);
  const [loaded, setLoaded] = useState(false);

  useEffect(() => {
    let active = true;
    getTempleConnections()
      .then((data) => { if (active) setGroups(Array.isArray(data) ? data : []); })
      .catch(() => { if (active) setGroups([]); })
      .finally(() => { if (active) setLoaded(true); });
    return () => { active = false; };
  }, []);

  const cards = useMemo(() => {
    if (templeSlug) {
      const group = groups.find((item) => item.temple.slug === templeSlug);
      return (group?.connections || []).slice(0, limit).map((c) => ({
        temple: c.temple, reasons: c.reasons, from: group.temple, score: c.score,
      }));
    }
    const seen = new Set();
    return groups
      .flatMap((group) => group.connections.map((c) => {
        const key = [group.temple.id, c.temple.id].sort().join("::");
        if (seen.has(key)) return null;
        seen.add(key);
        return { temple: c.temple, reasons: c.reasons, from: group.temple, score: c.score };
      }).filter(Boolean))
      .sort((a, b) => b.score - a.score)
      .slice(0, limit);
  }, [groups, templeSlug, limit]);

  if (!loaded || !cards.length) return null;
  const discovery = variant === "discovery";
  const titleId = discovery ? "sacred-threads-title" : "temple-threads-title";

  return (
    <section className={discovery ? "relative overflow-hidden bg-cream py-16 sm:py-20" : ""} aria-labelledby={titleId}>
      <div className={discovery ? "relative mx-auto max-w-7xl px-4 sm:px-6" : ""}>
        <div className="flex flex-wrap items-end justify-between gap-4">
          <div>
            <span className="chip chip-gold"><Sparkles className="h-3 w-3" aria-hidden="true" /> {templeSlug ? "Keep exploring" : "Connected temples"}</span>
            <h2 id={titleId} className="mt-3 font-display text-2xl font-bold text-midnight sm:text-3xl">
              {templeSlug ? "Related temples" : "Temples connected by stories"}
            </h2>
          </div>
          <Link to="/connections" className="inline-flex items-center gap-2 rounded-xl border border-midnight/15 bg-white px-4 py-2.5 text-sm font-bold text-midnight transition hover:border-saffron hover:text-saffron-700">
            All connections <ArrowRight className="h-4 w-4" aria-hidden="true" />
          </Link>
        </div>

        <div className="mt-6 grid gap-5 sm:grid-cols-2 xl:grid-cols-3">
          {cards.map(({ temple, reasons, from }) => {
            const lines = reasons.slice(0, 2).map(reasonLine);
            return (
              <Link
                key={`${from.id}-${temple.id}`}
                to={`/temple/${temple.slug}`}
                className="group overflow-hidden rounded-2xl border border-midnight/10 bg-white shadow-sm transition duration-300 hover:-translate-y-0.5 hover:border-saffron/40 hover:shadow-lg"
              >
                <div className="relative h-40 overflow-hidden bg-midnight/5">
                  <SmartImage src={temple.image_url} alt={name(temple)} className="h-full w-full object-cover transition duration-500 group-hover:scale-105" showNote={false} />
                </div>
                <div className="p-4">
                  <h3 className="font-display text-lg font-bold leading-snug text-midnight group-hover:text-saffron-700">{name(temple)}</h3>
                  <p className="mt-1 flex items-center gap-1 text-xs text-midnight/55"><MapPin className="h-3 w-3 shrink-0" aria-hidden="true" />{[temple.city, temple.state].filter(Boolean).join(", ")}</p>
                  <ul className="mt-3 space-y-1.5">
                    {lines.map(({ Icon, text }) => (
                      <li key={text} className="flex items-start gap-2 text-sm leading-snug text-midnight/75">
                        <Icon className="mt-0.5 h-4 w-4 shrink-0 text-saffron-700" aria-hidden="true" />{text}
                      </li>
                    ))}
                  </ul>
                  {!templeSlug && <p className="mt-3 text-xs text-midnight/50">Connected with {name(from)}</p>}
                </div>
              </Link>
            );
          })}
        </div>
      </div>
    </section>
  );
}
