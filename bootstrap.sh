#!/usr/bin/env bash
set -e

DUCKDB_VERSION="${DUCKDB_VERSION:-v1.4.0}"
DUCKDB_DIR="${DUCKDB_DIR:-$(dirname "$0")/duckdb}"

if [ ! -d "$DUCKDB_DIR" ]; then
    git clone --depth=1 --branch "$DUCKDB_VERSION" \
        https://github.com/duckdb/duckdb.git "$DUCKDB_DIR"
fi

cd "$DUCKDB_DIR"

STATIC_LIB_COUNT=$(find build/release/src -name "*.a" 2>/dev/null | wc -l)

if [ "$STATIC_LIB_COUNT" -lt 5 ]; then
    echo "Building DuckDB static libraries..."
    cmake -B build/release \
          -DCMAKE_BUILD_TYPE=Release \
          -DBUILD_SHARED_LIBS=OFF \
          -DENABLE_SANITIZER=OFF \
          -DENABLE_UBSAN=OFF \
          -DBUILD_UNITTESTS=OFF \
          -DSKIP_EXTENSIONS="jemalloc" \
          -GNinja .
    cmake --build build/release
fi

FOUND=$(find build/release -name "*.a" | wc -l)
echo "DuckDB ready at $DUCKDB_DIR ($FOUND static libraries found)"
