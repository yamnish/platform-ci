FROM node:lts-alpine
RUN npm install -g markdownlint-cli@0.39.0
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
