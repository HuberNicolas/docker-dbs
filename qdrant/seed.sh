#!/bin/sh
# Creates the `tasks` collection with 4-dimensional toy vectors and the task fields as payload.
# Safe to run more than once: the collection is only created if it is missing, points are upserted.
set -eu

api() {
  curl -sS --fail-with-body -H "api-key: ${QDRANT_API_KEY}" -H "Content-Type: application/json" "$@"
}

URL=http://qdrant:6333

if ! api "$URL/collections/tasks/exists" | grep -q '"exists":true'; then
  api -X PUT "$URL/collections/tasks" -d '{"vectors": {"size": 4, "distance": "Cosine"}}' > /dev/null
fi

api -X PUT "$URL/collections/tasks/points?wait=true" -d '{
  "points": [
    {"id": 1, "vector": [0.9, 0.1, 0.1, 0.2],
     "payload": {"name": "Task 1", "description": "Description of Task 1", "completed": false, "priority": 2, "due_date": "2023-07-29"}},
    {"id": 2, "vector": [0.1, 0.9, 0.2, 0.1],
     "payload": {"name": "Task 2", "description": "Description of Task 2", "completed": true, "priority": 1, "due_date": "2023-07-30"}},
    {"id": 3, "vector": [0.8, 0.2, 0.3, 0.1],
     "payload": {"name": "Task 3", "description": "Description of Task 3", "completed": false, "priority": 3, "due_date": "2023-07-31"}}
  ]
}' > /dev/null

echo "Sample data inserted successfully."

# Report healthy and stay up (see compose.yaml).
touch /tmp/seeded
exec sleep infinity
