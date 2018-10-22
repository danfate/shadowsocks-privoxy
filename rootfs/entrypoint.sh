#!/bin/sh

#------------------------------------------------------------------------------
# Configure the service:
#------------------------------------------------------------------------------
env obfs-local -s $SERVER_ADDR -p $SERVER_PORT -l 19840 --obfs http --obfs-host www.bing.com
env sslocal -s 127.0.0.1 -p 19840 -k $PASSWORD \
  -b 0.0.0.0 -l ${LOCAL_PORT:-7070} -m ${METHOD:-'chacha20-ietf-poly1305'} \
  -d start

env /usr/sbin/privoxy --no-daemon /data/config
