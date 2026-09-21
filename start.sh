#!/usr/bin/env bash
# Avvia il server dei contenuti statici (ynsera-info) e il sito Next.js (ynsera-website)
set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATIC_DIR="$ROOT_DIR/ynsera-info/static"
WEBSITE_DIR="$ROOT_DIR/ynsera-website"
STATIC_PORT=4000

cleanup() {
  echo "Arresto server contenuti statici..."
  kill "$STATIC_PID" 2>/dev/null || true
}
trap cleanup EXIT

echo "Avvio server contenuti statici su http://localhost:$STATIC_PORT ..."
npx --yes serve "$STATIC_DIR" -l "$STATIC_PORT" --cors &
STATIC_PID=$!

export NEXT_PUBLIC_STATIC_BASE="http://localhost:$STATIC_PORT"

if [ ! -d "$WEBSITE_DIR/node_modules" ]; then
  echo "Installazione dipendenze del sito..."
  (cd "$WEBSITE_DIR" && npm install)
fi

echo "Avvio sito su http://localhost:3001 ..."
(cd "$WEBSITE_DIR" && npm run dev)
