FROM praekeltfoundation/vumi:alpine

# We don't have the same choice of Nginx versions we have in Debian, but we
# should specify the package version so we can update if necessary.
ENV NGINX_VERSION 1.12.1-r0
RUN apk add --no-cache "nginx=$NGINX_VERSION"

# Forward Nginx access and error logs to stdout/err
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

COPY junebug-entrypoint.sh nginx/nginx-config-gen.sh \
    /scripts/

COPY nginx/vhost.template /config/

EXPOSE 80

ENTRYPOINT ["tini", "--", "junebug-entrypoint.sh"]
