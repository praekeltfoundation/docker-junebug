FROM ghcr.io/praekeltfoundation/pypy-base-nw:2-buster AS builder

RUN apt-get update
RUN apt-get -yy install build-essential libssl-dev libffi-dev

RUN pip install --upgrade pip
# We need the backport of the typing module to build Twisted.
RUN pip install typing==3.10.0.0

COPY requirements.txt /requirements.txt
RUN pip wheel -w /wheels -r /requirements.txt


FROM ghcr.io/praekeltfoundation/vumi-base:0.1.1
MAINTAINER Praekelt Foundation <dev@praekeltfoundation.org>

# TODO: Do we want a newer nginx?
# Install a modern Nginx
ENV NGINX_VERSION=1.14.2 \
    NGINX_GPG_KEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN set -ex; \
    fetchDeps=" \
        wget \
        $(command -v gpg > /dev/null || echo 'dirmngr gnupg') \
    "; \
    apt-get-install.sh $fetchDeps; \
    wget https://nginx.org/keys/nginx_signing.key; \
    [ "$(gpg -q --with-fingerprint --with-colons nginx_signing.key | awk -F: '/^fpr:/ { print $10 }')" \
        = $NGINX_GPG_KEY ]; \
    apt-key add nginx_signing.key; \
    codename="$(. /etc/os-release; echo $VERSION | grep -oE [a-z]+)"; \
    echo "deb http://nginx.org/packages/debian/ $codename nginx" > /etc/apt/sources.list.d/nginx.list; \
    rm nginx_signing.key; \
    apt-get-purge.sh $fetchDeps; \
    \
    apt-get-install.sh "nginx=$NGINX_VERSION-1\~$codename"; \
# Delete default server
    rm /etc/nginx/conf.d/default.conf; \
# Create directories for Junebug frontends/upstreams
    mkdir -p /etc/nginx/includes/junebug; \
# Forward Nginx access and error logs to stdout/err
    ln -sf /dev/stdout /var/log/nginx/access.log; \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY requirements.txt /requirements.txt
COPY --from=builder /wheels /wheels
RUN pip install -f /wheels -r /requirements.txt

COPY junebug-entrypoint.sh nginx/nginx-config-gen.sh \
    /scripts/

COPY nginx/vhost.template /config/

EXPOSE 80

ENTRYPOINT ["tini", "--", "junebug-entrypoint.sh"]
