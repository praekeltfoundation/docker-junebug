#!/usr/bin/env sh
set -e

# Set up Nginx config and start Nginx
nginx-config-gen.sh
nginx -g 'daemon off;' &
# Wait a moment for Nginx to start before starting Junebug
sleep 1

JUNEBUG_INTERFACE="${JUNEBUG_INTERFACE:-0.0.0.0}"
JUNEBUG_PORT="${JUNEBUG_PORT:-8080}"
REDIS_HOST="${REDIS_HOST:-127.0.0.1}"
REDIS_PORT="${REDIS_PORT:-6379}"
REDIS_DB="${REDIS_DB:-1}"
AMQP_HOST="${AMQP_HOST:-127.0.0.1}"
AMQP_VHOST="${AMQP_VHOST:-/guest}"
AMQP_PORT="${AMQP_PORT:-5672}"
AMQP_USER="${AMQP_USER:-guest}"
AMQP_PASSWORD="${AMQP_PASSWORD:-guest}"

echo "Starting Junebug with redis://$REDIS_HOST:$REDIS_PORT/$REDIS_DB and \
amqp://$AMQP_USER:$AMQP_PASSWORD@$AMQP_HOST:$AMQP_PORT/$AMQP_VHOST"

exec jb \
    --interface "$JUNEBUG_INTERFACE" \
    --port "$JUNEBUG_PORT" \
    --redis-host "$REDIS_HOST" \
    --redis-port "$REDIS_PORT" \
    --redis-db "$REDIS_DB" \
    --amqp-host "$AMQP_HOST" \
    --amqp-port "$AMQP_PORT" \
    --amqp-vhost "$AMQP_VHOST" \
    --amqp-user "$AMQP_USER" \
    --amqp-password "$AMQP_PASSWORD" \
    --channels whatsapp:vxyowsup.whatsapp.WhatsAppTransport \
    --channels vumigo:vumi.transports.vumi_bridge.GoConversationTransport \
    --plugin '{
      "type": "junebug.plugins.nginx.NginxPlugin",
      "server_name": "_",
      "vhost_template": "/config/vhost.template",
      "vhost_file": "/etc/nginx/conf.d/junebug.conf"
    }' \
    --logging-path .
