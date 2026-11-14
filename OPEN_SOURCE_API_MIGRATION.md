# TempleVerse: replace Tavily + Gemini with SearXNG + Ollama

This migration keeps the existing Supabase database and Wikipedia API. It replaces:
- Tavily search -> self-hosted SearXNG
- Gemini API -> Ollama running Qwen3

## 1. Install Ollama (Windows)

1. Install Ollama from https://ollama.com/download
2. Open PowerShell and run:

```powershell
ollama pull qwen3:4b
ollama run qwen3:4b
```

Keep Ollama running. Its local API normally listens on port 11434.

## 2. Start SearXNG

Install Docker Desktop, then open PowerShell in the project root (the folder containing `docker-compose.open-source.yml`) and run:

```powershell
docker compose -f docker-compose.open-source.yml up -d
```

SearXNG is exposed locally at `http://localhost:8080`. The included `searxng/settings.yml` enables JSON output, which the discovery function requires.

Before production, replace the example `server.secret_key` in `searxng/settings.yml` with a long random value and restrict public access to the service.

## 3. Configure Supabase Edge Function secrets

For a deployed Supabase Edge Function, the function must be able to reach SearXNG and Ollama over the network. Do NOT use localhost URLs in Supabase cloud: localhost would refer to the Supabase runtime, not your laptop.

Set these secrets to reachable, secured service endpoints:

```powershell
supabase secrets set SEARXNG_URL=https://YOUR-SEARXNG-HOST
supabase secrets set OLLAMA_BASE_URL=https://YOUR-OLLAMA-HOST
supabase secrets set OLLAMA_MODEL=qwen3:4b
```

Keep the existing secrets:
- SUPABASE_URL
- SUPABASE_SERVICE_ROLE_KEY
- INGESTION_CRON_SECRET

Remove the old provider secrets if no other function uses them:
- TAVILY_API_KEY
- GEMINI_API_KEY
- GEMINI_MODEL
- GEMINI_FALLBACK_MODEL

If you are testing locally with `supabase functions serve` on Windows/Docker Desktop, set the function's local environment values to:

```env
SEARXNG_URL=http://host.docker.internal:8080
OLLAMA_BASE_URL=http://host.docker.internal:11434
OLLAMA_MODEL=qwen3:4b
```

The local function environment file is for local development only. Never commit it or put service-role/ingestion secrets in the frontend `.env`.

## 4. Deploy the updated function

From the project root:

```powershell
supabase functions deploy temple-discovery --no-verify-jwt
```

The existing `x-ingestion-secret` check remains in place.

## 5. Test provider connectivity

From PowerShell:

```powershell
Invoke-RestMethod "http://localhost:8080/search?q=Hindu+temples+Varanasi&format=json"
Invoke-RestMethod -Method Post "http://localhost:11434/api/generate" `
  -ContentType "application/json" `
  -Body '{"model":"qwen3:4b","prompt":"Return JSON with key ok and value true","stream":false,"format":"json"}'
```

## Important deployment note

The Supabase Edge Function now calls SearXNG and Ollama using server-side URLs. For a cloud-deployed function, both services must be hosted somewhere reachable from the Supabase project and protected with HTTPS/network controls. A model running only on your laptop cannot be reached by the cloud function. For a fully local development loop, run the function locally too and use `host.docker.internal` as shown above.

## What was intentionally preserved

- Existing React/Vite/Tailwind frontend
- Supabase schema, migrations, queue, and RPC calls
- Wikipedia search/summary requests
- Temple candidate validation rules
- Source associations, festival associations, Jatra associations
- Existing request authentication header and discovery/process modes

The migration changes the provider adapters and server-side configuration; it does not change the frontend API contract.
