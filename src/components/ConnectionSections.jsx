import React, { useEffect, useMemo, useState } from "react";
import { Link } from "react-router-dom";
import {
  ArrowRight, Award, BookOpen, CalendarDays, Crown, Flower2, GitCompareArrows,
  Landmark, MapPin, Network, Sparkles, Timer, Users, X,
} from "lucide-react";
import { compareWithAll, DIMENSIONS } from "../services/templeConnections";
import { useLanguage } from "../context/LanguageContext";
import SmartImage from "./SmartImage";
import "../connections-compare.css";

// One entry per metadata type. Order follows DIMENSIONS (strongest evidence first).
const META = {
  deity: { title: "Deity Connections", Icon: Flower2, blurb: "Temples dedicated to the same deity or related forms of the divine." },
  dynasty: { title: "Dynasty & Patron Connections", Icon: Crown, blurb: "Temples built, expanded or patronised under the same dynasties and rulers." },
  tradition: { title: "Worship Traditions", Icon: Users, blurb: "Shared religious traditions, agama systems and temple categories." },
  mythology: { title: "Mythology & Puranic Links", Icon: BookOpen, blurb: "Temples tied together by the same Puranas, sages and sacred legends." },
  architecture: { title: "Architecture Connections", Icon: Landmark, blurb: "Temples with related architectural styles, layouts and design traditions." },
  festival: { title: "Festival Connections", Icon: CalendarDays, blurb: "Temples that celebrate the same festivals through the year." },
  jatra: { title: "Jatra Connections", Icon: Network, blurb: "Temples linked through the same Jatras and processional traditions." },
  heritage: { title: "Heritage Status", Icon: Award, blurb: "Temples sharing a heritage or protected-monument designation." },
  region: { title: "Regional Connections", Icon: MapPin, blurb: "Temples in the same state, district or river landscape." },
  period: { title: "Historical Period", Icon: Timer, blurb: "Temples associated with the same historical era." },
};

const place = (t) => [t.city, t.state].filter(Boolean).join(", ");

function ConnectionCard({ anchor, row, dim, onOpen }) {
  const { name } = useLanguage();
  const { temple } = row;
  const { Icon } = META[dim.id];
  const others = row.matched.filter((d) => d.id !== dim.id).length;
  return (
    <article className="group overflow-hidden rounded-2xl border border-midnight/10 bg-white shadow-sm transition duration-300 hover:-translate-y-0.5 hover:border-saffron/40 hover:shadow-lg">
      <div className="grid grid-cols-2 gap-px bg-midnight/10">
        <Link to={`/temple/${anchor.slug}`} className="relative block h-28 overflow-hidden bg-midnight/5 sm:h-32" aria-label={`Explore ${name(anchor)}`}>
          <SmartImage src={anchor.image_url} alt={name(anchor)} className="h-full w-full object-cover transition duration-500 group-hover:scale-105" showNote={false} />
          <span className="absolute bottom-2 left-2 rounded-full bg-midnight/85 px-2 py-1 text-[10px] font-bold text-white">This temple</span>
        </Link>
        <Link to={`/temple/${temple.slug}`} className="relative block h-28 overflow-hidden bg-midnight/5 sm:h-32" aria-label={`Explore ${name(temple)}`}>
          <SmartImage src={temple.image_url} alt={name(temple)} className="h-full w-full object-cover transition duration-500 group-hover:scale-105" showNote={false} />
          <span className="absolute bottom-2 left-2 rounded-full bg-saffron-600 px-2 py-1 text-[10px] font-bold text-white">Recommended</span>
        </Link>
      </div>
      <div className="p-4 sm:p-5">
        <div className="flex items-center gap-2 text-xs font-extrabold uppercase tracking-wider text-saffron-700">
          <Icon className="h-4 w-4" aria-hidden="true" /> {dim.label}
          {others > 0 && <span className="rounded-full bg-cream px-2 py-0.5 text-[10px] normal-case tracking-normal text-midnight/60">+{others} more</span>}
        </div>
        <div className="mt-3 grid grid-cols-[minmax(0,1fr)_auto_minmax(0,1fr)] items-start gap-2">
          <div className="min-w-0">
            <Link to={`/temple/${anchor.slug}`} className="block break-words font-display text-base font-bold leading-snug text-midnight hover:text-saffron-700">{name(anchor)}</Link>
            <p className="mt-1 flex items-start gap-1 text-xs leading-relaxed text-midnight/55"><MapPin className="mt-0.5 h-3 w-3 shrink-0" />{place(anchor)}</p>
          </div>
          <GitCompareArrows className="mt-1 h-4 w-4 text-saffron-600" aria-label="Connection between temples" />
          <div className="min-w-0 text-right">
            <Link to={`/temple/${temple.slug}`} className="block break-words font-display text-base font-bold leading-snug text-midnight hover:text-saffron-700">{name(temple)}</Link>
            <p className="mt-1 flex items-start justify-end gap-1 text-xs leading-relaxed text-midnight/55"><MapPin className="mt-0.5 h-3 w-3 shrink-0" />{place(temple)}</p>
          </div>
        </div>
        <div className="mt-4 rounded-xl border border-saffron/20 bg-cream/70 p-3.5">
          <p className="text-[11px] font-extrabold uppercase tracking-wide text-midnight/60">Why it's recommended</p>
          <p className="mt-1.5 line-clamp-2 text-sm leading-relaxed text-midnight/80">{dim.label}: {dim.shared.slice(0, 3).join(", ")}</p>
          <button type="button" onClick={() => onOpen(row)} className="mt-3 inline-flex items-center gap-1.5 text-sm font-extrabold text-saffron-800 hover:text-midnight focus:outline-none focus-visible:ring-2 focus-visible:ring-saffron">
            View connection <ArrowRight className="h-4 w-4" aria-hidden="true" />
          </button>
        </div>
        <Link to={`/temple/${temple.slug}`} className="mt-3 inline-flex items-center gap-2 text-sm font-bold text-midnight hover:text-saffron-700">
          Explore recommended temple <ArrowRight className="h-4 w-4" aria-hidden="true" />
        </Link>
      </div>
    </article>
  );
}

