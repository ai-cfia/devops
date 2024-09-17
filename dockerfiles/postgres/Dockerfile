FROM postgres:latest

RUN apt-get update && apt-get install -y python3 python3-requests curl
RUN mkdir -p /app && chown postgres:postgres /app

WORKDIR /app

COPY fetch_schema.py /app/fetch_schema.py
COPY entrypoint.sh /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh

RUN chmod 700 /app

USER postgres

ENTRYPOINT ["/app/entrypoint.sh"]

CMD ["postgres"]