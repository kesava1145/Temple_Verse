import React, { useEffect, useRef } from "react";
import L from "leaflet";
import "leaflet/dist/leaflet.css";

/**
 * Real map for temples that have no sub-locations yet.
 * Centred on the temple's own coordinates (OpenStreetMap tiles, free).
 */
export default function SingleTempleMap({ temple }) {
  const elRef = useRef(null);
  const lat = Number(temple.latitude);
  const lon = Number(temple.longitude);

  useEffect(() => {
    if (!elRef.current) return;
    const map = L.map(elRef.current, { center: [lat, lon], zoom: 15 });
    L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
      maxZoom: 19,
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    }).addTo(map);
    L.circleMarker([lat, lon], {
      radius: 10, color: "#b45309", weight: 3, fillColor: "#f59e0b", fillOpacity: 0.9,
    }).addTo(map).bindTooltip(temple.name, { permanent: false });
    return () => map.remove();
  }, [lat, lon, temple.name]);

  const osm = `https://www.openstreetmap.org/?mlat=${lat}&mlon=${lon}#map=17/${lat}/${lon}`;
  const dir = `https://www.openstreetmap.org/directions?to=${lat}%2C${lon}`;

  return (
    <div className="mx-auto w-full max-w-xl">
      <div
        ref={elRef}
        style={{ height: 420 }}
        className="w-full overflow-hidden rounded-3xl border border-saffron/25 shadow-2xl"
      />
      <div className="mt-3 flex flex-wrap items-center justify-center gap-2 text-sm font-semibold">
        <a className="btn btn-outline btn-sm" href={osm} target="_blank" rel="noreferrer">Open larger map</a>
        <a className="btn btn-primary btn-sm" href={dir} target="_blank" rel="noreferrer">Get directions</a>
      </div>
      <p className="mt-2 text-center text-xs text-midnight-700/50">
        Detailed shrine-by-shrine map is not available for this temple yet.
      </p>
    </div>
  );
}
