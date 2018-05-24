ARG VARIANT=jessie
FROM praekeltfoundation/vumi:$VARIANT

# Install a modern Nginx
ENV NGINX_VERSION=1.14.0 \
    NGINX_GPG_KEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN set -ex; \
    fetchDeps=" \
        wget \
        $(command -v gpg > /dev/null || echo 'dirmngr gnupg') \
    "; \
    apt-get-install.sh $fetchDeps; \
    wget -O- https://nginx.org/keys/nginx_signing.key | apt-key add -; \
    apt-key adv --fingerprint "$NGINX_GPG_KEY"; \
    codename="$(. /etc/os-release; echo $VERSION | grep -oE [a-z]+)"; \
    echo "deb http://nginx.org/packages/debian/ $codename nginx" > /etc/apt/sources.list.d/nginx.list; \
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
RUN pip install -r /requirements.txt

COPY junebug-entrypoint.sh nginx/nginx-config-gen.sh \
    /scripts/

COPY nginx/vhost.template /config/

EXPOSE 80

ENTRYPOINT ["tini", "--", "junebug-entrypoint.sh"]
