import React from "react";
import IndiaTempleMap from "../components/IndiaTempleMap";

export default function IndiaMapPage() {
  return (
    <main className="py-6">
      <div className="mx-auto max-w-6xl px-4">
        <h1 className="font-display text-3xl font-bold text-midnight">Temple Map of India</h1>
        <p className="mt-1 text-sm text-midnight-700/70">
          Every temple in the database, placed on the map. Click a pin to preview it.
        </p>
      </div>
      <IndiaTempleMap />
    </main>
  );
}
