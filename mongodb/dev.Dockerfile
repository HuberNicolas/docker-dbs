FROM mongo:latest
COPY ./mock-data/init.js /docker-entrypoint-initdb.d/init.js