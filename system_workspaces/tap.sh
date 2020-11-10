wmctrl -s 0 && code &&
wmctrl -s 1 && (xfce4-terminal -e 'tmuxp load tap' &> /dev/null &) &&
wmctrl -s 3 && (chromium --new-window https://track.toggl.com/timer &> /dev/null &) &&
wmctrl -s 3 && (slack &> /dev/null &) &&
sleep 3 &&
wmctrl -r Code -t 0 &&
wmctrl -r Terminal -t 1 &&
wmctrl -r Code -b add,maximized_vert,maximized_horz &&
wmctrl -r Terminal -b add,maximized_vert,maximized_horz &&
wmctrl -r Toggl -b add,maximized_vert,maximized_horz &&
disown
