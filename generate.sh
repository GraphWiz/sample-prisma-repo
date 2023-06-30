#!/bin/bash

# Find Prisma schema file
prisma_file=$(find . -name '*.prisma' -print -quit)

# Check if Prisma schema file exists
if [[ -z $prisma_file ]]; then
  echo "Prisma schema file not found in the repository."
  exit 1
fi

# Create a backup of the original Prisma schema file
backup_file="${prisma_file}.bak"
cp "$prisma_file" "$backup_file"

# Remove generator and datasource blocks from the Prisma schema file
sed -i '/^generator\|datasource/,/^\}/d' "$backup_file"

# Read the modified content of the Prisma schema file
prisma_content=$(cat "$backup_file")

# Print the modified content
echo "Prisma schema file content (after removing generator and datasource blocks):"
echo "$prisma_content"
