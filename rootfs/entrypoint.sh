#!/bin/sh

#------------------------------------------------------------------------------
# Configure the service:
#------------------------------------------------------------------------------
env sslocal -s $SERVER_ADDR -p $SERVER_PORT -k $PASSWORD \
  -b 0.0.0.0 -l ${LOCAL_PORT:-7070} -m ${METHOD:-'chacha20'} \
  -d start

env /usr/sbin/privoxy --no-daemon /data/config
