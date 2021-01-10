(slack &> /dev/null &) &&
(chromium --new-window https://track.toggl.com/timer &> /dev/null &) &&
(xfce4-terminal -e 'tmuxp load tap' &> /dev/null &) &&
sleep 1 &&
wmctrl -r Terminal -b add,maximized_vert,maximized_horz &&
sleep 10 &&
wmctrl -r Toggl -b add,maximized_vert,maximized_horz &&
wmctrl -r Slack -b add,maximized_vert,maximized_horz &&
wmctrl -r Slack -t 1 &&
disown

# Notes:
# move to workspace: wmctrl -s 3 &&
