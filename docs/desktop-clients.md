# Desktop clients

Every database publishes its port on `localhost`, so any desktop client can connect. The values below are the
defaults from [`.env.example`](../.env.example).

| Database | Host | Port | User | Password | Database | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| MariaDB | `localhost` | `3307` | `mariadb-user` (or `root`) | `mariadb-user-pw` (root: `mariadb-root-pw`) | `task_db` | |
| PostgreSQL | `localhost` | `5433` | `postgres-user` | `postgres-user-pw` | `task_db` | |
| MongoDB | `localhost` | `27018` | `mongodb-root` | `mongodb-root-pw` | `task_db` | Authentication database `admin` |
| Valkey | `localhost` | `6380` | `default` | `valkey-pw` | `0` | Any Redis client works |
| Neo4j | `localhost` | `7687` (Bolt) | `neo4j` | `neo4j-user-pw` | `neo4j` | |
| Qdrant | `localhost` | `6333` (REST) | | API key `qdrant-api-key` | | |

The ports differ from the database defaults (3306, 5432, 27017, 6379), so they do not clash with a database that is
already installed on your machine. Neo4j and Qdrant use their default ports; change `NEO4J_*_PORT` or `QDRANT_PORT`
in `.env` if they are taken.

## DataGrip

DataGrip (and the database tools in other JetBrains IDEs) has drivers for MariaDB, PostgreSQL, MongoDB, Redis and
Neo4j. Create a data source per database with the values from the table above.

The screenshots are from the first version in 2023 (MariaDB 11.0, PostgreSQL 15.4). Host and ports are still the same.

| MariaDB | PostgreSQL | MongoDB |
| --- | --- | --- |
| ![MariaDB data source in DataGrip](img/mariadb-datagrip-config.png) | ![PostgreSQL data source in DataGrip](img/postgres-datagrip-config.png) | ![MongoDB data source in DataGrip](img/mongodb-datagrip-config.png) |

For MongoDB, set user `mongodb-root` and, under *Advanced*, `authSource` to `admin`. The screenshot leaves the user
empty, which is no longer enough since the database requires authentication.

## Other clients

- **Command line:** see [databases.md](databases.md); every CLI runs inside its container.
- **MongoDB Compass:** paste `mongodb://mongodb-root:mongodb-root-pw@localhost:27018/?authSource=admin`.
- **Neo4j Desktop:** add a remote connection to `neo4j://localhost:7687`.
