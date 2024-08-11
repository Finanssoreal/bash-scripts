#!/bin/bash

# Variables
DB_NAME=""
DB_PASS=""
DB_USER=""
DB_CLI="mariadb"


if [ "$#" -ne 5 ]; then
  echo "Usage: $(basename "$0") <container-id> <database-file-location> <database-name> <database-user> <database-password>"
  exit 1
fi

if [[ "$3" == "-mysql" ]]; then
  DB_CLI="mysql"
fi

# database data
DB_NAME=$3
DB_USER=$4
DB_PASS=$5

# drop database
container_id=$1
database_file=$2

if [[ ! $(docker ps -q -f id=$container_id) ]]; then
  echo "Container with ID $container_id doesn't exist or is not running!"
  exit 1
fi

if [[ ! -e "$database_file" ]]; then
  echo "Database file at $database_file doesn't exist!"
  exit 1
fi

# create and drop the database
docker exec -i "$container_id" "$DB_CLI" -u "$DB_USER" --password="$DB_PASS" -e "
DROP DATABASE IF EXISTS $DB_NAME;
CREATE DATABASE IF NOT EXISTS $DB_NAME;"
# import the script
docker exec -i "$container_id" "$DB_CLI" -u "${DB_USER}" --password="${DB_PASS}" "${DB_NAME}" < "$database_file"
