#!/bin/bash

DOCKER_IMAGE="finanssoreal/db-helper:latest"
MARIA_DATA="$HOME/maria-data"
AWS_HOME="$HOME/.aws"

# create the base directories
mkdir -p "$MARIA_DATA" && mkdir -p "$AWS_HOME"

# download a dump from the database
podman run --rm -it \
    -v $MARIA_DATA:/etc/maria-data \
    -v $AWS_HOME:/root/.aws \
    --network=host $DOCKER_IMAGE insert
