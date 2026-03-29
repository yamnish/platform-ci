#!/bin/sh
set -e
files=$(find /github/workspace \( -name "*.env.example" -o -name ".env.example" \) -not -path "*/.git/*" -not -path "*/.ci/*")
if [ -z "$files" ]; then
  echo "No .env.example files found, skipping."
  exit 0
fi
echo "$files" | while IFS= read -r f; do
  dotenv-linter check "$f"
done
