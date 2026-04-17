#!/usr/bin/env bash
# =============================================================================
# Dunst ↔ Waybar integration script (custom module)
# - Shows notification bell icon + count of *waiting* notifications
# - Changes icon/color when Do Not Disturb (paused) is enabled
# - Outputs proper JSON for Waybar (return-type: json)
# - Works with modern dunstctl (count waiting / is-paused)
#
# Save as: ~/.config/waybar/scripts/dunst.sh
# Make executable: chmod +x ~/.config/waybar/scripts/dunst.sh
# =============================================================================

# Safety checks
if ! command -v dunstctl >/dev/null 2>&1; then
    echo '{"text":"","tooltip":"dunstctl not found","class":"error"}'
    exit 1
fi

# Get Do Not Disturb status
if dunstctl is-paused | grep -q "true"; then
    ICON=""          # muted / DND icon (Nerd Font / Font Awesome)
    CLASS="dnd"
    TOOLTIP="Do Not Disturb: ON"
else
    ICON=""          # normal bell icon
    CLASS=""
    TOOLTIP="Notifications: ON"
fi

# Get number of waiting (pending) notifications
# dunstctl count waiting returns just the number (0 if none)
COUNT=$(dunstctl count waiting 2>/dev/null || echo 0)

# Build the displayed text and tooltip
if [ "$COUNT" -gt 0 ]; then
    TEXT="${ICON} ${COUNT}"
    TOOLTIP="${TOOLTIP}\n${COUNT} notification(s) waiting"
    # Add a second class so you can style urgent/active notifications differently
    CLASS="${CLASS:+$CLASS }notification"
else
    TEXT="${ICON}"
fi

# Output JSON that Waybar expects
echo "{\"text\": \"$TEXT\", \"tooltip\": \"$TOOLTIP\", \"class\": \"$CLASS\"}"