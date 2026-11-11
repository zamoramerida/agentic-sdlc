#!/bin/bash

# Build script for the agentic SDLC demo static site
# This script prepares the demo/ directory for GitHub Pages deployment

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BUILD_OUTPUT="$PROJECT_ROOT/_site"
BUILD_PARENT="$(dirname "$BUILD_OUTPUT")"
BUILD_TEMP="$(mktemp -d "$BUILD_PARENT/.site-build.XXXXXX")"
trap 'rm -rf "$BUILD_TEMP"' EXIT

echo "🔨 Building agentic SDLC demo site..."
echo "   Source: $PROJECT_ROOT/demo"
echo "   Output: $BUILD_OUTPUT"

# Build in a fresh directory so removed source files cannot survive from an older build.
cp -R "$PROJECT_ROOT/demo/." "$BUILD_TEMP/"

# Verify essential files exist
if [ ! -f "$BUILD_TEMP/index.html" ]; then
    echo "❌ Build failed: index.html not found in output"
    exit 1
fi

if [ ! -f "$BUILD_TEMP/assets/css/styles.css" ]; then
    echo "❌ Build failed: styles.css not found in output"
    exit 1
fi

if [ ! -f "$BUILD_TEMP/assets/js/script.js" ]; then
    echo "❌ Build failed: script.js not found in output"
    exit 1
fi

rm -rf "$BUILD_OUTPUT"
mv "$BUILD_TEMP" "$BUILD_OUTPUT"
trap - EXIT

echo "✅ Build successful!"
echo "   Output directory: $BUILD_OUTPUT"
echo "   Ready for deployment to GitHub Pages"

# Print file listing
echo ""
echo "📦 Built files:"
find "$BUILD_OUTPUT" -type f | sed 's|'"$BUILD_OUTPUT"'||g' | sed 's|^|   |'

exit 0
