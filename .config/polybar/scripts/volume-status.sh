#!/usr/bin/env bash
pactl get-sink-volume @DEFAULT_SINK@ \
  | awk '{print "VOL " $5}'