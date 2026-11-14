import React from "react";
import { useEffect, useState } from "react";
import { Link, useSearchParams } from "react-router-dom";
import { ArrowLeftRight, ArrowRight, GitBranch, MapPin, Sparkles } from "lucide-react";
import { compareTemples, compareWithAll } from "../services/templeConnections";
import { useLanguage } from "../context/LanguageContext";
import SmartImage from "./SmartImage";
import { ConnectionSections } from "./ConnectionSections";
import "../connections-compare.css";

const STRENGTH = {
  strong: "Strong connection",
  moderate: "Moderate connection",
  light: "Light connection",
  none: "No recorded connection",
};

function TempleHead({ temple, name }) {
  return (
    <Link to={`/temple/${temple.slug}`} className="tc-temple">
      <div className="tc-temple-img">
        <SmartImage src={temple.image_url} alt={name(temple)} className="h-full w-full object-cover" showNote={false} />
      </div>
      <h3>{name(temple)}</h3>
      <p><MapPin size={13} />{[temple.city, temple.state].filter(Boolean).join(", ")}</p>
    </Link>
  );
}

const Chips = ({ items, tone }) => items.length
  ? <div className="tc-chips">{items.slice(0, 6).map((v) => <span key={v} className={`tc-chip ${tone}`}>{v}</span>)}{items.length > 6 && <span className="tc-chip more">+{items.length - 6}</span>}</div>
  : <span className="tc-none">—</span>;

