-- TempleVerse search assistance.
-- Run after 202611160001_durable_temple_discovery_tasks.sql. Idempotent.
--
-- 1. Typo-tolerant matching (pg_trgm) on name / place / deity.
-- 2. The full-text document now includes history, architecture and cultural
--    significance, so enriched text becomes searchable.
-- 3. Results are ranked by relevance (exact name > name prefix > text rank)
--    instead of alphabetically. The function signature is unchanged, so the
--    frontend needs no change to benefit from it.

-- Supabase installs extensions in the "extensions" schema.
create extension if not exists pg_trgm with schema extensions;
set search_path = public, extensions;

-- Immutable helper so the trigram index can be built on an expression.
create or replace function public.templeverse_search_text(
  p_name text, p_official text, p_local text, p_city text, p_state text, p_deity text
) returns text
language sql immutable parallel safe
as $$
  select lower(
    coalesce(p_name,'')     || ' ' || coalesce(p_official,'') || ' ' ||
    coalesce(p_local,'')    || ' ' || coalesce(p_city,'')     || ' ' ||
    coalesce(p_state,'')    || ' ' || coalesce(p_deity,'')
  )
$$;

create index if not exists idx_temples_search_text_trgm
  on public.temples using gin (
    public.templeverse_search_text(name, official_name, local_name, city, state, main_deity)
    gin_trgm_ops
  );

-- Search document: add the long-form fields (lowest weight).
create or replace function public.templeverse_refresh_search_document()
returns trigger language plpgsql as $$
begin
  new.search_document :=
    setweight(to_tsvector('simple', coalesce(new.name,'')), 'A') ||
    setweight(to_tsvector('simple', coalesce(new.official_name,'')), 'A') ||
    setweight(to_tsvector('simple', coalesce(new.local_name,'')), 'A') ||
    setweight(to_tsvector('simple', coalesce(new.city,'')), 'B') ||
    setweight(to_tsvector('simple', coalesce(new.state,'')), 'B') ||
    setweight(to_tsvector('simple', coalesce(new.main_deity,'')), 'B') ||
    setweight(to_tsvector('simple', coalesce(new.architectural_style,'')), 'C') ||
    setweight(to_tsvector('simple', coalesce(new.description,'')), 'D') ||
    setweight(to_tsvector('simple', coalesce(new.history,'')), 'D') ||
    setweight(to_tsvector('simple', coalesce(new.architecture_summary,'')), 'D') ||
    setweight(to_tsvector('simple', coalesce(new.cultural_significance,'')), 'D') ||
    setweight(to_tsvector('simple', coalesce(new.metadata::text,'')), 'D');
  return new;
end $$;

drop trigger if exists temples_refresh_search_document on public.temples;
create trigger temples_refresh_search_document
before insert or update of name, official_name, local_name, city, state,
  main_deity, architectural_style, description, history, architecture_summary,
  cultural_significance, metadata
on public.temples
for each row execute function public.templeverse_refresh_search_document();

-- Rebuild every document once (UPDATE OF fires the trigger when the column is
-- in the SET list, even though the value is unchanged).
update public.temples set name = name;

create or replace function public.search_temples(
  p_query text default null,
  p_state text default null,
  p_deity text default null,
  p_architecture text default null,
  p_dynasty text default null,
  p_festival text default null,
  p_jatra text default null,
  p_category text default null,
  p_tradition text default null,
  p_limit integer default 50,
  p_offset integer default 0
)
returns setof public.temples
language sql
stable
security invoker
set search_path = public, extensions
as $$
  with q as (
    select
      nullif(lower(trim(p_query)), '') as raw,
      websearch_to_tsquery('simple', coalesce(p_query, '')) as ts
  )
  select t.*
  from public.temples t, q
  where t.published = true
    and (
      q.raw is null
      -- full text (all words, any order)
      or t.search_document @@ q.ts
      -- every word appears somewhere in name / place / deity (handles prefixes)
      or not exists (
        select 1 from unnest(string_to_array(q.raw, ' ')) as tok
        where tok <> ''
          and public.templeverse_search_text(t.name, t.official_name, t.local_name,
                t.city, t.state, t.main_deity) not like '%' || tok || '%'
      )
      -- typos: "maduria" still finds Madurai
      or word_similarity(q.raw, public.templeverse_search_text(t.name, t.official_name,
            t.local_name, t.city, t.state, t.main_deity)) > 0.5
      or exists (select 1 from public.temple_names tn
        where tn.temple_id = t.id and tn.name ilike '%' || trim(p_query) || '%')
    )
    and (nullif(trim(p_state),'') is null or lower(t.state)=lower(p_state))
    and (nullif(trim(p_deity),'') is null or
      t.main_deity ilike '%' || p_deity || '%'
      or exists (select 1 from public.temple_deities td
        join public.deities d on d.id=td.deity_id
        where td.temple_id=t.id and d.canonical_name ilike '%' || p_deity || '%')
      or t.metadata::text ilike '%' || p_deity || '%')
    and (nullif(trim(p_architecture),'') is null or
      t.architectural_style ilike '%' || p_architecture || '%'
      or exists (select 1 from public.temple_architecture a
        where a.temple_id=t.id and a.architectural_style ilike '%' || p_architecture || '%'))
    and (nullif(trim(p_dynasty),'') is null or
      t.historical_period ilike '%' || p_dynasty || '%'
      or exists (select 1 from public.temple_dynasties td
        join public.dynasties d on d.id=td.dynasty_id
        where td.temple_id=t.id and d.name ilike '%' || p_dynasty || '%')
      or t.metadata::text ilike '%' || p_dynasty || '%')
    and (nullif(trim(p_festival),'') is null or
      exists (select 1 from public.temple_festivals tf
        join public.festivals f on f.id=tf.festival_id
        where tf.temple_id=t.id and f.canonical_name ilike '%' || p_festival || '%')
      or t.metadata::text ilike '%' || p_festival || '%')
    and (nullif(trim(p_jatra),'') is null or
      exists (select 1 from public.temple_jatras tj
        join public.jatras j on j.id=tj.jatra_id
        where tj.temple_id=t.id and j.canonical_name ilike '%' || p_jatra || '%'
          and j.verification_status='verified'))
    and (nullif(trim(p_category),'') is null or
      t.temple_category ilike '%' || p_category || '%'
      or t.metadata->'identity'->>'temple_category' ilike '%' || p_category || '%')
    and (nullif(trim(p_tradition),'') is null or
      t.religious_tradition ilike '%' || p_tradition || '%'
      or t.metadata->'identity'->>'religious_tradition' ilike '%' || p_tradition || '%')
  order by
    case
      when q.raw is null then 4
      when lower(t.name) = q.raw then 0
      when lower(t.name) like q.raw || '%' then 1
      when lower(t.name) like '%' || q.raw || '%' then 2
      else 3
    end,
    coalesce(ts_rank_cd(t.search_document, q.ts), 0) desc,
    t.name
  limit greatest(1, least(coalesce(p_limit,50),100))
  offset greatest(0, coalesce(p_offset,0));
$$;

grant execute on function public.search_temples(text,text,text,text,text,text,text,text,text,integer,integer)
to anon, authenticated;
