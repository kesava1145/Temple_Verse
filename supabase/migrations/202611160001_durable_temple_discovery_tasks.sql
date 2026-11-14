-- TempleVerse durable discovery task queue.
-- Apply once in Supabase SQL Editor before deploying the updated Edge Function.

create table if not exists public.temple_discovery_tasks (
  id uuid primary key default gen_random_uuid(),
  region_name text not null,
  candidate_name text not null,
  candidate_slug text not null,
  city text,
  state text,
  discovery_source_urls jsonb not null default '[]'::jsonb,
  status text not null default 'queued' check (status in ('queued','processing','completed','held','failed')),
  attempts integer not null default 0,
  locked_at timestamptz,
  temple_id uuid,
  extracted_metadata jsonb,
  last_error text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint temple_discovery_tasks_region_candidate_unique unique (region_name, candidate_slug)
);

create index if not exists temple_discovery_tasks_status_created_idx
  on public.temple_discovery_tasks (status, created_at);

alter table public.temple_discovery_tasks enable row level security;
revoke all on public.temple_discovery_tasks from anon, authenticated;
grant all on public.temple_discovery_tasks to service_role;

-- Atomically claim one task. A task left processing for >5 minutes is recoverable
-- after an Edge Function timeout or runtime shutdown.
create or replace function public.claim_temple_discovery_task()
returns setof public.temple_discovery_tasks
language sql
security definer
set search_path = public
as $$
  update public.temple_discovery_tasks as task
  set status = 'processing',
      attempts = task.attempts + 1,
      locked_at = now(),
      updated_at = now()
  where task.id = (
    select candidate.id
    from public.temple_discovery_tasks as candidate
    where candidate.attempts < 3
      and (
        candidate.status = 'queued'
        or (candidate.status = 'processing' and candidate.locked_at < now() - interval '5 minutes')
      )
    order by candidate.created_at
    for update skip locked
    limit 1
  )
  returning task.*;
$$;

revoke all on function public.claim_temple_discovery_task() from public, anon, authenticated;
grant execute on function public.claim_temple_discovery_task() to service_role;
