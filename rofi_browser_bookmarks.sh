#!/bin/bash
# How it works:
if [[ -z "$@" ]]; then
  # Here we are preparing list of items (bookmark URLs in this case) that will be displayed in Rofi menu.
  # '.. | .url? | strings' - is for recursively searching for values under `url` key
  cat  ~/.config/google-chrome/Default/Bookmarks | jq -cr '.. | .url? | strings'
else
  # When some of the options (URL) gets selected Rofi again calls the script with option as an argument and this branch
  # gets executed.
  zsh -c "google-chrome-stable '$@' &> /dev/null &"
fi

