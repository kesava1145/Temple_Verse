-- TempleVerse scalable discovery, metadata search, jatras and festival events.
-- Run after 202611130001_temple_metadata_and_ingestion.sql.
-- Idempotent: safe to re-run.

-- Preserve the full metadata contract in JSONB; frequently queried fields
-- remain relational in the existing columns / relation tables.
alter table public.temples
  add column if not exists search_document tsvector;

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
    setweight(to_tsvector('simple', coalesce(new.metadata::text,'')), 'D');
  return new;
end $$;

drop trigger if exists temples_refresh_search_document on public.temples;
create trigger temples_refresh_search_document
before insert or update of name, official_name, local_name, city, state,
  main_deity, architectural_style, description, metadata
on public.temples
for each row execute function public.templeverse_refresh_search_document();

update public.temples
set search_document =
  setweight(to_tsvector('simple', coalesce(name,'')), 'A') ||
  setweight(to_tsvector('simple', coalesce(official_name,'')), 'A') ||
  setweight(to_tsvector('simple', coalesce(local_name,'')), 'A') ||
  setweight(to_tsvector('simple', coalesce(city,'')), 'B') ||
  setweight(to_tsvector('simple', coalesce(state,'')), 'B') ||
  setweight(to_tsvector('simple', coalesce(main_deity,'')), 'B') ||
  setweight(to_tsvector('simple', coalesce(architectural_style,'')), 'C') ||
  setweight(to_tsvector('simple', coalesce(description,'')), 'D') ||
  setweight(to_tsvector('simple', coalesce(metadata::text,'')), 'D')
where search_document is null;

create index if not exists idx_temples_search_document
  on public.temples using gin(search_document);

