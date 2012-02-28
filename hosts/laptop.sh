#!/bin/sh

# Dropbox with GUI
sudo /etc/rc.d/dropboxd start

# Network Manager applet - connect to various networks (eth, wlan)
if [ "$(pgrep wicd-client)" ]
then
  echo "wicd-gtk already running"
else
  wicd-gtk -t &
fi

# XFCE power manager - turn off monitor, hibernate on lid close
if [ "$(pidof xfce4-power-manager)" ]
then
  echo "xfce4-power-manager already running"
else
  xfce4-power-manager &
fi
