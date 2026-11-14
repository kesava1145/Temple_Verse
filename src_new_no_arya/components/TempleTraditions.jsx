import React from "react";
import { CalendarDays, Flame, Route, Landmark } from "lucide-react";
import { useLanguage } from "../context/LanguageContext";

function dateLabel(value) {
  if (!value) return "Date not announced";
  const date = new Date(`${value}T00:00:00`);
  return Number.isNaN(date.getTime())
    ? value
    : new Intl.DateTimeFormat("en-IN", { day: "numeric", month: "short", year: "numeric" }).format(date);
}

export default function TempleTraditions({ temple }) {
  const { lang } = useLanguage();
  const festivals = temple?.festivals || [];
  const jatras = temple?.jatras || [];
  if (!festivals.length && !jatras.length) return null;

  const localized = (record) => record?.translations?.[lang] || record?.translations?.en || {};
  const events = (items) => items.flatMap((item) => item.events || []);

  return (
    <section aria-labelledby="temple-traditions-heading" className="temple-traditions">
      <div className="temple-traditions-heading">
        <span className="temple-traditions-kicker">Living heritage of this temple</span>
        <h2 id="temple-traditions-heading">Festivals & Jatras</h2>
        <p>Celebrations, processions and sacred journeys associated with this temple.</p>
      </div>

      {festivals.length > 0 && (
        <div className="temple-traditions-group">
          <h3><CalendarDays aria-hidden="true"/> Festivals</h3>
          <div className="temple-traditions-grid">
            {festivals.map((festival) => {
              const tr = localized(festival);
              const title = tr.name || festival.local_name || festival.canonical_name;
              const details = festival.temple_details || {};
              return (
                <article className="temple-tradition-card" key={festival.id}>
                  <span className="temple-tradition-type"><Flame aria-hidden="true"/> {festival.festival_type || "Temple festival"}</span>
                  <h4>{title}</h4>
                  {(tr.description || festival.description) && <p>{tr.description || festival.description}</p>}
                  {details.duration_days && <p className="temple-tradition-meta">Duration: {details.duration_days} days</p>}
                  {details.procession_traditions && <p className="temple-tradition-meta">{details.procession_traditions}</p>}
                  {details.chariot_festival && <span className="temple-tradition-tag">Chariot festival</span>}
                  {(festival.events || []).length > 0 && (
                    <div className="temple-tradition-dates">
                      {(festival.events || []).map((event) => (
                        <p key={event.id}><CalendarDays aria-hidden="true"/> {event.event_year}: {dateLabel(event.starts_on)}{event.ends_on ? ` – ${dateLabel(event.ends_on)}` : ""}</p>
                      ))}
                    </div>
                  )}
                </article>
              );
            })}
          </div>
        </div>
      )}

      {jatras.length > 0 && (
        <div className="temple-traditions-group">
          <h3><Route aria-hidden="true"/> Jatras & processions</h3>
          <div className="temple-traditions-grid">
            {jatras.map((jatra) => {
              const tr = localized(jatra);
              const title = tr.name || jatra.local_name || jatra.canonical_name;
              return (
                <article className="temple-tradition-card" key={jatra.id}>
                  <span className="temple-tradition-type"><Landmark aria-hidden="true"/> {jatra.jatra_type?.replaceAll("_", " ") || "Temple Jatra"}</span>
                  <h4>{title}</h4>
                  {(tr.description || jatra.description) && <p>{tr.description || jatra.description}</p>}
                  {jatra.role && <p className="temple-tradition-meta">Temple role: {jatra.role.replaceAll("_", " ")}</p>}
                  {(tr.route_description || jatra.route_description) && <p className="temple-tradition-meta">{tr.route_description || jatra.route_description}</p>}
                  {jatra.association_notes && <p className="temple-tradition-meta">{jatra.association_notes}</p>}
                  {(jatra.events || []).length > 0 && (
                    <div className="temple-tradition-dates">
                      {(jatra.events || []).map((event) => (
                        <p key={event.id}><CalendarDays aria-hidden="true"/> {event.event_year}: {dateLabel(event.starts_on)}{event.ends_on ? ` – ${dateLabel(event.ends_on)}` : ""}{event.schedule_notes ? ` · ${event.schedule_notes}` : ""}</p>
                      ))}
                    </div>
                  )}
                </article>
              );
            })}
          </div>
        </div>
      )}
    </section>
  );
}
