#!/usr/bin/env bash
# Checks every running database for the three sample tasks and every running web UI for an HTTP answer.
# Run it from the repository root after `docker compose --profile <name> up -d --wait`.
set -euo pipefail

cd "$(dirname "$0")/.."

compose() { docker compose --profile all "$@"; }

running=$(compose ps --services --status running)
failures=0
checked=0

is_running() { grep -qx "$1" <<< "$running"; }

expect() {
  local name=$1 expected=$2 actual=$3
  checked=$((checked + 1))
  if [[ "$actual" == "$expected" ]]; then
    printf '  ok    %-14s %s\n' "$name" "$actual"
  else
    printf '  FAIL  %-14s expected %s, got %s\n' "$name" "$expected" "${actual:-<nothing>}"
    failures=$((failures + 1))
  fi
}

# Runs a shell command inside a service container, so the container's own environment provides the credentials.
in_container() { compose exec -T "$1" sh -c "$2" 2> /dev/null | tr -d '\r' | tail -n 1 || true; }

echo "Sample data (expected: 3 tasks per database)"

if is_running mariadb; then
  expect mariadb 3 "$(in_container mariadb \
    'mariadb -u"$MARIADB_USER" -p"$MARIADB_PASSWORD" -N -e "SELECT COUNT(*) FROM task_db.tasks"')"
fi

if is_running postgres; then
  expect postgres 3 "$(in_container postgres \
    'psql -U "$POSTGRES_USER" -d task_db -tAc "SELECT count(*) FROM tasks"')"
fi

if is_running mongodb; then
  expect mongodb 3 "$(in_container mongodb \
    'mongosh -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" --quiet \
       --eval "db.getSiblingDB(\"task_db\").tasks.countDocuments()"')"
fi

if is_running valkey; then
  expect valkey 3 "$(in_container valkey 'valkey-cli SCARD tasks')"
fi

if is_running neo4j; then
  expect neo4j 3 "$(in_container neo4j \
    'cypher-shell -u neo4j -p "${NEO4J_AUTH#neo4j/}" --format plain "MATCH (t:Task) RETURN count(t)"')"
fi

if is_running qdrant; then
  # The Qdrant image has no HTTP client, so the curl image of the seed service asks instead.
  count=$(compose run --rm --no-deps -T --entrypoint sh qdrant-seed -c \
    'curl -sS -X POST -H "api-key: $QDRANT_API_KEY" -H "Content-Type: application/json" \
       -d "{\"exact\": true}" http://qdrant:6333/collections/tasks/points/count' 2> /dev/null \
    | sed -n 's/.*"count":\([0-9]*\).*/\1/p' || true)
  expect qdrant 3 "$count"
fi

echo "Web UIs (HTTP status on localhost)"

# service, container port, path, expected status
ui_checks=(
  "phpmyadmin 80 / 200"
  "pgadmin 80 /misc/ping 200"
  "mongo-express 8081 / 401"
  "redisinsight 5540 / 200"
  "neo4j 7474 /browser/ 200"
  "qdrant 6333 /dashboard/ 200"
)

for check in "${ui_checks[@]}"; do
  read -r service port path status <<< "$check"
  if is_running "$service"; then
    host_port=$(compose port "$service" "$port" | sed 's/.*://')
    code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 10 --retry 10 --retry-delay 2 --retry-all-errors \
      "http://localhost:${host_port}${path}" || true)
    expect "$service" "$status" "$code"
  fi
done

if [[ $checked -eq 0 ]]; then
  echo "Nothing is running. Start a profile first, for example: docker compose --profile all up -d --wait"
  exit 1
fi

if [[ $failures -gt 0 ]]; then
  echo "$failures of $checked checks failed."
  exit 1
fi
echo "All $checked checks passed."
