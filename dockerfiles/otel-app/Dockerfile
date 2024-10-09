FROM python:3.10-slim

ENV OTEL_EXPORTER_OTLP_ENDPOINT=http://alloy.monitoring.svc.cluster.local:4317
ENV OTEL_PYTHON_LOG_CORRELATION=true

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

RUN pip install opentelemetry-api \
    opentelemetry-sdk \
    opentelemetry-exporter-otlp \
    opentelemetry-instrumentation \
    opentelemetry-instrumentation-flask \
    opentelemetry-instrumentation-logging

RUN opentelemetry-bootstrap --action=install

EXPOSE 8080

CMD ["opentelemetry-instrument", "python3", "main.py"]
