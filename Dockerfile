FROM praekeltfoundation/supervisor
MAINTAINER Praekelt Foundation <dev@praekeltfoundation.org>

RUN apt-get-install.sh libjpeg62 nginx
RUN pip install -q \
    yowsup2==2.4.102 \
    vxyowsup==0.1.7 \
    vumi==0.6.10 \
    junebug==0.1.5

COPY ./docker/nginx.conf /etc/supervisor/conf.d/nginx.conf
COPY ./docker/junebug.conf /etc/supervisor/conf.d/junebug.conf
COPY ./junebug-entrypoint.sh /scripts/

RUN rm /etc/nginx/sites-enabled/default
COPY ./docker/junebug/junebug.nginx /etc/nginx/includes/junebug/junebug.conf
COPY ./docker/junebug/vhost.template /config/

EXPOSE 80
