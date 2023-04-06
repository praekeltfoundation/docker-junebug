#!/usr/bin/env sh
set -e

NGINX_DIR="/etc/nginx/includes/junebug"
NGINX_FILE="${NGINX_DIR}/junebug.conf"
HTPASSWD_FILE="/config/htpasswd"
AUTH_BASIC="off"
JUNEBUG_INTERFACE="${JUNEBUG_INTERFACE:-127.0.0.1}"
JUNEBUG_PORT="${JUNEBUG_PORT:-8080}"

if [ -n "$AUTH_USERNAME" ] && [ -n "$AUTH_PASSWORD" ]; then
    AUTH_BASIC="\"Junebug\""
    AUTH_PASSWORD_CRYPT="$(echo "$AUTH_PASSWORD" | openssl passwd -crypt -stdin)"
    echo "$AUTH_USERNAME:$AUTH_PASSWORD_CRYPT:generated by nginx-config-gen.sh" > "$HTPASSWD_FILE"
else
    cat <<EOF
*************************************************************
*                                                           *
*                           WARNING!                        *
*                                                           *
*         Running Junebug without authentication is         *
*                     A REALLY BAD IDEA.                    *
*                                                           *
*         Set the AUTH_USERNAME and AUTH_PASSWORD           *
*         environment variables to enable HTTP              *
*         Basic Authentication and make sure to             *
*         only offer this service over TLS                  *
*                                                           *
*************************************************************
EOF
fi

mkdir -p "$NGINX_DIR"

cat > "$NGINX_FILE" <<EOF
location /jb/ {
  auth_basic ${AUTH_BASIC};
  auth_basic_user_file ${HTPASSWD_FILE};
  proxy_pass http://${JUNEBUG_INTERFACE}:${JUNEBUG_PORT}/;
}

location /jb/health {
  auth_basic off;
  proxy_pass http://${JUNEBUG_INTERFACE}:${JUNEBUG_PORT}/health;
}
EOF
