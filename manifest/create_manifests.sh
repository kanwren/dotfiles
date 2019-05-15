#!/bin/bash

# Strip comment lines
grep -Ev '^\s*#' manifests.txt |
# Strip Windows endlines
tr -d '\r' |
# Fix Windows backslashes in paths
tr -d '\\' '/' |
while IFS='' read -r line || [[ -n "$line" ]]; do
    if [[ $line =~ ^.+\.exe ]]; then
        cp -v program.manifest "$line.manifest" &&
        echo "Created $line.manifest"
    else
        echo "Error: invalid .exe file: $line"
    fi
done
