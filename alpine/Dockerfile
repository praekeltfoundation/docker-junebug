ARG VARIANT=alpine
FROM praekeltfoundation/vumi:$VARIANT

# Need an OpenSSL thing to generate htpasswd files. This adds <1MB
RUN apk add --no-cache libressl

# We don't have the same choice of Nginx versions we have in Debian, but we
# should specify the package version so we can update if necessary.
ENV NGINX_VERSION 1.12.2-r3
RUN set -ex; \
    apk add --no-cache "nginx=$NGINX_VERSION"; \
# Workaround for bug in Alpine Nginx package :-/
# https://github.com/gliderlabs/docker-alpine/issues/185
    mkdir /run/nginx; \
# Delete default server
    rm /etc/nginx/conf.d/default.conf; \
# Create directories for Junebug frontends/upstreams
    mkdir -p /etc/nginx/includes/junebug; \
# Forward Nginx access and error logs to stdout/err
    ln -sf /dev/stdout /var/log/nginx/access.log; \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

COPY junebug-entrypoint.sh nginx/nginx-config-gen.sh \
    /scripts/

COPY nginx/vhost.template /config/

EXPOSE 80

ENTRYPOINT ["tini", "--", "junebug-entrypoint.sh"]
