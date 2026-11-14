# TempleVerse provider-backed discovery

## What is integrated

- Supabase PostgreSQL and Edge Functions.
- Google Places (optional, not used) (New) for temple/place discovery and coordinates.
- Wikipedia MediaWiki search + REST summary APIs for encyclopedic context.
- Tavily Search API for additional web sources.
- Gemini API for structured metadata extraction and translation drafts.
- No admin dashboard is required.

## Existing database

Your current Supabase project already has the original schema, seed, metadata ingestion migration, content backfill, security patch and Jatra/search migration. Run this new migration exactly once:

`supabase/migrations/202611150001_provider_discovery.sql`

It adds Google Place identifiers, discovery status/provenance and a prioritized region queue. It does not delete or replace existing temple records.

## Fresh database install

For a genuinely empty Supabase project, apply in this order:

1. `supabase/schema.sql`
2. `supabase/seed.sql`
3. `supabase/migrations/202611130001_temple_metadata_and_ingestion.sql`
4. `supabase/migrations/202611130002_content_backfill.sql`
5. `supabase/security_patch.sql`
6. `supabase/migrations/202611140001_jatras_search_metadata.sql`
7. `supabase/migrations/202611150001_provider_discovery.sql`

Do not rerun the seed on a populated database.

## Frontend environment

Copy `.env.example` to `.env` and set only:

```env
VITE_SUPABASE_URL=https://YOUR_PROJECT_REF.supabase.co
VITE_SUPABASE_ANON_KEY=YOUR_SUPABASE_PUBLISHABLE_KEY
```

Do not put provider secrets or the Supabase service-role key in `.env` or any `VITE_` variable.

## Supabase Edge Function secrets

In Supabase Dashboard → Edge Functions → Secrets, configure:

- `(unused: Google Places not configured)`
- `TAVILY_API_KEY`
- `GEMINI_API_KEY`
- `INGESTION_CRON_SECRET` (a long random value)

Optional:
- `GEMINI_MODEL=gemini-2.5-flash`

Supabase provides `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` to deployed Edge Functions. Never expose the service-role key to the browser.

## Deploy

Install the Supabase CLI, sign in and link the local project:

```bash
supabase login
supabase link --project-ref YOUR_PROJECT_REF
supabase functions deploy temple-discovery
supabase functions deploy translation-drafts
```

Then set the secrets:

```bash
supabase secrets set (unused: Google Places not configured)="..."
supabase secrets set TAVILY_API_KEY="..."
supabase secrets set GEMINI_API_KEY="..."
supabase secrets set INGESTION_CRON_SECRET="..."
supabase secrets set GEMINI_MODEL="gemini-2.5-flash"
```

## Run discovery

Invoke from a trusted local terminal (PowerShell example):

```powershell
$headers = @{
  "Content-Type" = "application/json"
  "x-ingestion-secret" = "YOUR_INGESTION_CRON_SECRET"
}
$body = @{ region = "Varanasi, Uttar Pradesh"; limit = 8 } | ConvertTo-Json
Invoke-RestMethod `
  -Method Post `
  -Uri "https://YOUR_PROJECT_REF.supabase.co/functions/v1/temple-discovery" `
  -Headers $headers `
  -Body $body
```

Omit `region` to process the next enabled region by priority. The queue begins with major pilgrimage/heritage destinations and can be expanded by adding rows to `discovery_region_queue`.

## Automatic publication rules

The function:
1. Searches Google Places for a limited batch of temples in one region.
2. Searches Wikipedia and Tavily for each place.
3. Sends source material plus the Google Place identity to Gemini.
4. Requires a temple identity, at least two independent textual sources, confidence ≥ 0.78, and no unresolved conflicts before auto-publishing.
5. Stores weaker or conflicting results in `temple_candidates` with `needs_research`.
6. Prevents repeat insertion using the unique Google Place ID.
7. Stores source URLs and extracted evidence in database provenance fields.
8. Adds supported recurring festival associations without inventing year-specific event dates.
9. Stores Jatra associations as pending until reliable verification is available. Pending Jatras are not presented as verified.

This is automated publishing with conservative quality gates, not a guarantee that every model extraction is correct. Review `ingestion_runs`, `temple_candidates`, and source provenance directly in Supabase when debugging.

## Region expansion

The initial queue prioritizes major destinations across multiple states. Process regions in small batches to control Google Places/Tavily/Gemini usage. A region is marked processed after a run; it can be re-enabled or additional region rows can be inserted in SQL.

Example:

```sql
insert into public.discovery_region_queue(region_name,state_name,priority)
values ('Khajuraho, Madhya Pradesh','Madhya Pradesh',31)
on conflict (region_name) do update set enabled = true;
```

## Cost and quota controls

- Google Places (optional, not used) is billed by the selected field mask and usage; enable billing and restrict the API key to Places API.
- Tavily and Gemini have plan quotas/rate limits; start with `limit: 3` or `limit: 5`.
- Wikipedia's public APIs have usage policies; requests include a descriptive User-Agent.
- Run one region at a time; do not schedule aggressive crawls until you have reviewed cost and data quality.
- Keep all keys server-side in Supabase secrets.

## Important data rules

- No fabricated dates, measurements, deity names, routes or historical claims.
- Festival associations and year-specific festival events are separate. No event date is created unless explicitly supported.
- Jatra and festival remain distinct entities.
- Religious tradition is labelled separately from documented history.
- Images are not automatically copied from search results; copyright/attribution must be checked.
- Video is intentionally unsupported.
