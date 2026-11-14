import React from "react";
import { useEffect, useMemo, useState } from "react";
import { Link } from "react-router-dom";
import {
  ArrowRight, BookOpen, CalendarDays, Crown, Landmark, Layers3, Link2,
  MapPin, Search, Sparkles, Timer, Network, Scale, Flower2, ChevronRight,
} from "lucide-react";
import { getTempleConnections } from "../services/templeConnections";
import { useLanguage } from "../context/LanguageContext";
import LoadingSpinner from "../components/LoadingSpinner";
import ErrorState from "../components/ErrorState";
import SmartImage from "../components/SmartImage";

const META_TABS = [
  { id: "dynasty", label: "Dynasty", icon: Crown },
  { id: "period", label: "Period", icon: Timer },
  { id: "region", label: "Region", icon: MapPin },
  { id: "materials", label: "Materials", icon: Layers3 },
  { id: "legends", label: "Legends", icon: BookOpen },
];
const FILTERS = [
  { id: "all", label: "All Connections", icon: Layers3 },
  { id: "deity", label: "Deity", icon: Flower2 },
  { id: "story", label: "Festivals & Traditions", icon: CalendarDays },
  { id: "architecture", label: "Architecture", icon: Landmark },
];

const dynastyOf = (temple) => {
  const text = `${temple.historical_period || ""} ${temple.architectural_style || ""}`;
  return ["Chola", "Nayak", "Eastern Ganga", "Vijayanagara", "Pallava"].find((x) => text.toLowerCase().includes(x.toLowerCase())) || "Dynasty not specified";
};
const periodOf = (temple) => {
  const match = String(temple.historical_period || "").match(/(?:c\.\s*)?(\d{1,2}(?:st|nd|rd|th)?\s+century|\d{3,4}\s*CE)/i);
  return match?.[1] || temple.historical_period || "Period not specified";
};
const metaValue = (temple, tab) => {
  if (tab === "dynasty") return dynastyOf(temple);
  if (tab === "period") return periodOf(temple);
  if (tab === "region") return temple.state || "Region not specified";
  if (tab === "materials") return temple.materials || temple.construction_material || "Not recorded";
  return temple.cultural_significance || "Tradition details are being curated.";
};

function TempleMiniCard({ temple, reason, name }) {
  return <article className="connection-mini-card">
    <Link to={`/temple/${temple.slug}`} className="connection-mini-image"><SmartImage src={temple.image_url} alt={name(temple)} className="h-full w-full object-cover" showNote={false}/></Link>
    <div className="connection-mini-body">
      <h3><Link to={`/temple/${temple.slug}`}>{name(temple)}</Link></h3>
      <p><MapPin size={13}/>{temple.state}</p>
      {reason && <span>{reason}</span>}
    </div>
  </article>;
}

