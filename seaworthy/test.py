import pytest

from seaworthy.logs import output_lines

from fixtures import *  # noqa: F401,F403


class TestJunebugContainer:

    def test_start(self, junebug_container):

        try:
            client = junebug_container.http_client()
            response = client.get("/jb/health")

            print(response)

            assert response.status_code == 200
        except Exception as msg:
            print(msg)

        logs = output_lines(junebug_container.get_logs(stderr=False))
        for log in logs:
            print(log)

        assert False
