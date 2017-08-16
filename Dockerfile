FROM ubuntu:16.04

ADD config/dpkg-settings /etc/dpkg/dpkg.cfg.d/02apt-speedup
ADD config/apt-settings /etc/apt/apt.conf.d/10settings

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update &&          \
    apt-get -y install         \
    apt-transport-https        \
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
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \

ADD config/entrypoint.sh /entrypoint.sh
RUN chmod 750 /entrypoint.sh

VOLUME ["/logging", "/data"]
