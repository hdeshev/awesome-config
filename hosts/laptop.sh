#!/bin/sh

# Start the XFCE settings daemon to make GUI programs look good
xfsettingsd --force

# Gnome keyring daemon
gnome-keyring-daemon --daemonize --login

# Start dropbox daemon
# ~/.dropbox-dist/dropboxd &

# Ubuntu only.
dropbox start -i &

# Network Manager applet - connect to various networks (eth, wlan)
if [ "$(pidof nm-applet)" ]
then
  echo "nm-applet already running"
else
  nm-applet &
fi

# XFCE power manager - turn off monitor, hibernate on lid close
if [ "$(pidof xfce4-power-manager)" ]
then
  echo "xfce4-power-manager already running"
else
  xfce4-power-manager &
fi
