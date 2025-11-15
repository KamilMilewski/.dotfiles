#!/bin/bash

sleep 1 

WALLPAPER_DIR="$HOME/Pictures/wallpapers/"
CURRENT_WALL=$(hyprctl hyprpaper listloaded)
#
# NOTE: To set wallpaper on all monitors, we don't need to check monitor:
# Get the name of the focused monitor with hyprctl
#
# Get a random wallpaper that is not the current one
WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

# Apply the selected wallpaper
#
hyprctl hyprpaper reload ,"$WALLPAPER"

exit 0
