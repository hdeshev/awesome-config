#!/bin/sh

# us & bg phonetic layout. right alt switches, scroll lock lights up when bg toggled
setxkbmap us,bg ,phonetic grp:toggle,grp_led:scroll
# remap caps lock to ctrl
setxkbmap -option ctrl:nocaps
# right Win key is my Compose key
setxkbmap -option compose:rwin

# increase "mouse" speed and acceleration
# Mouse-optimized
# xset m 4 1
# Trackball-optimized
xset m 8 1

# make sure you run xscreensaver (with splash) and configure it first
xscreensaver -no-splash &

# Network Manager applet - connect to various networks (eth, wlan)
if [ "$(pidof nm-applet)" ]
then
  echo "nm-applet already running"
else
  nm-applet &
fi

dropbox start -i &

if [ "$(pidof keepassx)" ]
then
  echo "keepassx already running"
else
  keepassx /home/hristo/.keepassx/deshev.kdb &
fi

truecrypt --auto-mount=favorites &

#using feh to render the wallpaper
eval `cat $HOME/.fehbg`

#clipboard history
if [ "$(pidof parcellite)" ]
then
  echo "parcellite already running"
else
  parcellite &
fi

#Thunar in daemon mode
if [ "$(pidof thunar)" ]
then
  echo "thunar already running"
else
  thunar --daemon &
fi
