# Docker Databases

1. Create Docker network:

   ``` bash
   docker network create db_network
   ```

2. Build the containers:

   ``` bash
   docker compose -f docker-compose.dev.yml build
   ```

3. Run the containers:

   ``` bash
   docker compose -f docker-compose.dev.yml up
   ```

4. Remove the containers:

   ``` bash
   docker-compose -f docker-compose.dev.yml down 
   ```

## Specific instructions

### MariaDB and phpMyAdmin

- MariaDB: <http://localhost:8081>
- phpMyAdmin: <http://localhost:8082>
- Credentials:
  - Server: `mariadb`
  - Benutzername: `mariadb-user`
  - Passwort: `mariadb-user-pw`
  - Root-Passwort: `mariadb-root-pw` 
- Check connection by selection the query tool (righ-click on `task_db`) and then enter:

``` sql
select * from tasks;
```

![MariaDB Local Connection](/img/mariadb-datagrip-config.png "MariaDB Local Connection")

## PostgreSQL and pgAdmin

1. Find IP address of the PostgreSQL `postgres`  container:

``` bash
docker ps
```

``` bash
docker inspect {IP_ADDRESS_OF_docker-dbs-postgres} | grep IPAddress
```

2. Go to <http://localhost:5051> and enter
`admin@pgadmin.com` and `pgadmin-user-pw`

3. Click on "Add New Server"

4. In "General" tab
    - Name: `docker-pg-server` (any name)

5. In "Connection" tab
    - Host name/address: `{IP_ADDRESS_OF_docker-dbs-postgres}`
    - Port: `5432`
    - Maintenance database: `postgres`
    - Username: `postgres-user`
    - Password: `postgres-user-pw`
6. Save Connection
7. Check connection by selection the query tool (righ-click on `task_db`) and then enter:

``` sql
select * from tasks;
```

![PostgreSQL Local Connection](/img/postgres-datagrip-config.png "PostgreSQL Local Connection")

## MongoDB and Mongo Express

1. Go to <http://localhost:8082>

![MongoDB Local Connection](/img/mongodb-datagrip-config.png "MongoDB Local Connection")