const Chips = ({ items, tone }) => items.length
  ? <div className="tc-chips">{items.slice(0, 8).map((v) => <span key={v} className={`tc-chip ${tone}`}>{v}</span>)}</div>
  : <span className="tc-none">—</span>;

function ConnectionDialog({ anchor, row, onClose, onCompare }) {
  const { name } = useLanguage();
  const { temple } = row;
  return (
    <div className="fixed inset-0 z-[100] flex items-center justify-center bg-midnight/65 p-4 backdrop-blur-sm" role="presentation" onMouseDown={(e) => { if (e.target === e.currentTarget) onClose(); }}>
      <section role="dialog" aria-modal="true" aria-labelledby="cs-dialog-title" className="max-h-[85vh] w-full max-w-2xl overflow-y-auto rounded-2xl bg-cream shadow-2xl">
        <div className="sticky top-0 z-10 flex items-start justify-between gap-4 border-b border-midnight/10 bg-cream/95 p-5 backdrop-blur">
          <div>
            <p className="text-xs font-extrabold uppercase tracking-wider text-saffron-800">Temple connection</p>
            <h3 id="cs-dialog-title" className="mt-1 font-display text-xl font-bold text-midnight sm:text-2xl">{name(anchor)} <span className="text-saffron-700">↔</span> {name(temple)}</h3>
          </div>
          <button type="button" onClick={onClose} aria-label="Close connection details" className="rounded-full border border-midnight/15 p-2 text-midnight hover:bg-white"><X className="h-5 w-5" /></button>
        </div>
        <div className="space-y-3 p-5">
          {row.matched.map((d) => {
            const { Icon } = META[d.id];
            return (
              <article key={d.id} className="rounded-xl border border-midnight/10 bg-white p-4">
                <h4 className="flex items-center gap-2 font-bold text-midnight"><Icon className="h-4 w-4 text-saffron-700" />{d.label}</h4>
                <p className="mt-2 text-xs font-bold uppercase tracking-wide text-midnight/50">Shared by both</p>
                <Chips items={d.shared} tone="shared" />
                {(d.only_a.length > 0 || d.only_b.length > 0) && (
                  <div className="mt-3 grid gap-3 sm:grid-cols-2">
                    <div><p className="mb-1 text-xs font-bold text-midnight/50">Only {name(anchor)}</p><Chips items={d.only_a} tone="a" /></div>
                    <div><p className="mb-1 text-xs font-bold text-midnight/50">Only {name(temple)}</p><Chips items={d.only_b} tone="b" /></div>
                  </div>
                )}
              </article>
            );
          })}
          <p className="text-xs leading-relaxed text-midnight/50">Based on recorded catalogue metadata. A shared attribute is a discovery aid and does not prove direct historical influence.</p>
          <div className="flex flex-wrap gap-2">
            {onCompare && <button type="button" onClick={() => { onCompare(temple.slug); onClose(); }} className="flex-1 rounded-xl border border-midnight/15 bg-white px-4 py-3 font-bold text-midnight hover:border-saffron">Full side-by-side comparison</button>}
            <button type="button" onClick={onClose} className="flex-1 rounded-xl bg-midnight px-4 py-3 font-bold text-white hover:bg-midnight/90">Close details</button>
          </div>
        </div>
      </section>
    </div>
  );
}

