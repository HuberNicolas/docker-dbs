# Databases

Each database holds the same three tasks (see [Sample data](../README.md#sample-data)). This page shows how each one
stores them and how to ask the same question in each: *which open tasks are there, ordered by priority?*

All commands use the default credentials and run inside the containers, so you need no local clients. Start the
profile first, for example `docker compose --profile mariadb up -d --wait`.

- [MariaDB](#mariadb)
- [PostgreSQL](#postgresql)
- [MongoDB](#mongodb)
- [Valkey](#valkey)
- [Neo4j](#neo4j)
- [Qdrant](#qdrant)

## MariaDB

Relational. Table `task_db.tasks`, created by [`mariadb/init/01-tasks.sql`](../mariadb/init/01-tasks.sql). The image
creates the database `task_db` and gives `mariadb-user` full rights on it.

```bash
docker compose exec mariadb mariadb -u mariadb-user -pmariadb-user-pw task_db
```

```sql
SELECT name, priority FROM tasks WHERE completed = FALSE ORDER BY priority;
```

Web UI: phpMyAdmin at <http://localhost:8081>, server is preset to `mariadb`.

## PostgreSQL

Relational. Table `tasks` in the database `task_db`, created by
[`postgres/init/01-tasks.sql`](../postgres/init/01-tasks.sql).

```bash
docker compose exec postgres psql -U postgres-user -d task_db
```

```sql
SELECT name, priority FROM tasks WHERE NOT completed ORDER BY priority;
```

Web UI: pgAdmin at <http://localhost:5051>. The server `docker-dbs` comes from
[`postgres/pgadmin/servers.json`](../postgres/pgadmin/servers.json); pgAdmin asks for the password
(`postgres-user-pw`) on first connect and can save it.

## MongoDB

Document store. Collection `tasks` in the database `task_db`, created by
[`mongodb/init/01-tasks.js`](../mongodb/init/01-tasks.js). The root user lives in the `admin` database, so clients
need `authSource=admin`.

```bash
docker compose exec mongodb mongosh -u mongodb-root -p mongodb-root-pw --authenticationDatabase admin task_db
```

```javascript
db.tasks.find({ completed: false }, { _id: 0, name: 1, priority: 1 }).sort({ priority: 1 })
```

Connection string from your machine:
`mongodb://mongodb-root:mongodb-root-pw@localhost:27018/task_db?authSource=admin`

Web UI: Mongo Express at <http://localhost:8082> (basic auth `mongo-express-user` / `mongo-express-user-pw`).

## Valkey

Key-value store, compatible with Redis. Each task is a hash `task:<id>`; the set `tasks` holds all ids. Loaded by
[`valkey/seed.sh`](../valkey/seed.sh). Valkey has no query language, so filtering happens in the client.

```bash
docker compose exec valkey valkey-cli -a valkey-pw
```

```text
SMEMBERS tasks
HGETALL task:1
HGET task:3 priority
```

Booleans are stored as `0` and `1`, because hash values are strings.

Web UI: RedisInsight at <http://localhost:5540>. See [Known issues](../README.md#known-issues).

## Neo4j

Graph database. Each task is a `(:Task)` node with an `id` property (unique constraint). One relationship shows
what a graph adds: `Task 1` `BLOCKS` `Task 3`. Loaded by [`neo4j/seed.cypher`](../neo4j/seed.cypher).

```bash
docker compose exec neo4j cypher-shell -u neo4j -p neo4j-user-pw
```

```cypher
MATCH (t:Task {completed: false}) RETURN t.name, t.priority ORDER BY t.priority;
MATCH (a:Task)-[:BLOCKS]->(b:Task) RETURN a.name, b.name;
```

Web UI: Neo4j Browser at <http://localhost:7474>. Connect to `neo4j://localhost:7687` with `neo4j` /
`neo4j-user-pw`.

## Qdrant

Vector database. Collection `tasks` with 4-dimensional toy vectors (cosine distance) and the task fields as payload.
Loaded by [`qdrant/seed.sh`](../qdrant/seed.sh). The vectors are made up; Task 1 and Task 3 point in a similar
direction, Task 2 does not.

Open tasks, filtered by payload:

```bash
curl -s -X POST http://localhost:6333/collections/tasks/points/scroll -H 'api-key: qdrant-api-key' -H 'Content-Type: application/json' -d '{"filter": {"must": [{"key": "completed", "match": {"value": false}}]}, "with_payload": ["name"]}'
```

The two tasks most similar to a vector:

```bash
curl -s -X POST http://localhost:6333/collections/tasks/points/query -H 'api-key: qdrant-api-key' -H 'Content-Type: application/json' -d '{"query": [0.9, 0.1, 0.1, 0.2], "limit": 2, "with_payload": ["name"]}'
```

Web UI: the Qdrant dashboard at <http://localhost:6333/dashboard>. It asks for the API key (`qdrant-api-key`).
