#!/usr/bin/env bash
set -e

DUCKDB_VERSION="${DUCKDB_VERSION:-v1.4.0}"
DUCKDB_DIR="${DUCKDB_DIR:-$(dirname "$0")/duckdb}"

if [ ! -d "$DUCKDB_DIR" ]; then
    git clone --depth=1 --branch "$DUCKDB_VERSION" \
        https://github.com/duckdb/duckdb.git "$DUCKDB_DIR"
fi

cd "$DUCKDB_DIR"

if [ ! -f "build/release/src/libduckdb_static.a" ]; then
    GEN=ninja BUILD_STATIC_LIBS=1 DISABLE_SANITIZER=1 make release
fi

echo "DuckDB ready at $DUCKDB_DIR"
