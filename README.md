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

- Credentials: mariadb, root, maria-root
- MariaDB: <http://localhost:8081/>
- phpMyAdmin: <http://localhost:8082/>
