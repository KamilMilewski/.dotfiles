code &&
(xfce4-terminal -e 'tmuxp load tap' &> /dev/null &) &&
wmctrl -s 3 &&
(chromium --new-window https://track.toggl.com/timer &> /dev/null &) &&
(slack &> /dev/null &) &&
sleep 4 &&
wmctrl -r Code -t 0 &&
wmctrl -r Terminal -t 1 &&
wmctrl -r Code -b add,maximized_vert,maximized_horz &&
wmctrl -r Terminal -b add,maximized_vert,maximized_horz &&
wmctrl -r Toggl -b add,maximized_vert,maximized_horz &&
wmctrl -r Slack -b add,maximized_vert,maximized_horz &&
disown
