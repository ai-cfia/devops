FROM grafana/loki:latest

COPY loki.yaml /etc/loki/loki.yaml

CMD ["--pattern-ingester.enabled=true", "-config.file=/etc/loki/loki.yaml"]
