#!/bin/bash
# How it works:
if [[ -z "$@" ]]; then
  # Here we are preparing list of items (bookmark URLs in this case) that will be displayed in Rofi menu.
  # `.. | [.name?,.url?]`  - recursively search for values under name and url keys. This will produce an array like:
  # [{name: 'some name', url: 'some url'}, ...]
  # `select( . != [])`     - filter out empty arrays (on some levels in a JSON there is no url nor name keys)
  # `select(.[1] != null)` - filter out entries that have second element (url) in an array as null (those are bookmark directories names)
  # `@tsv`  	           - concat every array element into one string. This will produce an array of strings like (bookmark name www.bookmark.url.com)
  cat ~/.config/google-chrome/Default/Bookmarks | jq -cr '.. | [.name?,.url?] | select( . != [] ) | select(.[1] != null) | @tsv'
else
  # When some of the options (URL) gets selected Rofi again calls the script with option as an argument and this branch
  # gets executed.
  # example of $@: `Online Rain Sound Generator and Forecast | Rain.today   https://rain.today/`
  # So, its a bookmark name and an actual url at the end
  #
  URL=$(echo $@ | awk '{print $NF}') # extract last element of a string which is an url
  zsh -c "google-chrome-stable '${URL}' &> /dev/null &"
fi

