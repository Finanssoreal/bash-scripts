#!/bin/bash

# System variables
PROFILE=default
BUCKET=s3://finanssoreal/database/

OBJECT="$(aws s3 ls --profile $PROFILE $BUCKET | sort | tail -n 1 | awk '{print $4}')"
FULL_PATH="$HOME/$OBJECT"

aws s3 cp "$BUCKET$OBJECT" "$FULL_PATH" --profile $PROFILE
gunzip $FULL_PATH

if [[ "$1" == "-fixsql" ]]; then
  FULL_PATH="${FULL_PATH%.gz}"
  sed -i 's/DEFINER=`forge`@`%`/DEFINER=`finanssoreal`@`%`/g' $FULL_PATH
fi

echo "Dump descargado correctamente en $FULL_PATH"
