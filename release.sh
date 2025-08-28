#!/usr/bin/env bash
set -euo pipefail

APP_NAME="MovToMp4"
DIST_DIR="$PWD/dist"

./build.sh

rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"

ZIP_PATH="$DIST_DIR/$APP_NAME.zip"

ditto -c -k --sequesterRsrc --keepParent "$APP_NAME.app" "$ZIP_PATH"

shasum -a 256 "$ZIP_PATH" > "$ZIP_PATH.sha256"

echo "Release artifacts in: $DIST_DIR"
ls -lh "$DIST_DIR"


