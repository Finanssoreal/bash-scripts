#!/bin/bash

# System variables
PROFILE=default
BUCKET=s3://finanssoreal/database/

OBJECT="$(aws s3 ls --profile $PROFILE $BUCKET | sort | tail -n 1 | awk '{print $4}')"
FULL_PATH="$HOME/$OBJECT"

aws s3 cp "$BUCKET$OBJECT" "$FULL_PATH" --profile $PROFILE
gunzip $FULL_PATH

# UPDATE full path
FULL_PATH="${FULL_PATH%.gz}"

if [[ "$1" == "-fixsql" ]]; then
  sed -i 's/DEFINER=`forge`@`%`/DEFINER=`finanssoreal`@`%`/g' $FULL_PATH
fi

if [[ "$2" == "-fixutf8" ]]; then
  sed -i 's/utf8mb4_0900_ai_ci/utf8_general_ci/g' $FULL_PATH
fi

echo "Dump descargado correctamente en $FULL_PATH"
