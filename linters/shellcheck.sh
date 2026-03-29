#!/bin/sh
set -e
find /github/workspace -name "*.sh" -not -path "*/.git/*" -not -path "*/.ci/*" | xargs -r shellcheck
