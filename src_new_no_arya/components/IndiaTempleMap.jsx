import React, { useEffect, useMemo, useRef, useState } from "react";
import L from "leaflet";
import "leaflet/dist/leaflet.css";
import { supabase } from "../lib/supabase";

// Loads every published temple that has coordinates (pages through 1000-row limit).
async function fetchAllTemples() {
  if (!supabase) return [];
  const all = [];
  const size = 1000;
  for (let from = 0; ; from += size) {
    const { data, error } = await supabase
      .from("temples")
      .select("slug,name,city,state,latitude,longitude,image_url,main_deity")
      .eq("published", true)
      .not("latitude", "is", null)
      .not("longitude", "is", null)
      .order("name")
      .range(from, from + size - 1);
    if (error) throw error;
    all.push(...(data || []));
    if (!data || data.length < size) break;
  }
  return all;
}

function popupFor(t) {
  const box = document.createElement("div");
  box.style.minWidth = "180px";
  if (t.image_url) {
    const img = document.createElement("img");
    img.src = t.image_url;
    img.alt = t.name;
    img.style.cssText = "width:100%;height:90px;object-fit:cover;border-radius:8px;margin-bottom:6px";
    box.appendChild(img);
  }
  const title = document.createElement("strong");
  title.textContent = t.name;
  box.appendChild(title);
  const place = document.createElement("div");
  place.textContent = [t.city, t.state].filter(Boolean).join(", ");
  place.style.cssText = "font-size:12px;opacity:.7;margin:2px 0 6px";
  box.appendChild(place);
  const link = document.createElement("a");
  link.href = `#/temple/${t.slug}`;
  link.textContent = "Open temple page →";
  link.style.cssText = "font-weight:700;font-size:13px";
  box.appendChild(link);
  return box;
}

export default function IndiaTempleMap() {
  const elRef = useRef(null);
  const mapRef = useRef(null);
  const layerRef = useRef(null);
  const [temples, setTemples] = useState([]);
  const [status, setStatus] = useState("loading");
  const [query, setQuery] = useState("");
  const [stateFilter, setStateFilter] = useState("");

  // Load data once.
  useEffect(() => {
    let active = true;
    fetchAllTemples()
      .then((rows) => {
        if (!active) return;
        setTemples(rows);
        setStatus("ready");
      })
      .catch(() => active && setStatus("error"));
    return () => {
      active = false;
    };
  }, []);

  // Create the map once.
  useEffect(() => {
    if (!elRef.current || mapRef.current) return;
    const map = L.map(elRef.current, { center: [22.5, 79], zoom: 5, minZoom: 4 });
    L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
      maxZoom: 18,
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    }).addTo(map);
    layerRef.current = L.layerGroup().addTo(map);
    mapRef.current = map;
    return () => {
      map.remove();
      mapRef.current = null;
    };
  }, []);

  const states = useMemo(
    () => [...new Set(temples.map((t) => t.state).filter(Boolean))].sort(),
    [temples]
  );

  const visible = useMemo(() => {
    const q = query.trim().toLowerCase();
    return temples.filter(
      (t) =>
        (!stateFilter || t.state === stateFilter) &&
        (!q ||
          t.name.toLowerCase().includes(q) ||
          (t.city || "").toLowerCase().includes(q) ||
          (t.main_deity || "").toLowerCase().includes(q))
    );
  }, [temples, query, stateFilter]);

  // Redraw pins whenever the filter changes.
  useEffect(() => {
    const map = mapRef.current;
    const layer = layerRef.current;
    if (!map || !layer) return;
    layer.clearLayers();
    const pts = [];
    visible.forEach((t) => {
      const ll = [t.latitude, t.longitude];
      pts.push(ll);
      L.circleMarker(ll, {
        radius: 7,
        color: "#b45309",
        weight: 2,
        fillColor: "#f59e0b",
        fillOpacity: 0.85,
      })
        .bindTooltip(t.name)
        .bindPopup(() => popupFor(t))
        .addTo(layer);
    });
    if ((query || stateFilter) && pts.length) {
      map.fitBounds(L.latLngBounds(pts).pad(0.2), { maxZoom: 11 });
    }
  }, [visible, query, stateFilter]);

  return (
    <div className="mx-auto w-full max-w-6xl px-4 py-6">
      <div className="mb-3 flex flex-wrap items-center gap-2">
        <input
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          placeholder="Search temple, city or deity"
          className="min-w-[220px] flex-1 rounded-xl border border-black/15 bg-white px-3 py-2 text-sm"
        />
        <select
          value={stateFilter}
          onChange={(e) => setStateFilter(e.target.value)}
          className="rounded-xl border border-black/15 bg-white px-3 py-2 text-sm"
        >
          <option value="">All states</option>
          {states.map((s) => (
            <option key={s} value={s}>
              {s}
            </option>
          ))}
        </select>
        <span className="text-sm font-semibold opacity-70">
          {status === "loading" && "Loading temples…"}
          {status === "error" && "Could not load temples"}
          {status === "ready" && `${visible.length} of ${temples.length} temples`}
        </span>
      </div>
      <div
        ref={elRef}
        style={{ height: "70vh", minHeight: 420 }}
        className="w-full overflow-hidden rounded-2xl border border-black/15"
      />
    </div>
  );
}
