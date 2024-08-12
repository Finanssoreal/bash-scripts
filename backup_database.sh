#!/bin/bash
set -eo pipefail

# We need this line as we need the aws command
export PATH=/usr/local/bin:$PATH

# BASE VARS
AWS_BUCKET='s3://finanssoreal/database'
TIMESTAMP=$(date "+%Y%m%d_%H%M")
DOCKER_COMPOSE_PATH="/home/debian/docker-files/laravel-prod/docker-compose.yml"

# DATABASE CREDENTIALS
MYSQL_USER='root'
MYSQL_PASS='root'
MYSQL_DB='local_finanssoreal'

docker compose -f $DOCKER_COMPOSE_PATH exec database /usr/bin/mariadb-dump \
  --user=$MYSQL_USER --password=$MYSQL_PASS \
  --routines --events --triggers \
  --single-transaction $MYSQL_DB  | \
  # Compress the database file
  gzip -c | \
  # Upload the compressed file to AWS
  aws s3 cp - "$AWS_BUCKET/dump_${MYSQL_DB}_${TIMESTAMP}.sql.gz"

echo "Finished pushing the database dump at: ${TIMESTAMP}"
