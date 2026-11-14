#!/bin/bash
URL="https://yqdbmyvxidwnlzsymcrc.supabase.co/functions/v1/temple-discovery"
ROUNDS="${1:-10}"

if [ -z "$INGESTION_SECRET" ]; then
  echo "Set INGESTION_SECRET first, e.g. INGESTION_SECRET=abc ./run-discovery.sh"
  exit 1
fi

call() {
  curl -s -X POST "$URL" \
    -H "x-ingestion-secret: $INGESTION_SECRET" \
    -H "Content-Type: application/json" \
    -d "$1"
  echo
}

echo "== discover =="
call '{"mode":"discover"}'

for i in $(seq 1 "$ROUNDS"); do
  echo "== process $i/$ROUNDS =="
  call '{"mode":"process"}'
  sleep 5
done
