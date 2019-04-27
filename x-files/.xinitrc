#!/bin/sh
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
session=${1:-xmonad}

# merge in defaults and keymaps
if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi
  
if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

# exec feh --bg-scale $HOME/Pictures/wallpaper/samus.png &
exec unclutter -grab &
# exec slstatus &
exec redshift &
# exec xsetroot -cursor_name left_ptr &
exec compton --config $HOME/.config/compton/compton.conf &

case $session in
  xmonad      ) exec xmonad;;
  dwm         ) exec dwm;;
  # no known session, try to run it as command
  *           ) exec $1;;
esac
