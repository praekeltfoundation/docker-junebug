# docker-junebug

[![Docker Pulls](https://img.shields.io/docker/pulls/praekeltfoundation/junebug.svg)](https://hub.docker.com/r/praekeltfoundation/junebug/)
[![Build Status](https://travis-ci.org/praekeltfoundation/docker-junebug.svg?branch=master)](https://travis-ci.org/praekeltfoundation/docker-junebug)
[![Requirements Status](https://pyup.io/repos/github/praekeltfoundation/docker-junebug/shield.svg)](https://pyup.io/repos/github/praekeltfoundation/docker-junebug/)

Dockerfile for running [Junebug](http://junebug.readthedocs.org/) with [Nginx](https://www.nginx.com/).

## Details:
Base image: [`praekeltfoundation/vumi`](https://hub.docker.com/r/praekeltfoundation/vumi/)

Two images are available:
* `praekeltfoundation/junebug:latest`: based on Debian Jessie
* `praekeltfoundation/junebug:alpine`: based on Alpine Linux 3.6

The latest stable versions of Junebug and Nginx are installed in these images.

## Configuration:
Configuration can be done using environment variables or command-line options. Use of environment variables and command-line options can be mixed, but using an environment variable at the same time as it's equivalent command-line option can result in unexpected behaviour.

Two environment variables **should always be set** to enable HTTP basic auth for the Junebug API on the `/jb/` path:
- `AUTH_USERNAME`
- `AUTH_PASSWORD`

### Command-line options
Most of Junebug's command-line options can be passed to the container at startup. For example:
```
docker run \
  -e AUTH_USERNAME=user -e AUTH_PASSWORD=secret \
  praekeltfoundation/junebug \
    --redis-host redis0.internal \
    --redis-db 2 \
    --amqp-host rabbitmq0.internal \
    --amqp-vhost /junebug \
    --amqp-user rabbit \
    --amqp-password carrot
```

The following command-line options are **always set** by the entrypoint script:
- `--logging-path` is set to `.` to ensure Junebug logs to stdout/stderr.
- `--plugins` is provided to set up the Nginx plugin.
- `--channels` is provided to set up the following default channels:
  - `whatsapp:vxyowsup.whatsapp.WhatsAppTransport`
  - `vumigo:vumi.transports.vumi_bridge.GoConversationTransport`
  - `dmark_ussd:vumi.transports.dmark.DmarkUssdTransport`
  - `aat_ussd:vxaat.AatUssdTransport`

### Environment variables
Several environment variables can be adjusted to configure Junebug. These variables map to command-line options in the entrypoint script as follows:

| Environment variable            | Command-line option               | Default value |
|---------------------------------|-----------------------------------|---------------|
| `JUNEBUG_INTERFACE`             | `--interface`                     |               |
| `JUNEBUG_PORT`                  | `--port`                          | `8080`        |
| `REDIS_HOST`                    | `--redis-host`                    |               |
| `REDIS_PORT`                    | `--redis-port`                    | `6379`        |
| `REDIS_DB`                      | `--redis-db`                      | `1`           |
| `AMQP_HOST`                     | `--amqp-host`                     |               |
| `AMQP_PORT`                     | `--amqp-port`                     | `5679`        |
| `AMQP_VHOST`                    | `--amqp-vhost`                    | `guest`       |
| `AMQP_USER`                     | `--amqp-user`                     | `guest`       |
| `AMQP_PASSWORD`                 | `--amqp-password`                 | `guest`       |
| `RABBITMQ_MANAGEMENT_INTERFACE` | `--rabbitmq-management-interface` |               |
| `SENTRY_DSN`                    | `--sentry-dsn`                    |               |
| `ALLOW_EXPIRED_REPLIES`         | `--allow-expired-replies`         |               |

For the Redis and AMQP configuration, it is necessary to set the `_HOST` variables before the other environment variables will be considered.

Similarly, the `JUNEBUG_INTERFACE` variable must be set before the `JUNEBUG_PORT` variable is used. However, it is *not recommended* that you change the `--interface` or `--port` options as all communication with Junebug should be performed via the Nginx instance in the container.

## Usage:

* [Set up Junebug in Mission Control](docs/set-up-junebug-in-mc.md)
* [Create a Vumi Bridge channel](docs/create-vumi-bridge-channel.md)
