#!/bin/sh
set -e
find /github/workspace \( -name "Dockerfile" -o -name "Dockerfile.*" \) -not -path "*/.git/*" -not -path "*/.ci/*" | xargs -r hadolint
