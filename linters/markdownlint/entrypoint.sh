#!/bin/sh
set -e
find /github/workspace -name "*.md" -not -path "*/.git/*" \
  | xargs -r markdownlint --disable MD013 MD033 MD034 MD041 --
