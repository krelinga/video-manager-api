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
  "description": "TypeScript client for Video Manager Catalog API",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsc",
    "clean": "rm -rf dist"
  },
  "keywords": ["video-manager", "api", "client"],
  "author": "krelinga",
  "license": "MIT",
  "devDependencies": {
    "@openapitools/openapi-generator-cli": "^2.7.0",
    "typescript": "^5.0.0"
  },
  "dependencies": {
    "axios": "^1.6.0"
  }
}
EOF
fi

if [ ! -f tsconfig.json ]; then
  cat > tsconfig.json <<EOF
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "declaration": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF
fi

if [ ! -f .openapi-generator-ignore ]; then
  cat > .openapi-generator-ignore <<EOF
# Ignore git files
.git*

# Ignore package files we manage manually
package.json
tsconfig.json
EOF
fi

echo "==> Installing dependencies..."
if [ ! -d node_modules ]; then
  npm install
fi

echo "==> Generating TypeScript API client..."
npx @openapitools/openapi-generator-cli generate \
  -i ../../openapi.yml \
  -g typescript-axios \
  -o ./src \
  --additional-properties=supportsES6=true,npmName=@krelinga/video-manager-api,npmVersion=1.0.0

echo "Generated TypeScript code:"
find src -name "*.ts" -type f | wc -l
echo "files created"

echo "==> Building TypeScript..."
npm run build

cd ../..

echo "==> Done! Generated code is in ts/vmapi/"
