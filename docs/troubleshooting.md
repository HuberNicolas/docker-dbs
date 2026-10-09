# Troubleshooting

## A port is already in use

`docker compose up` fails with `Bind for 0.0.0.0:<port> failed: port is already allocated`.

Find out what uses the port (macOS and Linux):

```bash
lsof -i :5433
```

Then either stop the other program, or move this setup to another port in `.env`, for example `POSTGRES_PORT=5434`.
All host ports are listed in [`.env.example`](../.env.example).

## Changed passwords have no effect, or the sample data is missing

The databases read users, passwords and init scripts only when their volume is empty. Delete the volumes and start
again:

```bash
docker compose --profile all down -v
```

```bash
docker compose --profile all up -d --wait
```

To reset only one database, remove its volume, for example:

```bash
docker compose rm -sf postgres pgadmin
```

```bash
docker volume rm docker-dbs_postgres-data docker-dbs_pgadmin-data
```

## A service does not become healthy

`docker compose up --wait` stops with an error when a container is unhealthy. Look at its logs:

```bash
docker compose logs neo4j
```

Neo4j needs 10 to 20 seconds on first start. On machines with little memory for Docker (Docker Desktop:
*Settings → Resources*), start only the profiles you need.

## A seed container failed

`valkey-seed`, `neo4j-seed` and `qdrant-seed` load the data, then stay up and report `healthy`. If one exited
instead, the seed script failed. Check the status and output:

```bash
docker compose --profile all ps -a
```

```bash
docker compose logs qdrant-seed
```

They can be run again at any time, without creating duplicates:

```bash
docker compose --profile all up -d --force-recreate --wait qdrant-seed
```

## Data from v1 (2023)

Version 1 stored the data in folders inside the repository (`mariadb/mysql-data`, `postgres/postgres-data`,
`postgres/pgadmin/pgadmin-data`, `mongodb/mongodb-data`). Version 2 uses named Docker volumes and ignores these
folders. They are still in `.gitignore`; delete them once you no longer need them.

## `docker compose down` leaves the containers running

Every service belongs to a profile, and Compose only acts on services of active profiles. Pass the profile (or set
`COMPOSE_PROFILES` in `.env`):

```bash
docker compose --profile all down
```
