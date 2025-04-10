#!/bin/bash

MARIA_DATA="$HOME/maria-data"

# create the base directories
mkdir -p "$MARIA_DATA"

# download a dump from the database
podman run --rm -it \
    -v $MARIA_DATA:/etc/maria-data \
    --network=host "finanssoreal/db-helper:latest" insert
