from seaworthy.containers.redis import RedisContainer
from seaworthy.containers.rabbitmq import RabbitMQContainer
from seaworthy.definitions import ContainerDefinition
from seaworthy.pytest.fixtures import resource_fixture


class JunebugContainer(ContainerDefinition):
    IMAGE = 'praekeltfoundation/junebug'
    WAIT_PATTERNS = (
        'Junebug is listening on',
    )

    def __init__(self, name, create_kwargs):
        super().__init__(name, self.IMAGE, self.WAIT_PATTERNS,
                         create_kwargs=create_kwargs)

redis_fixture = resource_fixture(RedisContainer(), 'redis')
rabbitmq_fixture = resource_fixture(RabbitMQContainer(), 'rabbitmq')

container = JunebugContainer('junebug', create_kwargs={
    'ports': {
        "80/tcp": None
    },
    'environment': {
        'AUTH_USERNAME': 'guest',
        'AUTH_PASSWORD': 'password',
        'AMQP_HOST': 'rabbitmq',
        'AMQP_VHOST': '/junebug',
        'REDIS_HOST': 'redis',
    }})

junebug_fixture = container.pytest_fixture(
    'junebug_container', dependencies=('redis', 'rabbitmq'))

# Allow all the fixtures to be imported like `from fixtures import *`
__all__ = [
    "redis_fixture",
    "rabbitmq_fixture",
    "junebug_fixture",
]
