#!/bin/sh
set -e
find /github/workspace \( -name "Dockerfile" -o -name "Dockerfile.*" \) -not -path "*/.git/*" | xargs -r hadolint
