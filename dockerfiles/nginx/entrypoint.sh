#!/bin/sh

# Set default values
: "${SWAGGER_PATH:=swagger}"
: "${BACKEND_PORT:=5000}"
: "${FRONTEND_PORT:=3000}"

envsubst "\$BACKEND_PORT \$FRONTEND_PORT \$SWAGGER_PATH" < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
nginx -g 'daemon off;'
