FROM praekeltfoundation/supervisor
MAINTAINER Praekelt Foundation <dev@praekeltfoundation.org>

RUN apt-get-install.sh libjpeg62 nginx

COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

COPY ./docker/nginx.conf /etc/supervisor/conf.d/nginx.conf
COPY ./docker/junebug.conf /etc/supervisor/conf.d/junebug.conf
COPY ./junebug-entrypoint.sh /scripts/
COPY ./nginx-entrypoint.sh /scripts/

RUN rm /etc/nginx/sites-enabled/default
COPY ./docker/junebug/vhost.template /config/

EXPOSE 80
