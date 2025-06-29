#!/usr/bin/bash

SSID=$(nmcli -t -f SSID dev wifi list \
 | grep -v '^$' \
 | sort -u \
 | wofi --dmenu -p "Choisir un réseau Wi-Fi" --matching=fuzzy )


if [ -n "$SSID" ]; then
  PASS=$(zenity --password --title="Mot de passe pour $SSID")
  nmcli dev wifi connect "$SSID" password "$PASS"
fi
