#!/bin/bash
cat < version.json | jq -r ".builds" | grep -v "," | grep -e "[0-9]" | tr -d " "
