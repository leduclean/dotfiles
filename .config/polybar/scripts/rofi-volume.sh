#!/usr/bin/env bash
#
# Menu de contrôle du volume via rofi.
# Dependencies : pactl, pavucontrol, rofi

# Crée la liste d’options
OPTIONS=(
  "  Aperçu volume (pavucontrol)"
  "  Muet / Rétablir"
  "➕  Augmenter de 5%"
  "➖  Diminuer de 5%"
)

# Lance rofi
CHOICE=$(printf '%s\n' "${OPTIONS[@]}" \
  | rofi -dmenu -i -p "Son:")

# Exécute selon le choix
case "$CHOICE" in
  *pavucontrol*)
    pavucontrol ;;
  *Muet*)
    pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
  *Augmenter*)
    pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
  *Diminuer*)
    pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
esac
