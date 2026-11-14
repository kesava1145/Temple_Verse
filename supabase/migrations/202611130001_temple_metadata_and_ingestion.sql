-- TempleVerse scalable metadata + ingestion foundation
-- Apply AFTER supabase/schema.sql and supabase/seed.sql on a fresh project.
-- Safe to re-run: all objects use IF NOT EXISTS / replaceable policies.

-- Core identity and geography: keep frequently-filtered fields relational.
alter table public.temples
  add column if not exists official_name text,
  add column if not exists local_name text,
  add column if not exists temple_category text,
  add column if not exists religious_tradition text,
  add column if not exists temple_status text,
  add column if not exists management_organization text,
  add column if not exists district text,
  add column if not exists postal_code text,
  add column if not exists elevation_m numeric,
  add column if not exists terrain_type text,
  add column if not exists nearby_river text,
  add column if not exists nearby_mountains text,
  add column if not exists nearest_city_distance_km numeric,
  add column if not exists metadata jsonb not null default '{}'::jsonb,
  add column if not exists verification_status text not null default 'legacy',
  add column if not exists last_verified_at timestamptz,
  add column if not exists updated_at timestamptz not null default now();

-- Preserve current app compatibility, but remove video as a supported media type.
do $$ declare c record; begin
  for c in select conname from pg_constraint
    where conrelid = 'public.media'::regclass and contype = 'c'
      and pg_get_constraintdef(oid) ilike '%type%'
  loop execute format('alter table public.media drop constraint %I', c.conname); end loop;
end $$;
alter table public.media add constraint media_type_audio_only check (type = 'audio');

-- Alternate/local names and aliases.
create table if not exists public.temple_names (
  id uuid primary key default gen_random_uuid(),
  temple_id uuid not null references public.temples(id) on delete cascade,
  name text not null,
  language_code text,
  name_type text not null default 'alternate' check (name_type in ('official','common','local','alternate','historical','transliteration')),
  source_id uuid references public.sources(id) on delete set null,
  created_at timestamptz not null default now(),
  unique (temple_id, name, language_code, name_type)
);

-- Controlled vocabularies and many-to-many deity links.
create table if not exists public.deities (
  id uuid primary key default gen_random_uuid(),
  canonical_name text not null unique,
  tradition text,
  description text
);
create table if not exists public.temple_deities (
  temple_id uuid not null references public.temples(id) on delete cascade,
  deity_id uuid not null references public.deities(id) on delete restrict,
  role text not null default 'associated' check (role in ('principal','secondary','consort','associated','guardian')),
  form text,
  posture text,
  attributes text[],
  display_order integer not null default 0,
  primary key (temple_id, deity_id, role)
);

create table if not exists public.dynasties (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  region text,
  period_start text,
  period_end text
);
create table if not exists public.temple_dynasties (
  temple_id uuid not null references public.temples(id) on delete cascade,
  dynasty_id uuid not null references public.dynasties(id) on delete restrict,
  relationship text not null default 'associated',
  notes text,
  primary key (temple_id, dynasty_id, relationship)
);

-- Historical events, inscriptions, donations, reconstruction and expansion.
create table if not exists public.temple_historical_events (
  id uuid primary key default gen_random_uuid(),
  temple_id uuid not null references public.temples(id) on delete cascade,
  event_type text not null,
  date_label text,
  date_start integer,
  date_end integer,
  title text not null,
  description text,
  certainty text not null default 'unverified' check (certainty in ('attested','probable','traditional','disputed','unverified')),
  source_id uuid references public.sources(id) on delete set null,
  display_order integer not null default 0,
  created_at timestamptz not null default now()
);

-- Structured architectural observations; values may be unknown/null.
create table if not exists public.temple_architecture (
  temple_id uuid primary key references public.temples(id) on delete cascade,
  architectural_style text,
  main_sanctum_type text,
  garbhagriha_structure text,
  vimana_type text,
  gopuram_count integer,
  gopuram_height_m numeric,
  prakara_count integer,
  mandapam_count integer,
  pillar_count integer,
  pillar_material text,
  pillar_carving_style text,
  wall_material text,
  roof_material text,
  sculptural_themes text[],
  temple_layout text,
  orientation text,
  dimensions jsonb not null default '{}'::jsonb,
  sacred_tank text,
  flagstaff text,
  decorative_motifs text[]
);

