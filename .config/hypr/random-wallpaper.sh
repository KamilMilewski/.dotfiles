WALLPAPER_DIR="$HOME/Pictures/wallpapers/"
CURRENT_WALL=$(hyprctl hyprpaper listloaded)
#
# NOTE: To set wallpaper on all monitors, we don't need to check monitor:
# Get the name of the focused monitor with hyprctl
# FOCUSED_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
#
# Get a random wallpaper that is not the current one
WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

# Apply the selected wallpaper
#
# NOTE: see note above
# hyprctl hyprpaper reload "$FOCUSED_MONITOR","$WALLPAPER"
#
hyprctl hyprpaper reload ,"$WALLPAPER"
