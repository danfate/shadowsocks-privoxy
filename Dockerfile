FROM alpine:latest
MAINTAINER bluebu <bluebuwang@gmail.com>

ENV SIMPLE_OBFS_VER 0.0.5
ENV SIMPLE_OBFS_URL https://github.com/shadowsocks/simple-obfs/archive/v$SIMPLE_OBFS_VER.tar.gz
ENV SIMPLE_OBFS_DIR simple-obfs-$SIMPLE_OBFS_VER

#------------------------------------------------------------------------------
# Environment variables:
#------------------------------------------------------------------------------

RUN set -ex && \
  apk --update --upgrade add \
      py-pip \
      privoxy \
      libsodium \
  &&  apk add --no-cache --virtual \
  	  git \
  	  gcc \
  	  autoconf \
	  make \
	  libtool \
	  automake \
	  zlib-devel \
	  openssl \
	  asciidoc \
	  xmlto \
	  libpcre32 \
	  libev-dev \
	  g++ \
	  linux-headers \
  && rm /var/cache/apk/* \ 
  &&  cd /tmp && \
    git clone --depth=1 https://github.com/shadowsocks/simple-obfs.git . && \
    git submodule update --init --recursive && \
    ./autogen.sh && \
    ./configure --prefix=/usr --disable-documentation && make && \
    make install && \
    cd .. && \
    find /tmp -mindepth 1 -delete && \
    pip install git+https://github.com/shadowsocks/shadowsocks.git@master


    runDeps="$( \
        scanelf --needed --nobanner /usr/bin/ss-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \
    apk add --no-cache --virtual .run-deps $runDeps && \
    apk del .build-deps && \
    rm -rf /tmp/*

ENV SERVER_ADDR= \
    SERVER_PORT=8899  \
    METHOD=chacha20-ietf-poly1305 \
    TIMEOUT=300 \
    PASSWORD=

#------------------------------------------------------------------------------
# Populate root file system:
#------------------------------------------------------------------------------

ADD rootfs /

VOLUME /data
#------------------------------------------------------------------------------
# Expose ports and entrypoint:
#------------------------------------------------------------------------------
EXPOSE 8118 7070

ENTRYPOINT ["/entrypoint.sh"]
