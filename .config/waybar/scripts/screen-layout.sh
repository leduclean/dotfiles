#!/usr/bin/env bash
#
# ~/.config/waybar/screen-layout.sh
# Return an emoji depending on the sway screen layout

STYLE="<span size='18000'>"

mapfile -t lines < <(swaymsg -t get_outputs |
  jq -r '.[] | select(.active) | "\(.name) \(.rect.x) \(.rect.y) \(.rect.width) \(.rect.height)"')

if [ "${#lines[@]}" -le 1 ]; then
  echo "${STYLE}󰌢</span>"
  exit
fi

# get the first two files
read -r _ x1 y1 w1 h1 <<<"${lines[0]}"
read -r _ x2 y2 w2 h2 <<<"${lines[1]}"


if [ "$y1" -eq "$y2" ]; then
  echo "${STYLE}󰍹 </span>"
elif [ "$x1" -eq "$x2" ]; then
  echo "${STYLE}󰍹 </span>"
else
  echo "${STYLE}</span>"
fi
