#!/usr/bin/env bash
set -euo pipefail

APP_NAME="MovToMp4"
APP_VERSION="1.0.0"
APP_ID="io.movtomp4.app"
APP_DIR="$PWD/$APP_NAME.app"
SRC="main.applescript"

if ! command -v osacompile >/dev/null 2>&1; then
  echo "osacompile not found. Install Xcode Command Line Tools: xcode-select --install" >&2
  exit 1
fi

rm -rf "$APP_DIR"
osacompile -o "$APP_DIR" "$SRC"

PLIST="$APP_DIR/Contents/Info.plist"

# Identifier and agent-style (no Dock icon)
/usr/libexec/PlistBuddy -c "Add :CFBundleIdentifier string $APP_ID" "$PLIST" 2>/dev/null || \
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $APP_ID" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleShortVersionString string $APP_VERSION" "$PLIST" 2>/dev/null || \
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $APP_VERSION" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleVersion string $APP_VERSION" "$PLIST" 2>/dev/null || \
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $APP_VERSION" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :LSUIElement bool true" "$PLIST" 2>/dev/null || \
/usr/libexec/PlistBuddy -c "Set :LSUIElement true" "$PLIST"

# Register for .mov via UTI (Open With; not default)
/usr/libexec/PlistBuddy -c "Delete :CFBundleDocumentTypes" "$PLIST" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes array" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0 dict" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:CFBundleTypeName string QuickTime Movie" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:CFBundleTypeRole string Viewer" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:LSHandlerRank string Alternate" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes array" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes:0 string com.apple.quicktime-movie" "$PLIST"

echo "Built: $APP_DIR"
echo "Tip: Right-click a .mov → Open With → $APP_NAME"


