#!/bin/bash

set -e # Fail on errors

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

shopt -s nullglob
for f in /docker-entrypoint.d/*.sh; do
    echo "Executing ${f}..."
    . "$f"
done
shopt -u nullglob

exec "$@"
