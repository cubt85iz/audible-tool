#!/usr/bin/env bash

set -euo pipefail

CONSUME_DIR=$1
if [ -z "$CONSUME_DIR" ]; then
  echo "ERROR: Directory for protected audiobooks not provided."
  exit 1
fi

STAGING_DIR=$2
if [ -z "$STAGING_DIR" ]; then
  echo "ERROR: Directory for cleaned audiobooks not provided."
  exit 1
fi

for FILE in "${CONSUME_DIR}/*.aax"; do
  FILENAME=${FILE}
  if ! grep "${FILE}" "${CONSUME_DIR}/.processed"; then
    ffmpeg -activation_bytes $ACTIVATION_BYTES -i "$FILE" -c copy "${STAGING_DIR}/${FILENAME%.*}.m4b" && \
    echo $FILE > "${CONSUME_DIR}/.processed"
  fi
done
