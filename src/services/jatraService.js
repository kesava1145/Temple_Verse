import { supabase, isSupabaseConfigured } from "../lib/supabase";

const requireSupabase = () => {
  if (!isSupabaseConfigured || !supabase) {
    throw new Error("Jatra catalogue requires a configured Supabase project.");
  }
};

export async function getJatras({ search = "", year = null, templeId = null } = {}) {
  requireSupabase();
  let query = supabase
    .from("jatras")
    .select(`
      *,
      temple_jatras (
        temple_id, local_name, role, notes,
        temples (id, slug, name, city, state, image_url)
      ),
      jatra_events (id, event_year, starts_on, ends_on, schedule_notes, verification_status),
      jatra_translations (*, languages (code))
    `)
    .eq("verification_status", "verified")
    .order("canonical_name");

  if (search.trim()) {
    const term = search.trim().replace(/[(),]/g, " ");
    query = query.or(`canonical_name.ilike.%${term}%,local_name.ilike.%${term}%,description.ilike.%${term}%`);
  }
  const { data, error } = await query;
  if (error) throw error;

  return (data || [])
    .map((jatra) => {
      const translations = {};
      for (const row of jatra.jatra_translations || []) {
        const code = row.languages?.code || "en";
        const { languages, language_id, id: translationId, ...fields } = row;
        translations[code] = fields;
      }
      return {
        ...jatra,
        translations,
        temple_jatras: (jatra.temple_jatras || []).filter((link) =>
          !templeId || link.temple_id === templeId),
        jatra_events: (jatra.jatra_events || []).filter((event) =>
          !year || event.event_year === Number(year)),
      };
    })
    .filter((jatra) => !templeId || jatra.temple_jatras.length > 0);
}

export async function getJatraById(id) {
  requireSupabase();
  const { data, error } = await supabase
    .from("jatras")
    .select("*, temple_jatras(*, temples(id,slug,name,city,state)), jatra_events(*)")
    .eq("id", id)
    .eq("verification_status", "verified")
    .maybeSingle();
  if (error) throw error;
  return data;
}

export async function getFestivalCalendar({ year = null, templeId = null } = {}) {
  requireSupabase();
  let query = supabase
    .from("festival_events")
    .select("*, festivals(*), temples(id,slug,name,city,state)")
    .eq("verification_status", "verified")
    .order("starts_on");
  if (year) query = query.eq("event_year", Number(year));
  if (templeId) query = query.eq("temple_id", templeId);
  const { data, error } = await query;
  if (error) throw error;
  return data || [];
}
