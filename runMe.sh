#!/usr/bin/env bash
set -euo pipefail

docker compose up -d --build

APP_URL="${APP_URL:-http://localhost:3300/admin}"

if command -v open >/dev/null 2>&1; then
  open "$APP_URL"
elif command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$APP_URL"
else
  echo "Docker started. Open this URL manually: $APP_URL"
fi
