FROM ubuntu:16.04
MAINTAINER Teknoradio Tech Team <tripleT@teknoradio.org>

ENV DEBIAN_FRONTEND noninteractive
ADD config/dpkg-settings /etc/dpkg/dpkg.cfg.d/02apt-speedup
ADD config/apt-settings /etc/apt/apt.conf.d/10settings

RUN apt-get update &&          \
    apt-get -y install         \
    software-properties-common \
    apt-transport-https        \
    ca-certificates            \
    wget                       \
    curl                       \
    git                        \
    vim

