#!/bin/sh
# Loads the sample tasks as hashes (task:<id>) plus a set of all ids. Safe to run more than once.
set -eu

cli() { valkey-cli -h valkey "$@"; }

cli HSET task:1 name "Task 1" description "Description of Task 1" completed 0 priority 2 due_date 2023-07-29 > /dev/null
cli HSET task:2 name "Task 2" description "Description of Task 2" completed 1 priority 1 due_date 2023-07-30 > /dev/null
cli HSET task:3 name "Task 3" description "Description of Task 3" completed 0 priority 3 due_date 2023-07-31 > /dev/null
cli SADD tasks 1 2 3 > /dev/null

echo "Sample data inserted successfully."

# Report healthy and stay up (see compose.yaml).
touch /tmp/seeded
exec sleep infinity
