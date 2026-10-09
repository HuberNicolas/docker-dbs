#!/bin/sh
# Runs seed.cypher against the neo4j service, then reports healthy and stays up (see compose.yaml).
set -eu

cypher-shell -a neo4j://neo4j:7687 -u neo4j -f /seed/seed.cypher
echo "Sample data inserted successfully."

touch /tmp/seeded
exec sleep infinity
