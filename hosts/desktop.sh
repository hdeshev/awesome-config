#!/bin/sh

# Ubuntu only.
dropbox start -i &

# Network Manager applet - connect to various networks (eth, wlan)
if [ "$(pidof nm-applet)" ]
then
  echo "nm-applet already running"
else
  nm-applet &
fi

#VNC server - remote pair programming
if [ "$(pidof vino-server)" ]
then
  echo "vino-server already running"
else
  /usr/lib/vino/vino-server &
fi

