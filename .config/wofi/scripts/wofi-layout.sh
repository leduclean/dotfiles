#!/usr/bin/env bash

layouts=("appart" "appart-laptop-right" "laptop" "home" )

choice=$(printf '%s\n' "${layouts[@]}" \
  | wofi --dmenu --prompt "Select layout:" --lines 6)

[ -z "$choice" ] && exit 0

case "$choice" in
  appart)
    swaymsg output eDP-1 mode 3072x1920@60.000Hz position 0 1200 scale 1.6
    swaymsg output DP-1 enable mode 1920x1200@60.000Hz position 0 0
    ;;
  appart-laptop-right)
    swaymsg output eDP-1 mode 3072x1920@60.000Hz position 1920 0  scale 1.6
    swaymsg output DP-1 enable mode 1920x1200@60.000Hz position 0 0
    ;;
  laptop)
    swaymsg output DP-1 disable
    swaymsg output eDP-1 enable mode 3072x1920@60.000Hz position 0 0 scale 1.6
    ;;

  home)
    swaymsg output eDP-1 mode 3072x1920@60.000Hz position 0 1080 scale 1.6
    swaymsg output DP-1 enable mode 1920x1080@60.000Hz position 0 0
    ;;

  *)
    notify-send "Unknown layout: $choice"
    exit 1
    ;;
esac

notify-send "Layout switched to: $choice"
