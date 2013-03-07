#!/bin/bash

# remap caps lock to ctrl
setxkbmap -option ctrl:nocaps
# right Win key is my Compose key
setxkbmap -option compose:rwin
# us & bg phonetic layout. right alt switches, caps lock lights up when bg toggled
setxkbmap us,bg ,phonetic grp:toggle,grp_led:caps

# increase "mouse" speed and acceleration
# Mouse-optimized
# xset m 4 1
# Trackball-optimized
xset m 8 1

## DPMS monitor setting (standby -> suspend -> off) (seconds)
xset dpms 300 600 900

# make sure you run xscreensaver (with splash) and configure it first
xscreensaver -no-splash &

if [ "$(pidof keepassx)" ]
then
  echo "keepassx already running"
else
  keepassx /home/hristo/.keepassx/deshev.kdb &
fi

# mount ~/private
~/bin/mount-private.sh &

# set up SSH agent with proper keys
source ~/.bashfiles/ssh-agent.sh

#using feh to render the wallpaper
eval `cat $HOME/.fehbg`

#clipboard history
if [ "$(pidof parcellite)" ]
then
  echo "parcellite already running"
else
  parcellite &
fi

# Workaround to make Java GUI apps work see:
# http://awesome.naquadah.org/wiki/Problems_with_Java
# You need `wmname` - Arch package: wmname; Ubuntu package: suckless-tools
wmname LG3D

HOST=$(hostname)
SCRIPT_DIR=$(dirname $(readlink -f "$0"))
source $SCRIPT_DIR/hosts/$HOST.sh
