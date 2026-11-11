#!/bin/bash

# Build script for the agentic SDLC demo static site
# This script prepares the demo/ directory for GitHub Pages deployment

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BUILD_OUTPUT="${BUILD_OUTPUT:-$PROJECT_ROOT/_site}"

echo "🔨 Building agentic SDLC demo site..."
echo "   Source: $PROJECT_ROOT/demo"
echo "   Output: $BUILD_OUTPUT"

# Create output directory
mkdir -p "$BUILD_OUTPUT"

# Copy all files from demo to output
cp -r "$PROJECT_ROOT/demo"/* "$BUILD_OUTPUT/" 2>/dev/null || true

# Verify essential files exist
if [ ! -f "$BUILD_OUTPUT/index.html" ]; then
    echo "❌ Build failed: index.html not found in output"
    exit 1
fi

if [ ! -f "$BUILD_OUTPUT/assets/css/styles.css" ]; then
    echo "❌ Build failed: styles.css not found in output"
    exit 1
fi

if [ ! -f "$BUILD_OUTPUT/assets/js/script.js" ]; then
    echo "❌ Build failed: script.js not found in output"
    exit 1
fi

echo "✅ Build successful!"
echo "   Output directory: $BUILD_OUTPUT"
echo "   Ready for deployment to GitHub Pages"

# Print file listing
echo ""
echo "📦 Built files:"
find "$BUILD_OUTPUT" -type f | sed 's|'"$BUILD_OUTPUT"'||g' | sed 's|^|   |'

exit 0
