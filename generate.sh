#!/bin/bash

# Check if the required arguments are provided
if [[ $# -ne 2 ]]; then
  echo "Usage: ./generate.sh <endpoint> <x-api-header>"
  exit 1
fi

prisma_file=$(find . -name '*.prisma' -print -quit)

if [[ -z $prisma_file ]]; then
  echo "Prisma schema file not found in the repository."
  exit 1
fi

backup_file="${prisma_file}.bak"
cp "$prisma_file" "$backup_file"

sed -i '/^generator\|datasource/,/^\}/d' "$backup_file"

start_line=$(grep -m 1 -n '\S' "$backup_file" | cut -d: -f1)
end_line=$(grep -n '\S' "$backup_file" | tail -n 1 | cut -d: -f1)

sed -i "1,$((start_line-1))d; $((end_line+1)),$ d" "$backup_file"

echo "Prisma schema file content (after removing generator and datasource blocks):"
cat "$backup_file"


# Create the JSON payload
json_payload=$(jq -n --arg message "$(cat "$backup_file")" '{ "type": "erd", "message": $message, "model": "gpt-4" }')

# Make the POST request
response=$(curl -X POST \
  -H "Content-Type: application/json" \
  -H "x-api-header: $2" \
  -d "$json_payload" \
  "$1")

# Extract the response text
response_text=$(echo "$response" | jq -r '.response.text')

# Save the response text to a markdown file
echo "$response_text" > erd-output.md

rm -f "$backup_file"
