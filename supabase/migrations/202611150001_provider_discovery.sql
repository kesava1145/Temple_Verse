
-- TempleVerse provider-backed discovery and controlled auto-publication.
-- Safe to run once; all DDL is idempotent.
alter table public.temples
  add column if not exists google_place_id text,
  add column if not exists discovery_status text not null default 'legacy'
    check (discovery_status in ('legacy','auto_published','needs_review')),
  add column if not exists discovery_sources jsonb not null default '[]'::jsonb;

create unique index if not exists temples_google_place_id_uidx
  on public.temples(google_place_id) where google_place_id is not null;

create table if not exists public.discovery_region_queue (
  id uuid primary key default gen_random_uuid(),
  region_name text not null unique,
  state_name text,
  priority integer not null default 100,
  enabled boolean not null default true,
  completed_at timestamptz,
  created_at timestamptz not null default now()
);

insert into public.discovery_region_queue(region_name,state_name,priority)
values
 ('Varanasi, Uttar Pradesh','Uttar Pradesh',1),
 ('Ayodhya, Uttar Pradesh','Uttar Pradesh',2),
 ('Mathura and Vrindavan, Uttar Pradesh','Uttar Pradesh',3),
 ('Haridwar and Rishikesh, Uttarakhand','Uttarakhand',4),
 ('Tirupati, Andhra Pradesh','Andhra Pradesh',5),
 ('Srisailam, Andhra Pradesh','Andhra Pradesh',6),
 ('Madurai, Tamil Nadu','Tamil Nadu',7),
 ('Thanjavur, Tamil Nadu','Tamil Nadu',8),
 ('Rameswaram, Tamil Nadu','Tamil Nadu',9),
 ('Kanchipuram, Tamil Nadu','Tamil Nadu',10),
 ('Chidambaram, Tamil Nadu','Tamil Nadu',11),
 ('Puri, Odisha','Odisha',12),
 ('Konark, Odisha','Odisha',13),
 ('Bhubaneswar, Odisha','Odisha',14),
 ('Dwarka and Somnath, Gujarat','Gujarat',15),
 ('Ujjain and Omkareshwar, Madhya Pradesh','Madhya Pradesh',16),
 ('Nashik and Trimbakeshwar, Maharashtra','Maharashtra',17),
 ('Shirdi, Maharashtra','Maharashtra',18),
 ('Amritsar, Punjab','Punjab',19),
 ('Kolkata and Dakshineswar, West Bengal','West Bengal',20),
 ('Kamakhya, Assam','Assam',21),
 ('Hampi, Karnataka','Karnataka',22),
 ('Mysuru, Karnataka','Karnataka',23),
 ('Guruvayur and Sabarimala, Kerala','Kerala',24),
 ('Kochi and Thiruvananthapuram, Kerala','Kerala',25),
 ('Bodh Gaya, Bihar','Bihar',26),
 ('Rajgir and Nalanda, Bihar','Bihar',27),
 ('Pushkar and Ajmer, Rajasthan','Rajasthan',28),
 ('Mount Abu, Rajasthan','Rajasthan',29),
 ('Delhi major temples','Delhi',30)
on conflict(region_name) do nothing;

create index if not exists discovery_region_queue_priority_idx
  on public.discovery_region_queue(enabled, priority, completed_at);

comment on column public.temples.google_place_id is
  'Google Places identifier used for idempotent discovery and duplicate prevention.';
comment on column public.temples.discovery_sources is
  'URLs and provider references used by the automated discovery pipeline.';
