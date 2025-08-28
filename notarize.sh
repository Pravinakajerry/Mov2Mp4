#!/usr/bin/env bash
set -euo pipefail

APP_NAME="MovToMp4"

if [ $# -lt 3 ]; then
  echo "Usage: $0 <APPLE_ID> <TEAM_ID> <APP_SPECIFIC_PASSWORD>" >&2
  exit 1
fi

APPLE_ID="$1"
TEAM_ID="$2"
APP_PW="$3"

# Sign (edit the identity to your Developer ID Application cert)
codesign --deep --force --options runtime \
  --sign "Developer ID Application: YOUR NAME ($TEAM_ID)" \
  "$APP_NAME.app"

ditto -c -k --sequesterRsrc --keepParent "$APP_NAME.app" "$APP_NAME.zip"

xcrun notarytool submit "$APP_NAME.zip" \
  --apple-id "$APPLE_ID" --team-id "$TEAM_ID" --password "$APP_PW" --wait

xcrun stapler staple "$APP_NAME.app"

echo "Notarization completed and stapled."


