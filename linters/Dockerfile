# ── shellcheck ────────────────────────────────────────────────────────────────
FROM koalaman/shellcheck-alpine:stable AS shellcheck
COPY shellcheck.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# ── hadolint ──────────────────────────────────────────────────────────────────
FROM hadolint/hadolint:v2.12.0-alpine AS hadolint
COPY hadolint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# ── yamllint ──────────────────────────────────────────────────────────────────
FROM python:3-alpine AS yamllint
RUN pip install --no-cache-dir yamllint
COPY yamllint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# ── jq ────────────────────────────────────────────────────────────────────────
FROM alpine:3.19 AS jq
RUN apk add --no-cache jq
COPY jq.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# ── markdownlint ──────────────────────────────────────────────────────────────
FROM node:lts-alpine AS markdownlint
RUN npm install -g markdownlint-cli@0.39.0
COPY markdownlint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# ── gitleaks ──────────────────────────────────────────────────────────────────
FROM alpine:3.19 AS gitleaks
RUN apk add --no-cache wget && \
    wget -qO /tmp/gitleaks.tar.gz \
      https://github.com/gitleaks/gitleaks/releases/download/v8.18.2/gitleaks_8.18.2_linux_x64.tar.gz && \
    tar -xzf /tmp/gitleaks.tar.gz -C /usr/local/bin gitleaks && \
    rm /tmp/gitleaks.tar.gz && \
    apk del wget
COPY gitleaks.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# ── dotenv ────────────────────────────────────────────────────────────────────
FROM alpine:3.19 AS dotenv
RUN apk add --no-cache wget && \
    wget -qO /tmp/dotenv-linter.tar.gz \
      https://github.com/dotenv-linter/dotenv-linter/releases/download/v3.3.0/dotenv-linter-alpine-x86_64.tar.gz && \
    tar -xzf /tmp/dotenv-linter.tar.gz -C /usr/local/bin && \
    rm /tmp/dotenv-linter.tar.gz && \
    apk del wget
COPY dotenv.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
