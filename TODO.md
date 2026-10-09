# TODO

Open tasks for the repository. See also [Known issues](README.md#known-issues).

## 1. Original state

- [x] Tag the state from September 2023 as `v1.0.0`

## 2. Modernisation (v2.0.0)

- [x] Replace `docker-compose.dev.yml` and the one-line Dockerfiles with `compose.yaml` and pinned images
- [x] Fix the missing pgAdmin Dockerfile, which made `build` fail on a fresh clone
- [x] Grant the MariaDB user access to `task_db` (`MARIADB_DATABASE`)
- [x] Use one database name (`task_db`) in MongoDB, too
- [x] Healthchecks, named volumes, default network (no `docker network create`), profiles
- [x] Preconfigure pgAdmin with the PostgreSQL server
- [x] Move defaults into `compose.yaml`, ship `.env.example`, stop tracking `.env`
- [x] Add Valkey + RedisInsight, Neo4j and Qdrant with the same sample data
- [x] Smoke test script and CI workflow
- [ ] Check that RedisInsight lists the `valkey` connection after the EULA dialog (needs accepting the EULA once)
- [x] Watch the first CI run on GitHub (green)
- [x] Tag `v2.0.0`
- [ ] Create GitHub releases for `v1.0.0` and `v2.0.0`

## 3. Before publishing

- [x] Add the MIT license
- [x] Credit third parties (image licenses in the README)
- [x] Check for secrets in the files and the git history (only local default passwords)
- [x] Rewrite the old university e-mail address in the 2023 commits
- [ ] Add a repository description and topics on GitHub
- [ ] Delete the local v1 data folders (`*/mysql-data`, `*/postgres-data`, `*/pgadmin-data`, `*/mongodb-data`) once no longer needed
