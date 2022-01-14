!#/bin/sh
function run {
 if ! pgrep $1 ;
  then
    $@&
  fi
}
run "setbg"
run "xcompmgr"
run "pulseaudio --start"
run "setxkbmap -rules evdev -model evdev -layout us -variant altgr-intl"
run "redshift"
run "xautolock -time 60 -locker 'systemctl suspend'"
#run "wmname LG3D"
run "dwmblocks"
run "dunst"
run "brave"
