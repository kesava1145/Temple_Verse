
-- ============================================================
-- TEMPLEVERSE — PUBLIC READ SECURITY PATCH
-- Run AFTER schema.sql, seed.sql and metadata migration.
-- ============================================================

-- 1. IMAGES: only verified images belonging to published temples.
drop policy if exists "Public read images" on public.images;

create policy "Public read verified images"
on public.images
for select
to anon, authenticated
using (
  verified = true
  and (
    exists (
      select 1
      from public.temples t
      where t.id = images.temple_id
        and t.published = true
    )
    or exists (
      select 1
      from public.temple_locations l
      join public.temples t on t.id = l.temple_id
      where l.id = images.location_id
        and t.published = true
    )
  )
);

-- 2. MEDIA: only audio associated with published content.
drop policy if exists "Public read media" on public.media;

create policy "Public read published audio"
on public.media
for select
to anon, authenticated
using (
  type = 'audio'
  and (
    exists (
      select 1
      from public.temples t
      where t.id = media.temple_id
        and t.published = true
    )
    or exists (
      select 1
      from public.temple_locations l
      join public.temples t on t.id = l.temple_id
      where l.id = media.location_id
        and t.published = true
    )
  )
);

-- 3. SOURCES: only sources linked to published temples or locations.
drop policy if exists "Public read sources" on public.sources;

create policy "Public read published sources"
on public.sources
for select
to anon, authenticated
using (
  exists (
    select 1
    from public.temple_sources ts
    join public.temples t on t.id = ts.temple_id
    where ts.source_id = sources.id
      and t.published = true
  )
  or exists (
    select 1
    from public.location_sources ls
    join public.temple_locations l on l.id = ls.location_id
    join public.temples t on t.id = l.temple_id
    where ls.source_id = sources.id
      and t.published = true
  )
);

-- 4. TEMPLE-SOURCE LINKS: only published temples.
drop policy if exists "Public read temple_sources" on public.temple_sources;

create policy "Public read published temple_sources"
on public.temple_sources
for select
to anon, authenticated
using (
  exists (
    select 1 from public.temples t
    where t.id = temple_sources.temple_id
      and t.published = true
  )
);

-- 5. LOCATION-SOURCE LINKS: only published temples.
drop policy if exists "Public read location_sources" on public.location_sources;

create policy "Public read published location_sources"
on public.location_sources
for select
to anon, authenticated
using (
  exists (
    select 1
    from public.temple_locations l
    join public.temples t on t.id = l.temple_id
    where l.id = location_sources.location_id
      and t.published = true
  )
);

-- 6. NARRATION SCRIPTS: only approved scripts for published content.
drop policy if exists "Public read narration_scripts" on public.narration_scripts;

create policy "Public read approved narration scripts"
on public.narration_scripts
for select
to anon, authenticated
using (
  approved = true
  and (
    exists (
      select 1 from public.temples t
      where t.id = narration_scripts.temple_id
        and t.published = true
    )
    or exists (
      select 1
      from public.temple_locations l
      join public.temples t on t.id = l.temple_id
      where l.id = narration_scripts.location_id
        and t.published = true
    )
    or exists (
      select 1
      from public.guided_steps s
      join public.temples t on t.id = s.temple_id
      where s.id = narration_scripts.step_id
        and t.published = true
    )
  )
);

-- 7. NARRATIONS: only audio generated from approved scripts.
drop policy if exists "Public read narrations" on public.narrations;

create policy "Public read approved narrations"
on public.narrations
for select
to anon, authenticated
using (
  exists (
    select 1
    from public.narration_scripts ns
    where ns.id = narrations.script_id
      and ns.approved = true
      and (
        exists (
          select 1 from public.temples t
          where t.id = ns.temple_id
            and t.published = true
        )
        or exists (
          select 1
          from public.temple_locations l
          join public.temples t on t.id = l.temple_id
          where l.id = ns.location_id
            and t.published = true
        )
        or exists (
          select 1
          from public.guided_steps s
          join public.temples t on t.id = s.temple_id
          where s.id = ns.step_id
            and t.published = true
        )
      )
  )
);

-- 8. OFFLINE DOWNLOADS: private bookkeeping, not public catalogue data.
drop policy if exists "Public read offline_downloads" on public.offline_downloads;

revoke all on public.offline_downloads from anon, authenticated;

-- No anonymous or authenticated write access is granted here.
-- Admin/server-side operations must use an appropriately protected role.

-- ============================================================
-- END SECURITY PATCH
-- ============================================================

-- 9. Required read privileges for the public catalogue API.
-- RLS policies above still constrain which rows are visible.
grant usage on schema public to anon, authenticated;
grant select on public.temples, public.languages, public.temple_translations,
  public.temple_timeline, public.temple_locations, public.location_translations,
  public.stories, public.story_translations, public.guided_steps,
  public.guided_step_translations, public.temple_sources, public.location_sources,
  public.sources, public.images, public.media, public.narration_scripts,
  public.narrations, public.temple_discovery_metadata
to anon, authenticated;
