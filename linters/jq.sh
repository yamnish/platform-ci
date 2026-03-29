#!/bin/sh
set -e
failed=0
find /github/workspace -name "*.json" -not -path "*/.git/*" -not -path "*/.ci/*" | while read -r f; do
  if jq . "$f" > /dev/null 2>&1; then
    echo "OK: $f"
  else
    echo "FAIL: $f"
    failed=1
  fi
done
exit $failed
