#!/bin/sh

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

# make sure you run xscreensaver (with splash) and configure it first
xscreensaver -no-splash &

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
    # Trigger a gvfs network update before starting Thunar. Fixes slow startups after that.
    gvfs-ls network: && thunar --daemon &
    #thunar --daemon &
fi

# Workaround to make Java GUI apps work see:
# http://awesome.naquadah.org/wiki/Problems_with_Java
# You need `wmname` - Arch package: wmname; Ubuntu package: suckless-tools
wmname LG3D
