FROM ubuntu:16.04
MAINTAINER Teknoradio Tech Team <tripleT@teknoradio.org>

## Configure Apt
ENV DEBIAN_FRONTEND noninteractive
ADD config/dpkg-settings /etc/dpkg/dpkg.cfg.d/02apt-speedup
ADD config/apt-settings /etc/apt/apt.conf.d/10settings
RUN apt-get update &&          \
    apt-get -y install         \
    apt-transport-https        \
    build-essential            \
    ca-certificates            \
    curl                       \
    git                        \
    libssl-dev                 \
    libffi-dev                 \
    libreadline-dev            \
    libxml2-dev                \
    python3                    \
    python3-dev                \
    python3-pip                \
    software-properties-common \
    vim                        \
    wget

VOLUME ["/logging", "/data"]

