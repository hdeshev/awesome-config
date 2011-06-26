# us & bg phonetic layout. right alt switches, scroll lock lights up when bg toggled
setxkbmap us,bg ,phonetic grp:toggle,grp_led:scroll
# remap caps lock to ctrl
setxkbmap -option ctrl:nocaps
# increase mouse speed and acceleration
xset m 4 1

dropbox start -i &
keepassx /home/hristo/.keepassx/deshev.kdb &
truecrypt --auto-mount=favorites &
