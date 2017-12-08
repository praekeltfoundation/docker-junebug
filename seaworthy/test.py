import pytest

# from seaworthy.logs import output_lines

from fixtures import *  # noqa: F401,F403


class TestJunebugContainer:

    def test_with_authentication(self, junebug_container):
        """
        When we try to access an API endpoint that requires authentication
        with credentials, we should get a 200.
        """
        client = junebug_container.http_client()
        response = client.get("/jb/channels/", auth=('guest', 'password'))
        assert response.status_code == 200

    def test_without_authentication(self, junebug_container):
        """
        When we try to access an API endpoint that requires authentication
        without any credentials, we should get a 401 UNAUTHORIZED.
        """
        client = junebug_container.http_client()
        response = client.get("/jb/channels/")
        assert response.status_code == 401

    def test_health(self, junebug_container):
        """
        When we try to access an API endpoint that doesn't require
        authentication without any credentials, we should get a 200.
        """
        client = junebug_container.http_client()
        response = client.get("/jb/health")
        assert response.status_code == 200
