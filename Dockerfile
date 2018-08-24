FROM alpine:latest
MAINTAINER bluebu <bluebuwang@gmail.com>

#------------------------------------------------------------------------------
# Environment variables:
#------------------------------------------------------------------------------

RUN \
  apk --update --upgrade add \
      py-pip \
      privoxy \
  && rm /var/cache/apk/*
RUN pip install shadowsocks

ADD https://download.libsodium.org/libsodium/releases/libsodium-1.0.11.tar.gz home/
RUN cd home && tar xf libsodium-1.0.11.tar.gz  && rm libsodium-1.0.11.tar.gz && \
    cd libsodium-1.0.11 && ./configure &&  make && make check && make install
RUN ldconfig

ENV SERVER_ADDR= \
    SERVER_PORT=8899  \
    METHOD=chacha20 \
    TIMEOUT=300 \
    PASSWORD=

#------------------------------------------------------------------------------
# Populate root file system:
#------------------------------------------------------------------------------

ADD rootfs /

#------------------------------------------------------------------------------
# Expose ports and entrypoint:
#------------------------------------------------------------------------------
EXPOSE 8118 7070

ENTRYPOINT ["/entrypoint.sh"]
