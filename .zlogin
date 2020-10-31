# run xfce after login
if [ "$(tty)" = "/dev/tty1" -o "$(tty)" = "/dev/vc/1" ] ; then
	  startxfce4
fi

