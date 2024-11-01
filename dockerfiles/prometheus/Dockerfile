FROM prom/prometheus:latest
COPY prometheus.yml.tmpl /etc/prometheus/prometheus.yml.tmpl
COPY entrypoint.sh /entrypoint.sh

ENV ENABLE_BACKEND_METRICS=false

ENTRYPOINT ["/entrypoint.sh"]
