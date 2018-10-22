FROM alpine:latest
MAINTAINER bluebu <bluebuwang@gmail.com>


#------------------------------------------------------------------------------
# Environment variables:
#------------------------------------------------------------------------------

RUN set -ex && \
  apk --update --upgrade add \
      py-pip \
      privoxy \
      libsodium \
  &&  apk add --no-cache --virtual \
  	  .build-deps \
	    autoconf \
	    automake \
	    build-base \
	    libev-dev \
	    libtool \
	    linux-headers \
	    openssl-dev \
	    pcre-dev && \

  &&  cd /tmp && \
    git clone --depth=1 https://github.com/shadowsocks/simple-obfs.git . && \
    git submodule update --init --recursive && \
    ./autogen.sh && \
    ./configure --prefix=/usr --disable-documentation && make && \
    make install && \
    cd .. && \
    find /tmp -mindepth 1 -delete && \
    cd /tmp && \
    
RUN pip install git+https://github.com/shadowsocks/shadowsocks.git@master

RUN runDeps="$( \
        scanelf --needed --nobanner /usr/bin/ss-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \
    apk add --no-cache --virtual .run-deps $runDeps && \
    apk del .build-deps && \
    rm -rf /tmp/* \
  && rm /var/cache/apk/* \ 

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
