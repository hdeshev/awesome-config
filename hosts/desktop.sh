#!/bin/sh

#VNC server - remote pair programming
if [ "$(pidof vino-server)" ]
then
  echo "vino-server already running"
else
  /usr/lib/vino/vino-server &
fi

