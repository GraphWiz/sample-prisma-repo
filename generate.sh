#!/bin/bash

# Find Prisma schema file
prisma_file=$(find . -name '*.prisma' -print -quit)

# Check if Prisma schema file exists
if [[ -z $prisma_file ]]; then
  echo "Prisma schema file not found in the repository."
  exit 1
fi

# Remove generator and datasource blocks from the Prisma schema file
sed -i '/^generator\|datasource/,/^\}/d' "$prisma_file"

# Read the modified content of the Prisma schema file
prisma_content=$(cat "$prisma_file")

# Print the modified content
echo "Prisma schema file content (after removing generator and datasource blocks):"
echo "$prisma_content"