export default function Connections() {
  const { name } = useLanguage();
  const [groups, setGroups] = useState(null);
  const [error, setError] = useState(false);
  const [query, setQuery] = useState("");
  const [filter, setFilter] = useState("all");
  const [selectedMeta, setSelectedMeta] = useState("dynasty");
  const [selectedTemple, setSelectedTemple] = useState("all");
  const load = () => { setError(false); getTempleConnections().then(setGroups).catch(() => setError(true)); };
  useEffect(() => { load(); }, []);

  const filteredGroups = useMemo(() => (groups || []).filter(({ temple, connections }) => {
    if (selectedTemple !== "all" && temple.id !== selectedTemple) return false;
    const q = query.trim().toLowerCase();
    return (!q || `${temple.name} ${temple.city} ${temple.main_deity} ${temple.architectural_style}`.toLowerCase().includes(q)) &&
      connections.some((c) => filter === "all" || c.reasons.some((r) => r.type === filter));
  }).map((group) => ({ ...group, connections: group.connections.filter((c) =>
    (filter === "all" || c.reasons.some((r) => r.type === filter)) &&
    (!query.trim() || `${c.temple.name} ${c.temple.city} ${c.temple.main_deity} ${c.temple.architectural_style} ${c.reasons.map((r) => r.detail).join(" ")}`.toLowerCase().includes(query.trim().toLowerCase()))
  ) })), [groups, query, filter, selectedTemple]);

  const edges = useMemo(() => {
    const seen = new Set();
    return filteredGroups.flatMap(({ temple, connections }) => connections.map((item) => ({ from: temple, ...item }))).filter((edge) => {
      const key = [edge.from.id, edge.temple.id].sort().join("-");
      if (seen.has(key)) return false;
      seen.add(key); return true;
    });
  }, [filteredGroups]);
  const selectedTempleData = (filteredGroups || []).find((g) => g.temple.id === selectedTemple)?.temple || (filteredGroups || [])[0]?.temple;
  const selectedConnections = selectedTempleData ? edges.filter((e) => e.from.id === selectedTempleData.id || e.temple.id === selectedTempleData.id) : [];
  const metaGroups = useMemo(() => {
    const temples = selectedTemple === "all"
      ? (filteredGroups || []).map((g) => g.temple)
      : [selectedTempleData, ...selectedConnections.map((e) => e.from.id === selectedTempleData?.id ? e.temple : e.from)].filter(Boolean);
    const grouped = new Map();
    temples.forEach((temple) => {
      const value = metaValue(temple, selectedMeta);
      const key = selectedMeta === "legends" ? "Cultural heritage" : value;
      if (!grouped.has(key)) grouped.set(key, []);
      grouped.get(key).push(temple);
    });
    return [...grouped.entries()].sort((a, b) => b[1].length - a[1].length);
  }, [filteredGroups, selectedMeta, selectedTemple, selectedTempleData, selectedConnections]);
  const compareTemples = selectedTempleData ? [selectedTempleData, ...selectedConnections.slice(0, 2).map((e) => e.from.id === selectedTempleData.id ? e.temple : e.from)] : [];

  if (error) return <div className="mx-auto max-w-7xl px-4 py-12"><ErrorState title="Connections could not load" message="Please check your connection and try again." onRetry={load}/></div>;
  if (!groups) return <LoadingSpinner label="Mapping sacred connections…" full/>;

  const visibleEdges = filteredGroups.flatMap(({ temple, connections }) => connections.map((item) => ({ from: temple, ...item })));
  const deityEdges = visibleEdges.filter((e) => e.reasons.some((r) => r.type === "deity"));
  const storyEdges = visibleEdges.filter((e) => e.reasons.some((r) => r.type === "story"));
  const architectureEdges = visibleEdges.filter((e) => e.reasons.some((r) => r.type === "architecture"));
  const renderRow = (title, subtitle, Icon, list, type) => <section className="connection-category" key={type}>
    <div className="connection-category-intro"><Icon/><h2>{title}</h2><p>{subtitle}</p><button onClick={() => setFilter(type)} className="connection-see-all">See All <ArrowRight size={15}/></button></div>
    <div className="connection-category-cards">{list.slice(0, 3).map((edge) => {
      const other = edge.temple;
      const reason = edge.reasons.find((r) => r.type === type)?.detail || edge.reasons[0]?.detail;
      return <TempleMiniCard key={`${edge.from.id}-${other.id}-${type}`} temple={other} reason={reason} name={name}/>;
    })}{!list.length && <p className="connection-empty">No recorded connections in this category yet.</p>}</div>
    <button className="connection-row-next" aria-label={`Show ${title}`} onClick={() => setFilter(type)}><ChevronRight/></button>
  </section>;

  return <main className="connections-page">
    <section className="connections-hero">
      <div className="connections-hero-art" aria-hidden="true"/>
      <div className="connections-hero-inner"><div className="connections-ornament"><span/><Flower2/><span/></div>
        <h1>Temple Connections</h1>
        <p>Discover meaningful connections between India's temples<br className="hidden sm:block"/> through their shared attributes and heritage.</p>
      </div>
    </section>

    <div className="connections-toolbar-wrap">
      <nav className="connections-filterbar" aria-label="Connection categories">{FILTERS.map(({id,label,icon:Icon})=><button key={id} onClick={()=>setFilter(id)} aria-pressed={filter===id} className={filter===id?"active":""}><Icon size={17}/>{label}</button>)}</nav>
      <div className="connections-search-row"><label className="connections-search"><Search size={17}/><input value={query} onChange={(e)=>setQuery(e.target.value)} placeholder="Search temples, deities, regions…" aria-label="Search temples and connections"/></label>
        <select value={selectedTemple} onChange={(e)=>setSelectedTemple(e.target.value)} aria-label="Choose a temple"><option value="all">All temples</option>{groups.map(({temple})=><option key={temple.id} value={temple.id}>{name(temple)}</option>)}</select>
      </div>
    </div>

    <div className="connections-content">
      {filter === "all" || filter === "deity" ? renderRow("Deity Connections","Temples dedicated to the same deity or related forms of the divine.",Flower2,deityEdges,"deity") : null}
      {filter === "all" || filter === "story" ? renderRow("Festivals & Traditions","Shared stories, living worship and cultural traditions across temples.",CalendarDays,storyEdges,"story") : null}
      {filter === "all" || filter === "architecture" ? renderRow("Architecture Connections","Temples with related architectural styles, layouts and design traditions.",Landmark,architectureEdges,"architecture") : null}

      <section className="connection-metadata">
        <div className="connection-meta-heading"><Link2/><div><h2>Other Metadata Connections</h2><p>Explore deeper relationships between temples based on recorded historical and cultural attributes.</p></div></div>
        <div className="connection-meta-tabs">{META_TABS.map(({id,label,icon:Icon})=><button key={id} onClick={()=>setSelectedMeta(id)} className={selectedMeta===id?"active":""}><Icon size={18}/>{label}</button>)}</div>
        <div className="connection-meta-body"><div className="connection-meta-summary"><span className="connection-meta-icon">{React.createElement(META_TABS.find(t=>t.id===selectedMeta).icon)}</span><h3>{META_TABS.find(t=>t.id===selectedMeta).label} Connection</h3><p>Compare temples that share a recorded {META_TABS.find(t=>t.id===selectedMeta).label.toLowerCase()} or cultural attribute.</p><div className="connection-meta-groups">{metaGroups.slice(0,4).map(([value,temples])=><div key={value}><strong>{value}</strong><span>{temples.map((t)=>t.name).join(" · ")}</span></div>)}</div></div>
          <div className="connection-meta-results"><h3>Temple groups by {META_TABS.find(t=>t.id===selectedMeta).label.toLowerCase()}</h3>{metaGroups.map(([value,temples])=><div className="connection-meta-group" key={value}><div><strong>{value}</strong><small>{temples.length} {temples.length===1?"temple":"temples"}</small></div><div className="connection-meta-temples">{temples.map((temple)=><Link key={temple.id} to={`/temple/${temple.slug}`}>{name(temple)} <ArrowRight size={12}/></Link>)}</div></div>)}</div>
        </div>
      </section>

      <div className="connection-bottom-grid"><section className="connection-network"><h2><Network/> Connection Network</h2>{selectedTempleData ? <><div className="connection-network-center"><Landmark/><strong>{name(selectedTempleData)}</strong></div><div className="connection-network-links">{selectedConnections.slice(0,6).map((edge)=><Link key={`${edge.from.id}-${edge.temple.id}`} to={`/temple/${(edge.from.id===selectedTempleData.id?edge.temple:edge.from).slug}`}><span>{edge.reasons[0]?.type === "deity" ? <Flower2/> : edge.reasons[0]?.type === "architecture" ? <Landmark/> : <BookOpen/>}</span><strong>{name(edge.from.id===selectedTempleData.id?edge.temple:edge.from)}</strong><small>{edge.reasons.map(r=>r.label).join(" · ")}</small></Link>)}</div></> : <p>No connection data available.</p>}</section>
        <section className="connection-comparison"><h2><Scale/> Comparison Summary</h2><div className="connection-table-scroll"><table><thead><tr><th>Attribute</th>{compareTemples.map((t)=><th key={t.id}>{name(t)}</th>)}</tr></thead><tbody>
          {[ ["Deity",(t)=>t.main_deity], ["Dynasty",dynastyOf], ["Period",(t)=>t.historical_period], ["Architecture",(t)=>t.architectural_style], ["Region",(t)=>t.state], ["UNESCO",(t)=>t.unesco?"Yes":"Not listed"] ].map(([label,get])=><tr key={label}><th>{label}</th>{compareTemples.map((t)=><td key={t.id}>{get(t)}</td>)}</tr>)}
        </tbody></table></div></section></div>
      <p className="connections-editorial-note">Connections are based on the catalogue's recorded deity, architectural style, historical period and curated tradition themes. Similarity is a discovery aid; it does not imply that every temple shares the same origin or story.</p>
    </div>
  </main>;
}
