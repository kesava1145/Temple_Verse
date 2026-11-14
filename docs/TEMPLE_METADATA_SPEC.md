# TempleVerse temple metadata contract

The catalogue is unbounded: the five rows in the starter seed are examples only. A temple is a database record, not a React component or a hardcoded enum. `temples.metadata` stores the extensible, sectioned metadata payload; fields used for filtering, joins and integrity are also represented in dedicated relational tables/columns.

## Canonical metadata sections

The `metadata` JSONB object uses these stable section keys. Unknown values should be omitted or `null`; do not guess.

```json
{
  "identity": {
    "alternate_names": [], "local_language_name": null,
    "temple_category": null, "religious_tradition": null,
    "principal_deity": null, "secondary_deities": [],
    "temple_status": null, "management_organization": null
  },
  "geography": {
    "country": "India", "state": null, "district": null,
    "city_or_village": null, "postal_code": null,
    "latitude": null, "longitude": null, "elevation_m": null,
    "terrain_type": null, "nearby_river": null,
    "nearby_mountains": null, "nearest_city_distance_km": null
  },
  "history": {
    "earliest_known_reference": null, "foundation_date": null,
    "historical_period": null, "original_dynasty": null,
    "major_ruling_dynasties": [], "patron_kings": [],
    "renovation_dates": [], "expansion_phases": [],
    "historical_inscriptions": [], "copper_plate_records": [],
    "historical_donations": [], "damage_events": [],
    "reconstruction_history": [], "archaeological_significance": null
  },
  "architecture": {
    "architectural_style": null, "main_sanctum_type": null,
    "garbhagriha_structure": null, "vimana_type": null,
    "gopuram_count": null, "gopuram_height_m": null,
    "prakara_count": null, "mandapam_count": null,
    "pillar_count": null, "pillar_material": null,
    "pillar_carving_style": null, "wall_material": null,
    "roof_material": null, "sculptural_themes": [],
    "temple_layout": null, "orientation": null,
    "dimensions": {}, "sacred_tank": null,
    "flagstaff": null, "decorative_motifs": []
  },
  "religious": {
    "deity_form": null, "deity_posture": null,
    "deity_attributes": [], "consort_deity": null,
    "associated_divine_figures": [], "agama_tradition": null,
    "worship_tradition": null, "daily_puja_sequence": [],
    "special_sevas": [], "sacred_symbols": [],
    "sacred_offerings": [], "prasadam_types": [],
    "religious_significance": null, "pilgrimage_importance": null
  },
  "mythology": {
    "origin_legend": null, "deity_legend": null,
    "founding_story": null, "associated_puranas": [],
    "sacred_events": [], "divine_marriage_stories": [],
    "local_folklore": [], "sacred_place_names": [],
    "associated_sages": []
  },
  "festivals": {
    "major_annual_festivals": [], "festival_calendar": [],
    "festival_duration": null, "procession_traditions": [],
    "chariot_festival": null, "music_traditions": [],
    "dance_traditions": [], "traditional_dress": [],
    "ritual_decorations": [], "local_cultural_events": [],
    "festival_specific_offerings": [], "regional_customs": []
  },
  "media": {
    "cover_image": null, "gallery_images": [],
    "image_captions": [], "image_licenses": [],
    "image_sources": [], "image_resolution": [],
    "views_360": [], "audio_guides": [],
    "virtual_tour_available": false,
    "official_website": null, "social_media_links": []
  },
  "conservation": {
    "protected_monument_status": null, "heritage_designation": [],
    "conservation_organization": null, "structural_condition": null,
    "restoration_projects": [], "inscription_inventory": [],
    "sculpture_inventory": [], "research_publications": [],
    "source_reliability": null, "last_verification_date": null
  }
}
```

Video URLs are intentionally excluded from the product. Media support is images and audio only.

## Evidence rules

- Every collected factual claim should be stored as a `temple_claims` row and linked to one or more `sources` through `claim_sources`.
- Record the source URL, source type, retrieval time and a short evidence note.
- Distinguish documented history (`fact` / `historical_claim`) from religious and oral traditions (`religious_tradition`).
- A confidence score is a review aid, not proof. Do not publish claims solely because an AI model is confident.
- Conflicts should remain `disputed` or `needs_review` until a human resolves them.
- Missing information stays null/empty; do not infer exact dates, measurements, licenses or ritual details.
- Image URLs require rights/license review before public display. Attribution alone does not establish permission.

## Ingestion lifecycle

`ingestion_runs` records a discovery/extraction run. Each discovered temple is first stored in `temple_candidates` with its source URL and extracted draft metadata. Duplicate detection should compare normalized names, alternate names, coordinates and source evidence. Reviewers approve or reject candidates. Approved candidates are promoted into `temples` and related tables; `published` becomes true only after required claims and media rights have passed review.

The migration creates the database foundation and private queues. It does not start a crawler by itself. A trusted server-side worker or Supabase Edge Function must be implemented and deployed separately. Never expose the Supabase service-role key in the Vite client.
