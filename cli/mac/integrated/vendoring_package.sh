#!/bin/bash

# Set default package name
PACKAGE="codekit"

# Allow override via first argument
if [ ! -z "$1" ]; then
    PACKAGE="$1"
fi

# Define source and destination
SOURCE="../${PACKAGE}/lib"
DEST="lib/src/vendor/${PACKAGE}"

echo "Vendoring: ${PACKAGE}"
echo "Deleting old vendor at ${DEST}..."
rm -rf "${DEST}"

echo "Creating vendor folder: ${DEST}"
mkdir -p "${DEST}"

echo "Copying files from ${SOURCE} ..."
cp -r "${SOURCE}"/* "${DEST}/"

echo "Done. Check:"
echo "- import paths (use relative)"
echo "- LICENSE file (add if missing)"
