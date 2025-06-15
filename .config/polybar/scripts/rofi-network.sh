#!/usr/bin/env bash


mapfile -t SSIDS < <(nmcli -t -f SSID,SECURITY,BARS device wifi list \
  | sed '/^--/d' \
  | awk -F: '$1!="" {print $1 " [" $2 "] (" $3 ")"}')

CHOICE=$(printf '%s\n' "${SSIDS[@]}" \
  | rofi -dmenu -i -p "Wi-Fi:")

if [[ -n "$CHOICE" ]]; then
    SSID=$(printf '%s' "$CHOICE" | sed -E 's/ \[.*//')
    nmcli device wifi connect "$SSID"
fi
