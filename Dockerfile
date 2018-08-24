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

ADD https://download.libsodium.org/libsodium/releases/LATEST.tar.gz home/
RUN cd home && tar xf LATEST.tar.gz  && rm LATEST.tar.gz && \
    cd libsodium-stable && ./configure &&  make && make check && make install
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
