#!/bin/bash

# Variables
DB_NAME=""
DB_PASS=""
DB_USER=""


if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <container-id> <database-file-location>"
  exit 1
fi

echo "Introduzca el nombre de la base de datos a la cual realizar el importe: "
read DB_NAME

echo "Introduzca la contraseña de la base de datos: "
read DB_PASS

echo "Introduzca el usuario de la base de datos: "
read DB_USER


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
docker exec -i "$container_id" /usr/bin/mysql -u "$DB_USER" --password="$DB_PASS" -e "
DROP DATABASE IF EXISTS $DB_NAME;
CREATE DATABASE IF NOT EXISTS $DB_NAME;"
# import the script
docker exec -i "$container_id" /usr/bin/mysql -u "${DB_USER}" --password="${DB_PASS}" "${DB_NAME}" < "$database_file"
