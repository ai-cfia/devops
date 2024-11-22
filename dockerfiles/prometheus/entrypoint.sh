#!/bin/sh

if [ "$ENABLE_BACKEND_METRICS" = "true" ]; then
  BACKEND_JOB="- job_name: 'backend'\n    metrics_path: '/metrics'\n    static_configs:\n      - targets: ['backend:5000']"
else
  BACKEND_JOB=""
fi

# Replace placeholder in the template
sed "s|{{BACKEND_JOB}}|$BACKEND_JOB|" /etc/prometheus/prometheus.yml.tmpl > /etc/prometheus/prometheus.yml

# Start Prometheus
exec /bin/prometheus --config.file=/etc/prometheus/prometheus.yml --web.enable-remote-write-receiver
