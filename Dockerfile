FROM ubuntu:16.04

ADD config/dpkg-settings /etc/dpkg/dpkg.cfg.d/02apt-speedup
ADD config/apt-settings /etc/apt/apt.conf.d/10settings

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update &&          \
    apt-get upgrade &&         \
    apt-get -y install         \
    apt-transport-https        \
    build-essential            \
    ca-certificates            \
    curl                       \
    git                        \
    python3                    \
    python3-dev                \
    python3-pip                \
    software-properties-common \
    vim                        \
    wget &&                    \
    apt-get clean &&           \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd --shell /bin/bash user
RUN echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ADD config/entrypoint.sh /home/user/entrypoint.sh
RUN chown user:nogroup -R /home/user && chmod 750 /home/user/entrypoint.sh

USER user:nogroup
WORKDIR /home/user
