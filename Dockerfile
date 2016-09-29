FROM praekeltfoundation/vumi
MAINTAINER Praekelt Foundation <dev@praekeltfoundation.org>

RUN apt-get-install.sh libjpeg62 nginx

# Forward Nginx access and error logs to stdout/err
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

COPY junebug-entrypoint.sh nginx/nginx-config-gen.sh \
    /scripts/

RUN rm /etc/nginx/sites-enabled/default
COPY nginx/vhost.template /config/

EXPOSE 80

CMD ["junebug-entrypoint.sh"]
