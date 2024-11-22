FROM grafana/alloy:latest

COPY config.alloy /etc/alloy/config.alloy
COPY endpoints.json /etc/alloy/endpoints.json

CMD ["run", "--server.http.listen-addr=0.0.0.0:12345", "--stability.level=public-preview", "/etc/alloy/config.alloy"]