-- Worship and ritual practices.
create table if not exists public.temple_rituals (
  id uuid primary key default gen_random_uuid(),
  temple_id uuid not null references public.temples(id) on delete cascade,
  ritual_category text not null,
  name text not null,
  description text,
  schedule text,
  source_id uuid references public.sources(id) on delete set null,
  tradition_status text not null default 'unverified' check (tradition_status in ('documented','traditional','unverified'))
);

-- Mythology and oral traditions are explicitly distinguished from history.
create table if not exists public.temple_traditions (
  id uuid primary key default gen_random_uuid(),
  temple_id uuid not null references public.temples(id) on delete cascade,
  tradition_type text not null,
  title text not null,
  narrative text,
  associated_text text,
  source_id uuid references public.sources(id) on delete set null,
  epistemic_status text not null default 'traditional' check (epistemic_status in ('traditional','oral_folklore','textual_tradition','historical_claim','unverified'))
);

-- Festivals are independent entities; temple association is many-to-many.
create table if not exists public.festivals (
  id uuid primary key default gen_random_uuid(),
  canonical_name text not null unique,
  description text,
  festival_type text,
  usual_calendar_period text
);
create table if not exists public.temple_festivals (
  temple_id uuid not null references public.temples(id) on delete cascade,
  festival_id uuid not null references public.festivals(id) on delete cascade,
  local_name text,
  duration_days integer,
  procession_traditions text,
  chariot_festival boolean,
  special_offerings text,
  cultural_notes text,
  source_id uuid references public.sources(id) on delete set null,
  primary key (temple_id, festival_id)
);
create table if not exists public.festival_events (
  id uuid primary key default gen_random_uuid(),
  temple_id uuid not null references public.temples(id) on delete cascade,
  festival_id uuid references public.festivals(id) on delete set null,
  event_year integer not null,
  starts_on date,
  ends_on date,
  schedule_notes text,
  source_id uuid references public.sources(id) on delete set null,
  verification_status text not null default 'unverified' check (verification_status in ('verified','unverified','cancelled')),
  unique (temple_id, festival_id, event_year)
);

-- Conservation and research metadata.
create table if not exists public.temple_conservation (
  temple_id uuid primary key references public.temples(id) on delete cascade,
  protected_monument_status text,
  heritage_designation text[],
  conservation_organization text,
  structural_condition text,
  restoration_projects jsonb not null default '[]'::jsonb,
  inscription_inventory jsonb not null default '[]'::jsonb,
  sculpture_inventory jsonb not null default '[]'::jsonb,
  research_publications jsonb not null default '[]'::jsonb,
  source_reliability_notes text,
  last_verification_date date
);

