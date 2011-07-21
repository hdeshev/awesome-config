#!/bin/sh

# Network Manager applet - autoconnect to wireless networks
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
