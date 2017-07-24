#!/usr/bin/env bash
set -e

DEFAULT_CHANNELS=(
    'whatsapp:vxyowsup.whatsapp.WhatsAppTransport'
    'vumigo:vumi.transports.vumi_bridge.GoConversationTransport'
    'dmark_ussd:vumi.transports.dmark.DmarkUssdTransport'
    'aat_ussd:vxaat.AatUssdTransport'
)
NGINX_PLUGIN='{
    "type": "junebug.plugins.nginx.NginxPlugin",
    "server_name": "_",
    "vhost_template": "/config/vhost.template",
    "vhost_file": "/etc/nginx/conf.d/junebug.conf"
}'

if [ $# -eq 0 ] || [ "${1#-}" != "$1" ]; then
    set -- jb "$@"
fi

if [ "$1" = 'jb' ]; then
    # Set up Nginx config and start Nginx
    nginx-config-gen.sh
    nginx -g 'daemon off;' &
    # Wait a moment for Nginx to start before starting Junebug
    sleep 1

    # Listening interface
    if [ -n "$JUNEBUG_INTERFACE" ]; then
        set -- "$@" \
            --interface "$JUNEBUG_INTERFACE" \
            --port "${JUNEBUG_PORT:-8080}"
    fi

    # Redis
    if [ -n "$REDIS_HOST" ]; then
        set -- "$@" \
            --redis-host "$REDIS_HOST" \
            --redis-port "${REDIS_PORT:-6379}" \
            --redis-db "${REDIS_DB:-1}"
        echo "Redis configured from environment variables as \
            'redis://$REDIS_HOST:$REDIS_PORT/$REDIS_DB'"
    fi

    # AMQP
    if [ -n "$AMQP_HOST" ]; then
        set -- "$@" \
            --amqp-host "$AMQP_HOST" \
            --amqp-port "${AMQP_PORT:-5672}" \
            --amqp-vhost "${AMQP_VHOST:-/guest}" \
            --amqp-user "${AMQP_USER:-guest}" \
            --amqp-password "${AMQP_PASSWORD:-guest}"
        echo "AMQP configured from environment variables as \
            'amqp://$AMQP_USER:$AMQP_PASSWORD@$AMQP_HOST:$AMQP_PORT/$AMQP_VHOST'"
    fi

    # Sentry
    if [ -n "$SENTRY_DSN" ]; then
        set -- "$@" --sentry-dsn "$SENTRY_DSN"
    fi

    # Set all the other defaults
    for channel in "${DEFAULT_CHANNELS[@]}"; do
        set -- "$@" --channels "$channel"
    done
    set -- "$@" \
        --plugin "$NGINX_PLUGIN" \
        --logging-path .
fi

exec "$@"
