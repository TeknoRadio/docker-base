import pytest


def test_that_container_is_running(host):
    assert host.process.get(pid=1).comm == "tail"


def test_that_container_is_ubuntu_xenial(host):
    assert host.system_info.distribution == "ubuntu"
    assert host.system_info.release == "16.04"
    assert host.system_info.codename == "xenial"


INSTALLED_PACKAGES = [
    "apt-transport-https",
    "ca-certificates",
    "curl",
    "git",
    "python3",
    "python3-dev",
    "python3-pip",
    "software-properties-common",
    "vim",
    "wget",
]


@pytest.mark.parametrize("package", INSTALLED_PACKAGES)
def test_that_all_required_packages_are_installed(host, package):
    assert host.package(package).is_installed


def test_that_dpkg_is_configured_with_unsafe_io(host):
    dpkg_file = host.file('/etc/dpkg/dpkg.cfg.d/02apt-speedup')
    assert dpkg_file.is_file
    assert dpkg_file.user == 'root'
    assert dpkg_file.group == 'root'
    assert oct(dpkg_file.mode) == '0o644'
    assert dpkg_file.content_string == 'force-unsafe-io\n'


APT_SETTINGS = [
        "APT::Install-Recommends false;",
        "APT::Install-Suggests false;",
        "Acquire::ForceIPv4 true;",
        "Acquire::PDiffs false;"
]


def test_that_dpkg_is_configured_with_required_settings(host):
    apt_config = host.file('/etc/apt/apt.conf.d/10settings')
    assert apt_config.is_file
    assert apt_config.user == 'root'
    assert apt_config.group == 'root'
    assert oct(apt_config.mode) == '0o644'
    for setting in APT_SETTINGS:
        assert setting in apt_config.content_string


@pytest.mark.parametrize("util", ["/usr/bin/vim", "/usr/bin/view"])
def test_that_vim_utilities_link_to_vim_basic(host, util):
    vim = host.file(util)
    assert vim.is_symlink
    assert vim.linked_to == '/usr/bin/vim.basic'


def test_that_entrypoint_is_present_and_executable(host):
    script = host.file('/entrypoint.sh')
    assert script.is_file
    assert script.user == 'root'
    assert script.group == 'root'
    assert oct(script.mode) == '0o755'

    output = host.check_output('/entrypoint.sh')
    assert 'Tekno Radio Docker Base Image' in output


@pytest.mark.destructive
def test_that_logging_directory_is_present_and_writable(host):
    mountpoint = host.mount_point('/logging')
    assert mountpoint.exists
    assert mountpoint.filesystem == 'ext4'
    assert 'OK' in host.check_output('touch /logging/somefile.log && echo OK')


@pytest.mark.destructive
def test_that_data_directory_is_present_and_writable(host):
    mountpoint = host.mount_point('/data')

    assert mountpoint.exists
    assert mountpoint.filesystem == 'ext4'
    assert 'OK' in host.check_output('touch /data/somefile.txt && echo OK')





# # This test will run on both debian:jessie and centos:7 images
# @pytest.mark.docker_images("debian:jessie", "centos:7")
# def test_multiple(host):
#
#
# # This test is marked as destructive and will run on its own container
# # It will create a /foo file and run 3 times with different params
# @pytest.mark.destructive
# @pytest.mark.parametrize("content", ["bar", "baz", "qux"])
# def test_destructive(host, content):
#     assert not host.file("/foo").exists
#     host.check_output("echo %s > /foo", content)
#     assert host.file("/foo").content_string == content + "\n"


