#!/usr/bin/env bash
set -euo pipefail

LAYER_NAME=lambda-lib-layer
BUILD_DIR=build
DOCKERFILE_PATH=layer/Dockerfile
REQUIREMENTS=layer/requirements.txt

# Cache directories (must match GitHub Actions cache path)
CACHE_DIR=/tmp/.buildx-cache
CACHE_DIR_NEW=/tmp/.buildx-cache-new

echo "📦 Preparing to build Lambda layer: $LAYER_NAME"

# Ensure requirements.txt exists
if [ ! -f "$REQUIREMENTS" ]; then
  echo "❌ ERROR: $REQUIREMENTS not found!"
  exit 1
fi

# Create build directory
mkdir -p "$BUILD_DIR"

echo "🐳 Pulling cache and building Docker image"
docker buildx build \
  --cache-from=type=local,src=$CACHE_DIR \
  --cache-to=type=local,dest=$CACHE_DIR_NEW,mode=max \
  --load \
  -t $LAYER_NAME \
  -f $DOCKERFILE_PATH .

echo "♻️ Replacing old cache with new one"
rm -rf "$CACHE_DIR"
mv "$CACHE_DIR_NEW" "$CACHE_DIR"

echo "✅ Docker build completed for $LAYER_NAME"