-- Claim-level provenance: each important assertion can have its own evidence.
create table if not exists public.temple_claims (
  id uuid primary key default gen_random_uuid(),
  temple_id uuid not null references public.temples(id) on delete cascade,
  field_path text not null,
  claim_value jsonb not null,
  claim_text text,
  claim_kind text not null default 'fact' check (claim_kind in ('fact','historical_claim','religious_tradition','interpretation','media_rights')),
  verification_status text not null default 'pending' check (verification_status in ('pending','verified','rejected','disputed','needs_review')),
  confidence numeric check (confidence between 0 and 1),
  reviewed_by text,
  reviewed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create table if not exists public.claim_sources (
  claim_id uuid not null references public.temple_claims(id) on delete cascade,
  source_id uuid not null references public.sources(id) on delete cascade,
  evidence_note text,
  retrieved_at timestamptz,
  primary key (claim_id, source_id)
);

-- Discovery and ingestion workflow. These tables are private to trusted server/admin roles.
create table if not exists public.ingestion_runs (
  id uuid primary key default gen_random_uuid(),
  run_type text not null default 'discovery',
  status text not null default 'queued' check (status in ('queued','running','completed','failed','cancelled')),
  source_scope text,
  started_at timestamptz,
  completed_at timestamptz,
  summary jsonb not null default '{}'::jsonb,
  error_message text,
  created_at timestamptz not null default now()
);
create table if not exists public.temple_candidates (
  id uuid primary key default gen_random_uuid(),
  ingestion_run_id uuid references public.ingestion_runs(id) on delete set null,
  proposed_name text not null,
  proposed_slug text,
  location_text text,
  source_url text,
  extracted_metadata jsonb not null default '{}'::jsonb,
  duplicate_of_temple_id uuid references public.temples(id) on delete set null,
  review_status text not null default 'pending' check (review_status in ('pending','approved','rejected','duplicate','needs_research')),
  reviewer_notes text,
  reviewed_at timestamptz,
  created_at timestamptz not null default now()
);
create table if not exists public.ingestion_sources (
  id uuid primary key default gen_random_uuid(),
  source_name text not null,
  base_url text not null,
  source_type text,
  trust_tier smallint not null default 3 check (trust_tier between 1 and 5),
  enabled boolean not null default true,
  allowed_domains text[] not null default '{}',
  crawl_policy jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  unique (base_url)
);

-- Image rights and provenance. Video is intentionally not supported.
alter table public.images
  add column if not exists license text,
  add column if not exists source_url text,
  add column if not exists width_px integer,
  add column if not exists height_px integer,
  add column if not exists is_cover boolean not null default false,
  add column if not exists rights_verified boolean not null default false;

-- Useful indexes for catalogue search, geographic filters and joins.
create index if not exists idx_temples_state_city on public.temples(state, city);
create index if not exists idx_temples_published on public.temples(published) where published = true;
create index if not exists idx_temples_metadata_gin on public.temples using gin(metadata);
create index if not exists idx_temple_names_name on public.temple_names using gin(to_tsvector('simple', name));
create index if not exists idx_temple_claims_temple_status on public.temple_claims(temple_id, verification_status);
create index if not exists idx_temple_events_temple on public.temple_historical_events(temple_id, display_order);
create index if not exists idx_temple_festivals_festival on public.temple_festivals(festival_id);
create index if not exists idx_festival_events_year on public.festival_events(event_year, starts_on);
create index if not exists idx_candidates_review on public.temple_candidates(review_status, created_at);

-- RLS: public catalogue reads only published temple records and their public children.
-- No anonymous INSERT/UPDATE/DELETE policy is created anywhere in this migration.
alter table public.temple_names enable row level security;
alter table public.deities enable row level security;
alter table public.temple_deities enable row level security;
alter table public.dynasties enable row level security;
alter table public.temple_dynasties enable row level security;
alter table public.temple_historical_events enable row level security;
alter table public.temple_architecture enable row level security;
alter table public.temple_rituals enable row level security;
alter table public.temple_traditions enable row level security;
alter table public.festivals enable row level security;
alter table public.temple_festivals enable row level security;
alter table public.festival_events enable row level security;
alter table public.temple_conservation enable row level security;
alter table public.temple_claims enable row level security;
alter table public.claim_sources enable row level security;
alter table public.ingestion_runs enable row level security;
alter table public.temple_candidates enable row level security;
alter table public.ingestion_sources enable row level security;

do $$ begin
  create policy "Public read temple names" on public.temple_names for select using (exists (select 1 from public.temples t where t.id = temple_id and t.published));
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "Public read deities" on public.deities for select using (true);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "Public read temple deities" on public.temple_deities for select using (exists (select 1 from public.temples t where t.id = temple_id and t.published));
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "Public read dynasties" on public.dynasties for select using (true);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "Public read temple dynasties" on public.temple_dynasties for select using (exists (select 1 from public.temples t where t.id = temple_id and t.published));
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "Public read historical events" on public.temple_historical_events for select using (exists (select 1 from public.temples t where t.id = temple_id and t.published));
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "Public read architecture" on public.temple_architecture for select using (exists (select 1 from public.temples t where t.id = temple_id and t.published));
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "Public read rituals" on public.temple_rituals for select using (exists (select 1 from public.temples t where t.id = temple_id and t.published));
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "Public read traditions" on public.temple_traditions for select using (exists (select 1 from public.temples t where t.id = temple_id and t.published));
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "Public read festivals" on public.festivals for select using (true);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "Public read temple festivals" on public.temple_festivals for select using (exists (select 1 from public.temples t where t.id = temple_id and t.published));
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "Public read festival events" on public.festival_events for select using (verification_status = 'verified' and exists (select 1 from public.temples t where t.id = temple_id and t.published));
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "Public read conservation" on public.temple_conservation for select using (exists (select 1 from public.temples t where t.id = temple_id and t.published));
exception when duplicate_object then null; end $$;

-- Claims, ingestion queues, source configuration remain inaccessible to anon/authenticated users.
revoke all on public.temple_claims, public.claim_sources, public.ingestion_runs,
  public.temple_candidates, public.ingestion_sources from anon, authenticated;

-- View gives the frontend a dynamic, database-derived basis for temple matching.
create or replace view public.temple_discovery_metadata as
select t.id as temple_id, t.slug, t.name, t.state, t.main_deity, t.architectural_style,
       t.religious_tradition, t.temple_category, t.historical_period,
       coalesce(array_agg(distinct d.canonical_name) filter (where d.id is not null), '{}') as associated_deities,
       coalesce(array_agg(distinct dy.name) filter (where dy.id is not null), '{}') as associated_dynasties,
       coalesce(array_agg(distinct f.canonical_name) filter (where f.id is not null), '{}') as festivals
from public.temples t
left join public.temple_deities td on td.temple_id = t.id
left join public.deities d on d.id = td.deity_id
left join public.temple_dynasties tdy on tdy.temple_id = t.id
left join public.dynasties dy on dy.id = tdy.dynasty_id
left join public.temple_festivals tf on tf.temple_id = t.id
left join public.festivals f on f.id = tf.festival_id
where t.published
group by t.id;

-- Keep view access read-only and limited to published rows through the underlying policies.
grant select on public.temple_discovery_metadata to anon, authenticated;

-- Tighten the original broad read policies from the starter schema.
do $$ begin
  drop policy if exists "Public read temples" on public.temples;
  create policy "Public read temples" on public.temples for select using (published = true);
exception when duplicate_object then null; end $$;

do $$ begin
  drop policy if exists "Public read temple translations" on public.temple_translations;
  create policy "Public read temple translations" on public.temple_translations for select
    using (exists (select 1 from public.temples t where t.id = temple_id and t.published));
exception when duplicate_object then null; end $$;
do $$ begin
  drop policy if exists "Public read temple timeline" on public.temple_timeline;
  create policy "Public read temple timeline" on public.temple_timeline for select
    using (exists (select 1 from public.temples t where t.id = temple_id and t.published));
exception when duplicate_object then null; end $$;
do $$ begin
  drop policy if exists "Public read temple locations" on public.temple_locations;
  create policy "Public read temple locations" on public.temple_locations for select
    using (exists (select 1 from public.temples t where t.id = temple_id and t.published));
exception when duplicate_object then null; end $$;
do $$ begin
  drop policy if exists "Public read location translations" on public.location_translations;
  create policy "Public read location translations" on public.location_translations for select
    using (exists (select 1 from public.temple_locations l join public.temples t on t.id = l.temple_id where l.id = location_id and t.published));
exception when duplicate_object then null; end $$;
do $$ begin
  drop policy if exists "Public read guided steps" on public.guided_steps;
  create policy "Public read guided steps" on public.guided_steps for select
    using (exists (select 1 from public.temples t where t.id = temple_id and t.published));
exception when duplicate_object then null; end $$;
do $$ begin
  drop policy if exists "Public read guided step translations" on public.guided_step_translations;
  create policy "Public read guided step translations" on public.guided_step_translations for select
    using (exists (select 1 from public.guided_steps s join public.temples t on t.id = s.temple_id where s.id = step_id and t.published));
exception when duplicate_object then null; end $$;
do $$ begin
  drop policy if exists "Public read stories" on public.stories;
  create policy "Public read stories" on public.stories for select
    using ((temple_id is not null and exists (select 1 from public.temples t where t.id = temple_id and t.published))
      or (location_id is not null and exists (select 1 from public.temple_locations l join public.temples t on t.id = l.temple_id where l.id = location_id and t.published)));
exception when duplicate_object then null; end $$;
do $$ begin
  drop policy if exists "Public read story translations" on public.story_translations;
  create policy "Public read story translations" on public.story_translations for select
    using (exists (select 1 from public.stories s where s.id = story_id and
      ((s.temple_id is not null and exists (select 1 from public.temples t where t.id = s.temple_id and t.published))
       or (s.location_id is not null and exists (select 1 from public.temple_locations l join public.temples t on t.id = l.temple_id where l.id = s.location_id and t.published)))));
exception when duplicate_object then null; end $$;
