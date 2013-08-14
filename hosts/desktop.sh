#!/bin/sh

# Load nvidia X settings
# nvidia-settings --load-config-only

# Start the XFCE settings daemon to make GUI programs look good
# xfsettingsd --force

# Start dropbox daemon
~/.dropbox-dist/dropboxd &

# Network Manager applet - connect to various networks (eth, wlan)
if [ "$(pidof nm-applet)" ]
then
  echo "nm-applet already running"
else
  nm-applet &
fi

#VNC server - remote pair programming
# if [ "$(pidof vino-server)" ]
# then
#   echo "vino-server already running"
# else
#   /usr/lib/vino/vino-server &
# fi

