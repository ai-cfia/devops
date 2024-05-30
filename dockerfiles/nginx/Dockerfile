FROM nginx:latest
COPY nginx.conf /etc/nginx/nginx.conf.template
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && apt-get update && apt-get install -y gettext-base
ENTRYPOINT ["/entrypoint.sh"]
