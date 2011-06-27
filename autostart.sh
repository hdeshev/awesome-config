# us & bg phonetic layout. right alt switches, scroll lock lights up when bg toggled
setxkbmap us,bg ,phonetic grp:toggle,grp_led:scroll
# remap caps lock to ctrl
setxkbmap -option ctrl:nocaps
# increase mouse speed and acceleration
xset m 4 1
# make sure you run xscreensaver (with splash) and configure it first
xscreensaver -no-splash &

dropbox start -i &

if [ "$(pidof keepassx)" ]
then
  echo "keepassx already running"
else
  keepassx /home/hristo/.keepassx/deshev.kdb &
fi

truecrypt --auto-mount=favorites &

#using feh to render the wallpaper
feh --bg-scale /data/Photos/Wallpapers/sub-zero---mortal-kombat.jpg &
