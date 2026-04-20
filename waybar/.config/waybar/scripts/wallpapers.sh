#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_DIR="$HOME/.cache/wallpaper-selector"
THUMBNAIL_WIDTH="250"
THUMBNAIL_HEIGHT="141"

mkdir -p "$CACHE_DIR"

generate_thumbnail() {
    local input="$1"
    local output="$2"
    magick "$input" -thumbnail "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}^" -gravity center -extent "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" "$output"
}

SHUFFLE_ICON="$CACHE_DIR/shuffle_thumbnail.png"
magick -size "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" xc:#1e1e2e \
    -fill white -font DejaVu-Sans -pointsize 80 -gravity center \
    -annotate 0 "?" "$SHUFFLE_ICON"

generate_menu() {
    echo -en "Random Wallpaper\x00icon\x1f$SHUFFLE_ICON\n"

    for img in "$WALLPAPER_DIR"/*.{jpg,jpeg,png}; do
        [[ -f "$img" ]] || continue
        thumbnail="$CACHE_DIR/$(basename "${img%.*}").png"
        if [[ ! -f "$thumbnail" ]] || [[ "$img" -nt "$thumbnail" ]]; then
            generate_thumbnail "$img" "$thumbnail"
        fi
        echo -en "$(basename "$img")\x00icon\x1f$thumbnail\n"
    done
}

if [[ "${1:-}" == "--random" ]]; then
    selected=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n 1)
else
    selected=$(generate_menu | rofi -dmenu -i \
        -p "Select Wallpaper" \
        -show-icons \
        -theme-str 'window {width: 800px;} listview {lines: 8;} element {padding: 8px;} element-icon {size: 100px;}' \
    )
    [ -z "$selected" ] && exit 0

    if [ "$selected" = "Random Wallpaper" ]; then
        selected=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n 1)
    else
        selected=$(find "$WALLPAPER_DIR" -type f -name "$selected" | head -n1)
    fi
fi

if [ -n "$selected" ]; then
    awww img -t grow "$selected"
    sed -i "13 s|background-image: .*;|background-image: image(url(\"$selected\"));|1" ~/.config/wlogout/style.css
    sed -i "15 s|path = .*|path = $selected|" ~/.config/hypr/hyprlock.conf
    echo "$selected" > "$HOME/.cache/current_wallpaper"
    notify-send "Wallpaper" "Wallpaper has been updated" -i "$selected"
fi