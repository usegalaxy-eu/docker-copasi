FROM jlesage/baseimage-gui:ubuntu-24.04-v4 AS build

# MAINTAINER Björn Grüning, bjoern.gruening@gmail.com

ARG VERSION=4.44.295
ENV DEBIAN_FRONTEND=noninteractive
# This fix: libGL error: No matching fbConfigs or visuals found
ENV LIBGL_ALWAYS_INDIRECT=1

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
         ca-certificates \
         wget \
         zip \
         libgl1 \
         xz-utils \
         nano \
         qt5dxcb-plugin \
         qtbase5-dev \
         python3-full python3-pyqt5 python3-pyqt5.qtsvg python3-pip \
         g++ libomp-dev && \
    rm -rf /var/lib/apt/lists/*

ADD https://github.com/copasi/COPASI/releases/download/Build-295/COPASI-$VERSION-Linux-64bit.sh /tmp
RUN bash /tmp/COPASI-$VERSION-Linux-64bit.sh -t /tmp -i /opt/COPASI/$VERSION/ -d /tmp/

RUN cd /lib/x86_64-linux-gnu/ && \
    wget https://github.com/plunify/libfontconfig/raw/refs/heads/master/libfontconfig.so.1.11.1 && \
    ln -s libfontconfig.so.1.11.1 libfontconfig.so.1 -f && \
    ln -s libfontconfig.so.1.11.1 libfontconfig.so

COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

ENV APP_NAME="copasi"
ENV KEEP_APP_RUNNING=0
ENV TAKE_CONFIG_OWNERSHIP=1

COPY rc.xml.template /opt/base/etc/openbox/rc.xml.template

WORKDIR /opt/COPASI/$VERSION/
