#!/usr/bin/env bash

# Update all Docker Compose projects in subfolders
# - Detects docker compose vs docker-compose
# - Pulls latest images and restarts services
# - Skips gracefully if .env is missing (when required)

set -uo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect compose command
if docker compose version >/dev/null 2>&1; then
  COMPOSE_CMD=(docker compose)
elif docker-compose version >/dev/null 2>&1; then
  COMPOSE_CMD=(docker-compose)
else
  echo "[ERROR] Docker Compose is not installed (docker compose/docker-compose)" >&2
  exit 1
fi

echo "Using Compose command: ${COMPOSE_CMD[*]}"

update_project() {
  local dir=$1
  echo "\n==> Updating: ${dir}"

  pushd "$dir" >/dev/null || { echo "[WARN] Cannot enter $dir"; return 1; }

  # Validate compose file
  if ! "${COMPOSE_CMD[@]}" config >/dev/null 2>&1; then
    echo "[WARN] Invalid compose config in $dir — skipping"
    popd >/dev/null
    return 1
  fi

  # Warn if env_file likely required but missing
  if grep -qE "^\s*env_file:\s*$" docker-compose.yml 2>/dev/null || \
     grep -qE "^\s*-\s*\.env\s*$" docker-compose.yml 2>/dev/null; then
    if [ ! -f .env ]; then
      echo "[WARN] .env is missing in $dir (copy .env.example -> .env)"
    fi
  fi

  # Pull and restart
  "${COMPOSE_CMD[@]}" pull || echo "[WARN] Pull failed in $dir, continuing"
  "${COMPOSE_CMD[@]}" up -d --remove-orphans || {
    echo "[ERROR] Failed to start services in $dir"
    popd >/dev/null
    return 1
  }

  # Optional cleanup of dangling images (non-fatal)
  docker image prune -f >/dev/null 2>&1 || true

  echo "[OK] Updated: ${dir}"
  popd >/dev/null
}

# Find compose files in first-level subdirectories and root
mapfile -d '' compose_files < <(find "$ROOT_DIR" -maxdepth 2 -type f -name 'docker-compose.yml' -print0)

if [ ${#compose_files[@]} -eq 0 ]; then
  echo "No docker-compose.yml found under $ROOT_DIR"
  exit 0
fi

for file in "${compose_files[@]}"; do
  dir="$(dirname "$file")"
  update_project "$dir"
done

echo "\nAll done."