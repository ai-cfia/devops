FROM prom/prometheus:latest

COPY prometheus.yaml /etc/prometheus/prometheus.yml

CMD ["--config.file=/etc/prometheus/prometheus.yml", "--web.enable-remote-write-receiver"]
