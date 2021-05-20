#!/bin/sh

set -eu

export TBLS_VERSION=1.46.0
curl -L https://git.io/dpkg-i-from-url | bash -s -- https://github.com/k1LoW/tbls/releases/download/v$TBLS_VERSION/tbls_$TBLS_VERSION-1_amd64.deb

echo "Executing script to generate db schema"
python3 /generate_db_schema_documentation.py
echo "Script executed"

echo "Format generated markdown file"
/node_modules/prettier/bin-prettier.js --write "${INPUT_PATH_TO_GENERATED_DB_SCHEMA_FILE}"

echo "Schema Document successfully generated"
