#!/bin/bash
set -e

# Script to generate Go client, server, and types from OpenAPI specifications
# This script should be run from the repository root

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "==> Creating directory structure..."
mkdir -p go/vmapi/vmtypes go/vmapi/vmserver go/vmapi/vmclient

echo "==> Initializing Go module..."
cd go/vmapi
if [ ! -f go.mod ]; then
  go mod init github.com/krelinga/video-manager-api/go/vmapi
fi
cd ../..

echo "==> Generating Go types..."
cd go/vmapi/vmtypes
oapi-codegen -config ../../../config/types.yml ../../../types.yml
echo "Generated types:"
cat types.gen.go
cd ../../..

echo "==> Generating Go server..."
cd go/vmapi/vmserver
oapi-codegen -config ../../../config/server.yml ../../../openapi.yml
echo "Generated server code:"
wc -l server.gen.go
head -20 server.gen.go
cd ../../..

echo "==> Generating Go client..."
cd go/vmapi/vmclient
oapi-codegen -config ../../../config/client.yml ../../../openapi.yml
echo "Generated client code:"
wc -l client.gen.go
head -20 client.gen.go
cd ../../..

echo "==> Updating go.mod..."
cd go/vmapi
go mod tidy
cd ../..

echo "==> Done! Generated code is in go/vmapi/"
