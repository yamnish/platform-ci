#!/bin/sh
set -e
yamllint -d '{
  extends: default,
  rules: {
    truthy: {allowed-values: ["true", "false", "on", "off"], check-keys: false},
    line-length: {max: 200},
    comments: {min-spaces-from-content: 1}
  }
}' /github/workspace
