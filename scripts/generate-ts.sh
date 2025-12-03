#!/bin/bash
set -e

# Script to generate TypeScript client and types from OpenAPI specifications
# This script should be run from the repository root

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "==> Creating directory structure..."
mkdir -p ts/vmapi/src

echo "==> Initializing npm package..."
cd ts/vmapi

if [ ! -f package.json ]; then
  cat > package.json <<EOF
{
  "name": "@krelinga/video-manager-api",
  "version": "1.0.0",
  "description": "TypeScript types for Video Manager Catalog API",
  "main": "src/types.ts",
  "types": "src/types.ts",
  "scripts": {
    "generate": "openapi-typescript ../../openapi.yml --output src/types.ts"
  },
  "keywords": ["video-manager", "api", "types"],
  "author": "krelinga",
  "license": "MIT",
  "devDependencies": {
    "openapi-typescript": "^6.7.0",
    "typescript": "^5.0.0"
  }
}
EOF
fi

echo "==> Installing dependencies..."
if [ ! -d node_modules ]; then
  npm install
fi

echo "==> Generating TypeScript types..."
npx openapi-typescript ../../openapi.yml --output src/types.ts

echo "Generated TypeScript types:"
wc -l src/types.ts

cd ../..

echo "==> Done! Generated code is in ts/vmapi/"
