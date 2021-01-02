if [ "$(tty)" = "/dev/tty1" -o "$(tty)" = "/dev/vc/1" ] ; then
  # run xfce after login
	startxfce4
fi
