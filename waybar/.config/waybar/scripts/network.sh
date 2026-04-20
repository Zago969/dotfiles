# ~/.config/waybar/scripts/network.sh
#!/bin/bash

# Check for ethernet (any en* interface that's UP and has carrier)
for iface in /sys/class/net/en*; do
    if [ "$(cat $iface/operstate 2>/dev/null)" = "up" ]; then
        echo "󰈀"
        exit 0
    fi
done

# Check for wifi
for iface in /sys/class/net/wl*; do
    if [ "$(cat $iface/operstate 2>/dev/null)" = "up" ]; then
        ssid=$(iwgetid -r 2>/dev/null)
        echo "󰤨 $ssid"
        exit 0
    fi
done

echo "󰤭 offline"