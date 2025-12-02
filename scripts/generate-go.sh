#!/bin/bash
set -e

# Script to generate Go client, server, and types from OpenAPI specifications
# This script should be run from the repository root

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "==> Creating directory structure..."
mkdir -p go/vmapi

echo "==> Initializing Go module..."
cd go/vmapi
if [ ! -f go.mod ]; then
  go mod init github.com/krelinga/video-manager-api/go/vmapi
fi

echo "==> Generating Go API..."
oapi-codegen -config ../../config/go.yaml ../../openapi.yml
echo "Generated API code:"
wc -l api.gen.go

echo "==> Updating go.mod..."
go mod tidy
cd ../..

echo "==> Done! Generated code is in go/vmapi/"
