# TempleVerse UI + backend integration

## Source merge

- UI foundation: the separately supplied UI ZIP.
- Backend foundation: the current TempleVerse backend ZIP.
- Existing Supabase migrations and services are retained from the backend project.
- UI components, page layouts, styles, and supplied image assets are overlaid from the UI ZIP.
- The UI ZIP's older `templeService.js`, `templeConnections.js`, `translationService.js`, and `supabase/schema.sql` are intentionally not used because they would replace newer backend behaviour or reintroduce video fields.

## Added integration

- `/jatras` route and navigation entry for verified Jatra records.
- Jatra page reads only verified Jatras and verified year-specific events.
- Jatra translations are loaded through `jatra_translations` and `languages`.
- Temple Explorer retains the supplied UI and now exposes metadata facets: deity, architecture, dynasty, festival, Jatra, category, and religious tradition.
- Search and facets call the backend `search_temples` and `get_temple_filter_options` RPCs when Supabase is configured.
- Connections page uses the metadata-driven backend connection service.

## Setup

1. Copy your own `.env` into this project root. Never commit or share it.
2. Run `npm ci` (or `npm install`) and `npm run build`.
3. Keep your existing Supabase migrations; do not rerun migrations already applied.
4. The Jatra catalogue intentionally shows an empty state until source-backed Jatra records are reviewed and marked `verified`.
5. Do not add unverified annual event dates. Add a `jatra_events` row only when a year-specific source supports it.

## Verification limitation

The source merge was checked for missing local relative imports. A production Vite build could not be run in this environment because dependency installation did not complete. Run the build locally and share any compiler output for follow-up fixes.


## UI consistency and temple traditions update

- Removed the standalone Jatras navigation item and `/jatras` route.
- Festivals and Jatras are rendered inside each temple detail page as temple-specific information.
- Temple catalogue fetch now attaches approved temple-festival and temple-Jatra associations, translations, and verified year-specific event records.
- The homepage warm parchment / burgundy / muted green heritage palette is applied consistently to the Explorer, Connections, navigation, cards, and shared content surfaces.
- Improved text contrast on Explorer and Connections backgrounds.
- Jatras and festivals without verified records remain absent rather than showing invented dates.
