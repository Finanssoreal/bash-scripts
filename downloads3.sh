#!/bin/bash

DOCKER_IMAGE="finanssoreal/db-helper:latest"
MARIA_DATA="$HOME/maria-data"
AWS_HOME="$HOME/.aws"

# create the base directories
mkdir -p "$MARIA_DATA" && mkdir -p "$AWS_HOME"

# insert dump into database
podman run --rm -it \
    -v $MARIA_DATA:/etc/maria-data \
    -v $AWS_HOME:/root/.aws \
    -e AWS_BUCKET="s3://finanssoreal-backups/" \
    --network=host "finanssoreal/db-helper:latest" download
