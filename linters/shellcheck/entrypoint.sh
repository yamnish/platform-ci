#!/bin/sh
set -e
find /github/workspace -name "*.sh" -not -path "*/.git/*" | xargs -r shellcheck
