#!/bin/bash

# Get the current script directory using $PWD
SCRIPT_DIR="$PWD"

# Change to the script's directory
cd "$SCRIPT_DIR"

# Display the current directory (for debugging)
echo "Current directory: $SCRIPT_DIR"

# Define the directories to be deleted (relative paths)
MARIADB_DATA="mariadb/mysql-data"
POSTGRES_DATA="postgres/postgres-data"
PGADMIN_DATA="postgres/pgadmin/pgadmin-data"
MONGODB_DATA="mongodb/mongodb-data"

# Check if the directories exist before attempting to delete
if [ -d "$MARIADB_DATA" ]; then
  echo "Removing $MARIADB_DATA"
  rm -rf "$MARIADB_DATA"
else
  echo "$MARIADB_DATA does not exist."
fi

if [ -d "$POSTGRES_DATA" ]; then
  echo "Removing $POSTGRES_DATA"
  rm -rf "$POSTGRES_DATA"
else
  echo "$POSTGRES_DATA does not exist."
fi

if [ -d "$PGADMIN_DATA" ]; then
  echo "Removing $PGADMIN_DATA"
  rm -rf "$PGADMIN_DATA"
else
  echo "$PGADMIN_DATA does not exist."
fi

if [ -d "$MONGODB_DATA" ]; then
  echo "Removing $MONGODB_DATA"
  rm -rf "$MONGODB_DATA"
else
  echo "$MONGODB_DATA does not exist."
fi
