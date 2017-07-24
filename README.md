# docker-junebug

[![Docker Pulls](https://img.shields.io/docker/pulls/praekeltfoundation/junebug.svg)](https://hub.docker.com/r/praekeltfoundation/junebug/)
[![Build Status](https://travis-ci.org/praekeltfoundation/docker-junebug.svg?branch=master)](https://travis-ci.org/praekeltfoundation/docker-junebug)
[![Requirements Status](https://pyup.io/repos/github/praekeltfoundation/docker-junebug/shield.svg)](https://pyup.io/repos/github/praekeltfoundation/docker-junebug/)

Dockerfile for running [Junebug](http://junebug.readthedocs.org/) with [Nginx](https://www.nginx.com/).

### Details:
Base image: [`praekeltfoundation/vumi`](https://hub.docker.com/r/praekeltfoundation/vumi/)

This is a Debian Jessie base image with the latest version of Python 2 and
Junebug and Nginx installed.

### Environment variables:

The environment variables that can be set are:

For adding HTTP Basic Auth to the `/jb/` API endpoint:

- **AUTH_USERNAME**
- **AUTH_PASSWORD**

For configuring Junebug:

- **JUNEBUG_INTERFACE** defaults to `0.0.0.0`
- **JUNEBUG_PORT** defaults to `8080`
- **REDIS_HOST** defaults to `127.0.0.1`
- **REDIS_PORT** defaults to `6379`
- **REDIS_DB** defaults to `1`
- **AMQP_HOST** defaults to `127.0.0.1`
- **AMQP_VHOST** defaults to `guest`
- **AMQP_PORT** defaults to `5672`
- **AMQP_USER** defaults to `guest`
- **AMQP_PASSWORD** defaults to `guest`


### Usage:

* [Set up Junebug in Mission Control](docs/set-up-junebug-in-mc.md)
* [Create a Vumi Bridge channel](docs/create-vumi-bridge-channel.md)