export default function TempleComparePanel({ temples }) {
  const { name } = useLanguage();
  const [params, setParams] = useSearchParams();
  const slugA = params.get("a") || "";
  const slugB = params.get("b") || "";
  const tA = temples.find((t) => t.slug === slugA);
  const tB = temples.find((t) => t.slug === slugB);
  const [result, setResult] = useState(null);
  const [all, setAll] = useState(null);
  const [busy, setBusy] = useState(false);
  const anchor = tA || tB; // one temple is enough: compare it with everything else

  const set = (key, value) => {
    const next = new URLSearchParams(params);
    if (value) next.set(key, value); else next.delete(key);
    setParams(next, { replace: true });
  };
  const swap = () => {
    const next = new URLSearchParams(params);
    if (slugB) next.set("a", slugB); else next.delete("a");
    if (slugA) next.set("b", slugA); else next.delete("b");
    setParams(next, { replace: true });
  };

  useEffect(() => {
    let live = true;
    if (!tA || !tB || tA.id === tB.id) { setResult(null); return; }
    setBusy(true);
    compareTemples(tA.id, tB.id)
      .then((r) => live && setResult(r))
      .finally(() => live && setBusy(false));
    return () => { live = false; };
  }, [tA?.id, tB?.id]);

  useEffect(() => {
    let live = true;
    if (!anchor || (tA && tB)) { setAll(null); return; }
    setBusy(true);
    compareWithAll(anchor.id)
      .then((r) => live && setAll(r))
      .finally(() => live && setBusy(false));
    return () => { live = false; };
  }, [anchor?.id, !!(tA && tB)]);

  const pickPair = (slug) => {
    const next = new URLSearchParams(params);
    next.set("a", anchor.slug); next.set("b", slug);
    setParams(next, { replace: true });
  };

  const options = (exclude) => temples.filter((t) => t.slug !== exclude);
  const shownDims = result ? result.dimensions.filter((d) => d.has_data) : [];

  return (
    <section className="tc-panel" aria-labelledby="tc-title">
      <div className="tc-heading">
        <GitBranch />
        <div>
          <h2 id="tc-title">Temple Connection Finder</h2>
          <p>Pick a temple to see how it connects to every other temple, or choose a second one for a detailed side-by-side. Based on recorded deity, dynasty, tradition, architecture, festival and heritage metadata.</p>
        </div>
      </div>

      <div className="tc-pickers">
        <select value={slugA} onChange={(e) => set("a", e.target.value)} aria-label="First temple">
          <option value="">Choose a temple…</option>
          {options(slugB).map((t) => <option key={t.id} value={t.slug}>{name(t)}</option>)}
        </select>
        <button type="button" onClick={swap} className="tc-swap" aria-label="Swap temples" disabled={!slugA && !slugB}><ArrowLeftRight size={18} /></button>
        <select value={slugB} onChange={(e) => set("b", e.target.value)} aria-label="Second temple">
          <option value="">Compare with all other temples</option>
          {options(slugA).map((t) => <option key={t.id} value={t.slug}>{name(t)}</option>)}
        </select>
      </div>

      {!anchor ? (
        <p className="tc-hint"><Sparkles size={15} /> Select a temple above to see its connections with all other temples.</p>
      ) : !(tA && tB) ? (
        busy && !all ? <p className="tc-hint">Tracing connections…</p> : all && (
          <div className="tc-result">
            <div className="tc-all-head">
              <TempleHead temple={all.a} name={name} />
              <p className="tc-summary">
                {all.rows.filter((r) => r.score > 0).length} of {all.rows.length} other temples share recorded metadata with {name(all.a)}. Browse them by connection type below, or pick a second temple above for a side-by-side.
              </p>
            </div>
            <ConnectionSections data={all} layout="side" onCompare={pickPair} />
            <div className="mt-4" />
            <p className="tc-note">Built only from recorded catalogue metadata. A shared attribute is a discovery aid and does not imply a shared origin or story.</p>
          </div>
        )
      ) : busy && !result ? (
        <p className="tc-hint">Tracing connections…</p>
      ) : result && (
        <div className="tc-result">
          <div className="tc-hero">
            <TempleHead temple={result.a} name={name} />
            <div className={`tc-badge ${result.strength}`}>
              <strong>{STRENGTH[result.strength]}</strong>
              <div className="tc-meter" aria-hidden="true"><span style={{ width: `${Math.min(100, result.score * 6)}%` }} /></div>
              <small>{result.dimensions.filter((d) => d.shared.length).length} of {result.dimensions.length} metadata categories match</small>
            </div>
            <TempleHead temple={result.b} name={name} />
          </div>

          <p className="tc-summary">{result.summary}</p>

          <div className="tc-table-wrap">
            <table className="tc-table">
              <thead>
                <tr>
                  <th>Category</th>
                  <th>Shared by both</th>
                  <th>Only {name(result.a)}</th>
                  <th>Only {name(result.b)}</th>
                </tr>
              </thead>
              <tbody>
                {shownDims.map((d) => (
                  <tr key={d.id} className={d.shared.length ? "hit" : ""}>
                    <th scope="row">{d.label}</th>
                    <td><Chips items={d.shared} tone="shared" /></td>
                    <td><Chips items={d.only_a} tone="a" /></td>
                    <td><Chips items={d.only_b} tone="b" /></td>
                  </tr>
                ))}
                {!shownDims.length && <tr><td colSpan={4} className="tc-none">No metadata has been recorded for these temples yet.</td></tr>}
              </tbody>
            </table>
          </div>

          {result.bridges.length > 0 && (
            <div className="tc-bridges">
              <h3>{result.score > 0 ? "Also connected through" : "Indirect paths"}</h3>
              <div className="tc-bridge-list">
                {result.bridges.map(({ temple, withA, withB }) => (
                  <Link key={temple.id} to={`/temple/${temple.slug}`} className="tc-bridge">
                    <strong>{name(temple)}</strong>
                    <small>
                      {name(result.a)} <ArrowRight size={11} /> {withA?.label.toLowerCase()} ({withA?.shared[0]})
                      <br />
                      {name(result.b)} <ArrowRight size={11} /> {withB?.label.toLowerCase()} ({withB?.shared[0]})
                    </small>
                  </Link>
                ))}
              </div>
            </div>
          )}

          <p className="tc-note">Built only from recorded catalogue metadata. A shared attribute is a discovery aid and does not imply a shared origin or story.</p>
        </div>
      )}
    </section>
  );
}
