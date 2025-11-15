if [ "$(tty)" = "/dev/tty1" -o "$(tty)" = "/dev/vc/1" ] ; then
  # NOTE: run Hyprland after login
  dbus-run-session Hyprland
fi

if [ "$(tty)" = "/dev/tty2" -o "$(tty)" = "/dev/vc/2" ] ; then
  # NOTE: run xfce after login
  startxfce4
fi
