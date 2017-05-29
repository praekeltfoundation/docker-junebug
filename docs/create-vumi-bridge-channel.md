# Create a Vumi Bridge channel

This document will walk you through setting up a Junebug channel that sends
and receives messages using an [HTTP API conversation](http://vumi-go.readthedocs.org/en/latest/http_api.html) configured
in your Vumi Go account.

After [setting up Junebug in Mission Control](set-up-junebug-in-mc.md) proceed
as follows:

## In Mission Control:

* Log into your Mission Control account and make sure the correct organization
  is selected.
* Click "view" on your Junebug container to see the domain name it is
  listening on. We will refer to this as `JUNEBUG_HOST` in the examples
  below.
* Decide on the web path on the `JUNEBUG_HOST` under which you'd like your
  channel to receive messages. We will refer to this as `JUNEBUG_WEB_PATH`
  below.
* Note down the Redis host, port and database your Junebug container is using
  as `JUNEBUG_REDIS_HOST`, `JUNEBUG_REDIS_PORT` and `JUNEBUG_REDIS_DB`.

Where you see a variable such as `JUNEBUG_HOST` or `JUNEBUG_WEB_PATH` in the
examples below, please fill in their values rather than the name of their
variable.

## In Vumi Go:

* Login in to your Vumi Go account.
* Create an HTTP API (no streaming) conversation.
* Set an API token. Note it for later but keep it secret. We will refer to it
  as `VUMIGO_API_TOKEN` in the examples that follow.
* Set the push message URL to:
  `http://JUNEBUG_HOST/JUNEBUG_WEB_PATH/messages.json`
* Set the push event URL to:
  `http://JUNEBUG_HOST/JUNEBUG_WEB_PATH/events.json`
* Take note of the account key (`VUMIGO_ACC_KEY`) and conversation key
  (`VUMIGO_CONV_KEY`) that appear on the right hand side of the HTTP API
  set up page.
* Save the conversation.
* Connect a Vumi Go channel of your choice to the HTTP API application you have
  just created.

## From an HTTP client of your choosing

First read the Junebug [channel creation documentation](http://junebug.readthedocs.org/en/latest/http_api.html#post--channels-).

Then configure the channel in Junebug:

* If your application will receive messages from Junebug over HTTP, determine
  the `MO_URL` (URL for receiving MO messages). Otherwise leave this
  parameters out.
* If your application is sending and receiving messages from Junebug over AMQP
  check that your application is connected to the same RabbitMQ Vhost as
  Junebug and determine the `AMQP_QUEUE` connector the application and Junebug
  will communicate using. Note that this connector name is referred to as the
  `transport_name` in Vumi configuration files. It your application is not
  using AMQP, leave this out.
* Determine a `STATUS_URL` which will receive channel status events (or set
  this to `null` if you don't have one).
* Send an HTTP POST request to http://JUNEBUG_HOST/jb/channels/ with the
  following body:

  ```
  {
    "type": "vumigo",
    "label": "A Nice Name for Your Channel",
    "status_url": "STATUS_URL",
    "mo_url": "MO_URL",
    "amqp_queue": "AMQP_QUEUE",
    "config": {
      "web_path": "JUNEBUG_WEB_PATH",
      "web_port": 9000,
      "account_key": "VUMIGO_ACC_KEY",
      "conversation_key": "VUMIGO_CONV_KEY",
      "access_token": "VUMIGO_API_TOKEN",
      "redis_manager": {
        "host": "JUNEBUG_REDIS_HOST",
        "port": "JUNEBUG_REDIS_PORT",
        "db": "JUNEBUG_REDIS_DB"
      }
    }
  }
  ```

## Back in Mission Control:

* Check the container logs to make sure the channel has started up correctly.
