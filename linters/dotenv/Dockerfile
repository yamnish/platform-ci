FROM alpine:3.19
RUN apk add --no-cache wget && \
    wget -qO /tmp/dotenv-linter.tar.gz \
      https://github.com/dotenv-linter/dotenv-linter/releases/download/v3.3.0/dotenv-linter-alpine-x86_64.tar.gz && \
    tar -xzf /tmp/dotenv-linter.tar.gz -C /usr/local/bin && \
    rm /tmp/dotenv-linter.tar.gz && \
    apk del wget
ENTRYPOINT ["dotenv-linter"]