/** One section per metadata type, each listing the temples that match the anchor on it. */
export function ConnectionSections({ data, layout = "stack", perSection = 3, onCompare }) {
  const [open, setOpen] = useState(null);
  const [expanded, setExpanded] = useState({});
  const sections = useMemo(() => DIMENSIONS.map((dim) => {
    const rows = data.rows
      .map((row) => ({ row, d: row.dimensions.find((x) => x.id === dim.id) }))
      .filter(({ d }) => d && d.shared.length)
      .sort((a, b) => b.d.shared.length - a.d.shared.length || b.row.score - a.row.score);
    return { dim, rows };
  }).filter((s) => s.rows.length), [data]);

  if (!sections.length) {
    return <p className="cs-empty">No recorded metadata connects this temple to the others yet.</p>;
  }
  return (
    <div className="cs-wrap">
      {sections.map(({ dim, rows }) => {
        const { Icon, title, blurb } = META[dim.id];
        const all = expanded[dim.id];
        const shown = all ? rows : rows.slice(0, perSection);
        return (
          <section key={dim.id} className={`cs-section ${layout}`}>
            <div className="cs-intro">
              <Icon />
              <h3>{title}</h3>
              <p>{blurb}</p>
              {rows.length > perSection && (
                <button type="button" className="cs-seeall" onClick={() => setExpanded((e) => ({ ...e, [dim.id]: !all }))}>
                  {all ? "Show less" : `See all (${rows.length})`} <ArrowRight size={15} />
                </button>
              )}
            </div>
            <div className="cs-cards">
              {shown.map(({ row, d }) => (
                <ConnectionCard key={row.temple.id} anchor={data.a} row={row} dim={d} onOpen={setOpen} />
              ))}
            </div>
          </section>
        );
      })}
      {open && <ConnectionDialog anchor={data.a} row={open} onClose={() => setOpen(null)} onCompare={onCompare} />}
    </div>
  );
}

/** Self-contained block for a temple page: loads data, renders header + sections. */
export function RelatedByMetadata({ slug }) {
  const [data, setData] = useState(null);
  useEffect(() => {
    let live = true;
    compareWithAll(slug).then((r) => live && setData(r)).catch(() => live && setData(null));
    return () => { live = false; };
  }, [slug]);
  if (!data || !data.rows.some((r) => r.score > 0)) return null;
  return (
    <section aria-labelledby="temple-threads-title">
      <div className="flex flex-wrap items-end justify-between gap-4">
        <div>
          <span className="chip chip-gold"><Sparkles className="h-3 w-3" aria-hidden="true" /> Continue your discovery</span>
          <h2 id="temple-threads-title" className="mt-3 font-display text-2xl font-bold text-midnight sm:text-3xl">Related temples, with context</h2>
          <p className="mt-2 max-w-2xl text-sm leading-relaxed text-midnight-700/65 sm:text-base">Grouped by what connects them. Select “View connection” for the full explanation.</p>
        </div>
        <Link to={`/connections?a=${slug}`} className="inline-flex items-center gap-2 rounded-xl border border-midnight/15 bg-white px-4 py-2.5 text-sm font-bold text-midnight transition hover:border-saffron hover:text-saffron-700">
          All connections <ArrowRight className="h-4 w-4" aria-hidden="true" />
        </Link>
      </div>
      <div className="mt-6"><ConnectionSections data={data} /></div>
      <p className="mt-4 text-xs leading-relaxed text-midnight/45">Connections are discovery suggestions based on recorded attributes; shared styles alone do not prove direct historical influence.</p>
    </section>
  );
}
