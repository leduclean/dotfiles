#!/bin/bash
echo 3
# Samsung old screen via usb link
# xrandr   --output eDP --primary --mode 3072x1920 --output DVI-I-1-1 --mode 1920x1080 --above eDP  --auto

# AOC kalray screen
xrandr   --output eDP --primary --mode 3072x1920 --output DisplayPort-1 --mode 1920x1200 --above eDP  --auto
