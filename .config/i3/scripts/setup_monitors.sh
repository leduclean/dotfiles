#!/bin/bash

sleep 3

# Configurer l’écran externe
xrandr   --output eDP --primary --mode 3072x1920   --output DVI-I-1-1 --mode 1920x1080 --above eDP   --auto --scale 1x1