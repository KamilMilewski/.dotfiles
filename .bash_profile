#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# so that keyring will be unlocked on login
# https://wiki.archlinux.org/title/GNOME/Keyring#Using_the_keyring_outside_GNOME
if [ -n "$DESKTOP_SESSION" ];then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi

if [ "$(tty)" = "/dev/tty1" -o "$(tty)" = "/dev/vc/1" ] ; then
  # run xfce after login
	startxfce4
fi

