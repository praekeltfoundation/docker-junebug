
import os


def pytest_addoption(parser):
    parser.addoption(
        "--junebug-image", action="store", default=os.environ.get(
            "JUNEBUG_IMAGE", "praekeltfoundation/junebug"),
        help="Junebug Docker image to test")


def pytest_report_header(config):
    return "\n".join((
        "Junebug Docker image: {}".format(config.getoption("--junebug-image")),
    ))
