#!/usr/bin/env bash

set -euo pipefail

# Parse input provided for consume directory.
if [ -n "$1" ]; then
  CONSUME_DIR=$(readlink -f "$1")
else
  echo "ERROR: Directory for protected audiobooks not provided."
  exit 1
fi

# Parse input provided for staging directory
if [ -n "$2" ]; then
  STAGING_DIR=$(readlink -f "$2")
else
  echo "ERROR: Directory for cleaned audiobooks not provided."
  exit 1
fi

# Iterate over *.aax files in consume directory and convert to *.m4b if not previously processed.
for FILE in "${CONSUME_DIR}"/*.aax; do
  FILENAME=${FILE##*/}
  if [ ! -f "${CONSUME_DIR}/.processed" ]; then
    touch "${CONSUME_DIR}/.processed"
  fi

  if ! grep "${FILENAME}" "${CONSUME_DIR}/.processed" &> /dev/null; then
    echo "Converting ${FILE}"
    echo "-> ${STAGING_DIR}/${FILENAME%.*}.m4b"
    ffmpeg -loglevel error -activation_bytes "$ACTIVATION_BYTES" -i "$FILE" -c copy "${STAGING_DIR}/${FILENAME%.*}.m4b" && \
    echo "$FILENAME" >> "${CONSUME_DIR}/.processed"
  else
    echo "Skipping processed file ${FILE}."
  fi

  # Cleanup processed file if desired
  if [ "$REMOVE_PROCESSED_FILES" != "0" ]; then
    rm "$FILE"
  fi
done