-- Jatras are distinct from generic festivals: they describe processions,
-- pilgrimages, or public religious journeys. No dates are inferred.
create table if not exists public.jatras (
  id uuid primary key default gen_random_uuid(),
  canonical_name text not null unique,
  local_name text,
  jatra_type text not null default 'procession'
    check (jatra_type in ('procession','pilgrimage','chariot','annual_utsav','other')),
  description text,
  religious_tradition text,
  usual_calendar_period text,
  duration_days integer,
  route_description text,
  route_stops jsonb not null default '[]'::jsonb,
  customs jsonb not null default '[]'::jsonb,
  source_id uuid references public.sources(id) on delete set null,
  verification_status text not null default 'pending'
    check (verification_status in ('verified','pending','disputed','rejected')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.temple_jatras (
  temple_id uuid not null references public.temples(id) on delete cascade,
  jatra_id uuid not null references public.jatras(id) on delete cascade,
  local_name text,
  role text not null default 'host'
    check (role in ('host','route_stop','associated','starting_point','ending_point')),
  notes text,
  source_id uuid references public.sources(id) on delete set null,
  primary key (temple_id, jatra_id, role)
);

create table if not exists public.jatra_events (
  id uuid primary key default gen_random_uuid(),
  jatra_id uuid not null references public.jatras(id) on delete cascade,
  temple_id uuid references public.temples(id) on delete cascade,
  event_year integer not null,
  starts_on date,
  ends_on date,
  schedule_notes text,
  route_changes jsonb not null default '{}'::jsonb,
  source_id uuid references public.sources(id) on delete set null,
  verification_status text not null default 'unverified'
    check (verification_status in ('verified','unverified','cancelled','postponed')),
  unique (jatra_id, temple_id, event_year),
  check (ends_on is null or starts_on is null or ends_on >= starts_on)
);

create table if not exists public.jatra_translations (
  id uuid primary key default gen_random_uuid(),
  jatra_id uuid not null references public.jatras(id) on delete cascade,
  language_id uuid not null references public.languages(id) on delete cascade,
  name text,
  description text,
  route_description text,
  customs jsonb not null default '[]'::jsonb,
  unique (jatra_id, language_id)
);

create table if not exists public.festival_translations (
  id uuid primary key default gen_random_uuid(),
  festival_id uuid not null references public.festivals(id) on delete cascade,
  language_id uuid not null references public.languages(id) on delete cascade,
  name text,
  description text,
  unique (festival_id, language_id)
);

create index if not exists idx_jatras_name on public.jatras using gin(to_tsvector('simple', canonical_name));
create index if not exists idx_temple_jatras_jatra on public.temple_jatras(jatra_id);
create index if not exists idx_jatra_events_year on public.jatra_events(event_year, starts_on);
create index if not exists idx_jatras_status on public.jatras(verification_status);
create index if not exists idx_temple_festivals_temple on public.temple_festivals(temple_id);
create index if not exists idx_temple_deities_deity on public.temple_deities(deity_id);
create index if not exists idx_temple_dynasties_dynasty on public.temple_dynasties(dynasty_id);

alter table public.jatras enable row level security;
alter table public.temple_jatras enable row level security;
alter table public.jatra_events enable row level security;
alter table public.jatra_translations enable row level security;
alter table public.festival_translations enable row level security;

drop policy if exists "Public read verified jatras" on public.jatras;
create policy "Public read verified jatras" on public.jatras
for select to anon, authenticated using (verification_status = 'verified');

drop policy if exists "Public read published temple jatras" on public.temple_jatras;
create policy "Public read published temple jatras" on public.temple_jatras
for select to anon, authenticated using (
  exists (select 1 from public.temples t
    where t.id = temple_jatras.temple_id and t.published)
  and exists (select 1 from public.jatras j
    where j.id = temple_jatras.jatra_id and j.verification_status = 'verified')
);

drop policy if exists "Public read verified jatra events" on public.jatra_events;
create policy "Public read verified jatra events" on public.jatra_events
for select to anon, authenticated using (
  verification_status = 'verified'
  and exists (select 1 from public.jatras j
    where j.id = jatra_events.jatra_id and j.verification_status = 'verified')
  and (temple_id is null or exists (select 1 from public.temples t
    where t.id = jatra_events.temple_id and t.published))
);

drop policy if exists "Public read jatra translations" on public.jatra_translations;
create policy "Public read jatra translations" on public.jatra_translations
for select to anon, authenticated using (
  exists (select 1 from public.jatras j
    where j.id = jatra_translations.jatra_id and j.verification_status = 'verified')
);

drop policy if exists "Public read festival translations" on public.festival_translations;
create policy "Public read festival translations" on public.festival_translations
for select to anon, authenticated using (
  exists (select 1 from public.festivals f where f.id = festival_translations.festival_id)
);

-- Faceted search RPC. All filters are optional and combined with AND.
-- Search spans canonical names, aliases, place, deity and metadata JSON.
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
set search_path = public
as $$
  select t.*
  from public.temples t
  where t.published = true
    and (
      nullif(trim(p_query),'') is null
      or t.search_document @@ websearch_to_tsquery('simple', p_query)
      or concat_ws(' ', t.name, t.official_name, t.local_name, t.city,
          t.state, t.main_deity, t.description, t.metadata::text)
          ilike '%' || trim(p_query) || '%'
      or exists (select 1 from public.temple_names tn
        where tn.temple_id=t.id and tn.name ilike '%' || trim(p_query) || '%')
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
    case when nullif(trim(p_query),'') is not null and
      lower(t.name)=lower(trim(p_query)) then 0 else 1 end,
    t.name
  limit greatest(1, least(coalesce(p_limit,50),100))
  offset greatest(0, coalesce(p_offset,0));
$$;

grant execute on function public.search_temples(text,text,text,text,text,text,text,text,text,integer,integer)
to anon, authenticated;

-- Public read privileges are required in addition to RLS policies.
grant usage on schema public to anon, authenticated;
grant select on public.jatras, public.temple_jatras, public.jatra_events,
  public.jatra_translations, public.festival_translations to anon, authenticated;

-- Backfill searchable metadata for the existing catalogue from facts already
-- present in the seed. Unknown fields deliberately remain NULL/empty.
update public.temples
set metadata = coalesce(metadata, '{}'::jsonb) ||
  jsonb_build_object(
    'identity', coalesce(metadata->'identity', '{}'::jsonb) || jsonb_strip_nulls(jsonb_build_object(
      'principal_deity', main_deity,
      'religious_tradition', religious_tradition,
      'temple_category', temple_category
    )),
    'geography', coalesce(metadata->'geography', '{}'::jsonb) || jsonb_strip_nulls(jsonb_build_object(
      'country', country, 'state', state, 'city_or_village', city,
      'latitude', latitude, 'longitude', longitude, 'district', district
    )),
    'history', coalesce(metadata->'history', '{}'::jsonb) || jsonb_strip_nulls(jsonb_build_object(
      'historical_period', historical_period
    )),
    'architecture', coalesce(metadata->'architecture', '{}'::jsonb) || jsonb_strip_nulls(jsonb_build_object(
      'architectural_style', architectural_style
    ))
  );

-- Example verified festival record grounded in the supplied catalogue text.
-- This is a festival association, not a fabricated year-specific event date.
insert into public.festivals (canonical_name, description, festival_type, usual_calendar_period)
values (
  'Chithirai Festival',
  'Annual Madurai festival associated with the divine marriage of Meenakshi and Sundareswarar, as described in the supplied TempleVerse catalogue content.',
  'temple_festival',
  'Chithirai month; exact annual dates vary'
)
on conflict (canonical_name) do nothing;

insert into public.temple_festivals (temple_id, festival_id, cultural_notes)
select t.id, f.id,
  'The catalogue describes the festival as enacting the marriage of Meenakshi and Sundareswarar and shaping Madurai’s annual calendar.'
from public.temples t
join public.festivals f on f.canonical_name='Chithirai Festival'
where t.slug='meenakshi'
on conflict (temple_id, festival_id) do nothing;

-- No Jatra is auto-published from incomplete evidence. The Jatra catalogue
-- starts empty and accepts researched candidates for human verification.

-- search_temples runs as the caller (SECURITY INVOKER), so the caller also
-- needs SELECT privileges on the metadata join tables; RLS remains in force.
grant select on public.temple_names, public.deities, public.temple_deities,
  public.dynasties, public.temple_dynasties, public.temple_architecture,
  public.temple_historical_events, public.temple_rituals, public.temple_traditions,
  public.festivals, public.temple_festivals, public.temple_conservation,
  public.temple_discovery_metadata to anon, authenticated;


-- Jatra discovery queue is private until a reviewer approves a candidate.
create table if not exists public.jatra_candidates (
  id uuid primary key default gen_random_uuid(),
  ingestion_run_id uuid references public.ingestion_runs(id) on delete set null,
  proposed_name text not null,
  proposed_local_name text,
  jatra_type text not null default 'procession',
  proposed_description text,
  proposed_route jsonb not null default '[]'::jsonb,
  proposed_temple_slugs text[] not null default '{}',
  source_url text not null,
  extracted_metadata jsonb not null default '{}'::jsonb,
  review_status text not null default 'pending'
    check (review_status in ('pending','approved','rejected','duplicate','needs_research')),
  duplicate_of_jatra_id uuid references public.jatras(id) on delete set null,
  reviewer_notes text,
  reviewed_at timestamptz,
  created_at timestamptz not null default now()
);
create index if not exists idx_jatra_candidates_review
  on public.jatra_candidates(review_status, created_at);
alter table public.jatra_candidates enable row level security;
revoke all on public.jatra_candidates from anon, authenticated;

-- Seed the trusted-source registry from the curated source catalogue.
-- The crawler remains limited to each source's own host and robots.txt.
insert into public.ingestion_sources
  (source_name, base_url, source_type, trust_tier, enabled, allowed_domains, crawl_policy)
select
  s.title, s.url, s.source_type,
  case
    when s.source_type ilike '%UNESCO%' or s.source_type ilike '%Government%' then 1
    when s.source_type ilike '%Temple Administration%' then 1
    when s.source_type ilike '%Tourism%' then 2
    else 3
  end,
  true,
  array[lower(split_part(split_part(s.url, '://', 2), '/', 1))],
  jsonb_build_object('max_pages', 4, 'respect_robots_txt', true)
from public.sources s
on conflict (base_url) do nothing;

alter table public.temple_candidates
  add column if not exists promoted_temple_id uuid references public.temples(id) on delete set null;
alter table public.jatra_candidates
  add column if not exists promoted_jatra_id uuid references public.jatras(id) on delete set null;

grant select on public.festival_events to anon, authenticated;
 

-- Machine-assisted translations are drafts until a human approves them.
create table if not exists public.content_translation_drafts (
  id uuid primary key default gen_random_uuid(),
  entity_type text not null check (entity_type in ('temple','location','guided_step')),
  entity_id uuid not null,
  field_name text not null,
  source_language text not null default 'en',
  target_language text not null,
  source_text text not null,
  draft_text text not null,
  source_hash text not null,
  model_name text,
  review_status text not null default 'pending'
    check (review_status in ('pending','approved','rejected','superseded')),
  reviewer_notes text,
  reviewed_by text,
  reviewed_at timestamptz,
  published_at timestamptz,
  created_at timestamptz not null default now(),
  unique (entity_type, entity_id, field_name, target_language, source_hash)
);
create index if not exists idx_translation_drafts_review
  on public.content_translation_drafts(target_language, review_status, entity_type);
alter table public.content_translation_drafts enable row level security;
revoke all on public.content_translation_drafts from anon, authenticated;

create or replace function public.publish_translation_draft(p_draft_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  d public.content_translation_drafts%rowtype;
  lang_id uuid;
begin
  if coalesce(auth.role(),'') in ('anon', 'authenticated') then
    raise exception 'public roles cannot publish translation drafts';
  end if;

  select * into d from public.content_translation_drafts
  where id = p_draft_id for update;
  if not found then raise exception 'translation draft not found'; end if;
  if d.review_status <> 'approved' then
    raise exception 'translation draft must be approved before publishing';
  end if;

  select id into lang_id from public.languages where code = d.target_language;
  if lang_id is null then raise exception 'target language is not configured'; end if;

  if d.entity_type = 'temple' then
    if d.field_name not in ('name','description','history','architecture_summary','cultural_significance','main_deity','architectural_style','historical_period') then
      raise exception 'unsupported temple translation field';
    end if;
    execute format(
      'insert into public.temple_translations (temple_id, language_id, %I) values ($1,$2,$3) on conflict (temple_id,language_id) do update set %I = excluded.%I',
      d.field_name, d.field_name, d.field_name
    ) using d.entity_id, lang_id, d.draft_text;
  elsif d.entity_type = 'location' then
    if d.field_name not in ('name','description','story','architecture','rituals','significance') then
      raise exception 'unsupported location translation field';
    end if;
    execute format(
      'insert into public.location_translations (location_id, language_id, %I) values ($1,$2,$3) on conflict (location_id,language_id) do update set %I = excluded.%I',
      d.field_name, d.field_name, d.field_name
    ) using d.entity_id, lang_id, d.draft_text;
  elsif d.entity_type = 'guided_step' then
    if d.field_name not in ('title','description') then
      raise exception 'unsupported guided step translation field';
    end if;
    execute format(
      'insert into public.guided_step_translations (step_id, language_id, %I) values ($1,$2,$3) on conflict (step_id,language_id) do update set %I = excluded.%I',
      d.field_name, d.field_name, d.field_name
    ) using d.entity_id, lang_id, d.draft_text;
  end if;

  update public.content_translation_drafts set published_at = now()
  where id = p_draft_id;
end $$;

revoke all on function public.publish_translation_draft(uuid) from public, anon, authenticated;
grant execute on function public.publish_translation_draft(uuid) to service_role;

-- Facet options are computed in PostgreSQL so the client does not download the
-- entire catalogue just to build filter dropdowns.
create or replace function public.get_temple_filter_options()
returns jsonb
language sql
stable
security invoker
set search_path = public
as $$
  select jsonb_build_object(
    'states', coalesce((select jsonb_agg(v) from (select distinct state as v from public.temples where published and state is not null order by v) q), '[]'::jsonb),
    'deities', coalesce((select jsonb_agg(v) from (
      select distinct d.canonical_name as v from public.temple_deities td
      join public.deities d on d.id=td.deity_id join public.temples t on t.id=td.temple_id
      where t.published
      union select distinct main_deity from public.temples where published and main_deity is not null
    ) q), '[]'::jsonb),
    'architectures', coalesce((select jsonb_agg(v) from (
      select distinct architectural_style as v from public.temples where published and architectural_style is not null
      union select distinct architectural_style from public.temple_architecture where architectural_style is not null
    ) q), '[]'::jsonb),
    'dynasties', coalesce((select jsonb_agg(v) from (
      select distinct d.name as v from public.temple_dynasties td
      join public.dynasties d on d.id=td.dynasty_id join public.temples t on t.id=td.temple_id
      where t.published
    ) q), '[]'::jsonb),
    'festivals', coalesce((select jsonb_agg(v) from (
      select distinct f.canonical_name as v from public.temple_festivals tf
      join public.festivals f on f.id=tf.festival_id join public.temples t on t.id=tf.temple_id
      where t.published
    ) q), '[]'::jsonb),
    'jatras', coalesce((select jsonb_agg(v) from (
      select distinct j.canonical_name as v from public.temple_jatras tj
      join public.jatras j on j.id=tj.jatra_id join public.temples t on t.id=tj.temple_id
      where t.published and j.verification_status='verified'
    ) q), '[]'::jsonb),
    'categories', coalesce((select jsonb_agg(v) from (select distinct temple_category as v from public.temples where published and temple_category is not null order by v) q), '[]'::jsonb),
    'traditions', coalesce((select jsonb_agg(v) from (select distinct religious_tradition as v from public.temples where published and religious_tradition is not null order by v) q), '[]'::jsonb)
  );
$$;
grant execute on function public.get_temple_filter_options() to anon, authenticated;
