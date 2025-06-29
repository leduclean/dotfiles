swaymsg -t get_tree \
  | jq -r '.. | select(.type? == "con" and .nodes == []) | select(.app_id or .window_properties) | "\(.id): \(.name)"' \
  | wofi --dmenu \
  | cut -d: -f1 \
  | xargs -I {} swaymsg [con_id={}] focus
