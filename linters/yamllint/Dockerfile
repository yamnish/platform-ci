FROM python:3-alpine
RUN pip install --no-cache-dir yamllint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
