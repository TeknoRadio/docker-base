import pytest

# To mark all the tests as destructive:
# pytestmark = pytest.mark.destructive

# To run all the tests on given docker images:
# pytestmark = pytest.mark.docker_images("debian:jessie", "centos:7")

# Both
# pytestmark = [
#     pytest.mark.destructive,
#     pytest.mark.docker_images("debian:jessie", "centos:7")
# ]


# This test will run on default image (debian:jessie)
def test_default(host):
    assert host.process.get(pid=1).comm == "tail"


# This test will run on both debian:jessie and centos:7 images
@pytest.mark.docker_images("debian:jessie", "centos:7")
def test_multiple(host):
    assert host.process.get(pid=1).comm == "tail"


# This test is marked as destructive and will run on its own container
# It will create a /foo file and run 3 times with different params
@pytest.mark.destructive
@pytest.mark.parametrize("content", ["bar", "baz", "qux"])
def test_destructive(host, content):
    assert not host.file("/foo").exists
    host.check_output("echo %s > /foo", content)
    assert host.file("/foo").content_string == content + "\n"
