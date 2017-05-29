# Set up Junebug in Mission Control

* Log in to Mission Control.
* Select the correct organization.
* Create a new docker app with a sensible name.
* Set the following container options:
  * Docker image: qa-mesos-persistence.za.prk-host.net:5000/junebug
  * Port: 80
* Junebug uses Redis for temporary data storage. Set the following
  environment variables for your container to connect Junebug to Redis:
  - REDIS_HOST
  - REDIS_PORT
  - REDIS_DB
* Junebug uses RabbitMQ for internal message queuing and to send
  messages to outside applications if you set `amqp_queue` in a channel config.
  Set the following environment variables for your container to connect Junebug
  to RabbitMQ:
  - AMQP_HOST
  - AMQP_PORT
  - AMQP_VHOST
  - AMQP_USER
  - AMQP_PASSWORD
* Save your app.
* Check the logs to make sure it started okay.
* Click on "view" to see the domain name your app is listening on.
* Open http://app-domain/jb/channels/ in a browser to see the (currently empty)
  list of channels!
* Declare done. :)

Next, learn how to [set up a channel](create-vumi-bridge-channel.md).

## Notes

1. You may not currently be able to set up your own Redis container inside
   Mission Control. If not, ask the people who run your Mission Control
   instance to set one up for you and give you the hostname, port and db
   number of your Redis instance. Each Junebug container should have its own
   Redis database.

2. You may not currently be able to set up your own RabbitMQ container inside
   Mission Control. If not, ask the people who run your Mission Control
   instance to set one up for you and give you the hostname, port, vhost,
   username and password for your RabbitMQ instance. Multiple Junebug containers
   may use the same RabbitMQ instance and Junebug containers *must* share a
   RabbitMQ instance with applications they connect channels to using the
   [`amqp_queue` channel configuration option](http://junebug.readthedocs.org/en/latest/amqp-integration.html).
