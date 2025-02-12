#!/bin/bash
set -eo pipefail

# COLORS
NORMAL="\033[0m"
RED="\033[31m"
GREEN="\033[0;32m"

# Variables
DB_FILE="$1"
DB_NAME="${2:-local_finanssoreal}"
DB_PASS="${3:-finanssoreal}"
DB_USER="${4:-finanssoreal}"

# CONTAINER DATA
IMAGE_ID="mariadb:lts"
CONTAINER_IDS=$(podman container ls --filter=ancestor=$IMAGE_ID --format "{{.ID}}")

if [ ${#CONTAINER_IDS[@]} -ne 1 ]; then
  echo -e "${RED}there's no mariadb container or there's multiple instances of it running, please try again.."
  exit 1
fi

if [ "$#" -lt 1 ]; then
  echo -e "${RED}usage: $(basename "$0") <db-file-location> [database-name] [database-user] [database-password]"
  exit 1
fi

if [[ ! -e "$DB_FILE" ]]; then
  echo -e "${RED}database file at $database_file does not exist..."
  exit 1
fi

# create and drop the database
podman exec -i "${CONTAINER_IDS[0]}" "mariadb" -u "$DB_USER" --password="$DB_PASS" -e "
DROP DATABASE IF EXISTS $DB_NAME;
CREATE DATABASE IF NOT EXISTS $DB_NAME;"
# import the script
podman exec -i "${CONTAINER_IDS[0]}" "mariadb" -u "${DB_USER}" --password="${DB_PASS}" "${DB_NAME}" < "$DB_FILE"
echo -e "${GREEN}successfully loaded the database file!"
