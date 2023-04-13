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

RUN apt-get-install.sh nginx
# Delete unwanted default server config.
RUN rm /etc/nginx/sites-enabled/default

COPY requirements.txt /requirements.txt
COPY --from=builder /wheels /wheels
RUN pip install -f /wheels -r /requirements.txt

COPY junebug-entrypoint.sh nginx/nginx-config-gen.sh \
    /scripts/

COPY nginx/vhost.template /config/

EXPOSE 80

ENTRYPOINT ["tini", "--", "junebug-entrypoint.sh"]
