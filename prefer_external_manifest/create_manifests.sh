#!/bin/bash
cat manifests.txt | tr -d '\r' |
while read -r line; do
    if [[ $line =~ ^(.+/)* ]]; then
        cp program.manifest "${BASH_REMATCH[0]}" &&
        mv "${BASH_REMATCH[0]}/program.manifest" "$line.manifest" &&
        echo Created $line.manifest
    else
        echo "Error: $line"
    fi
done