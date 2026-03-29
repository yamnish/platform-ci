#!/bin/sh
set -e
gitleaks detect --source /github/workspace --redact --verbose
