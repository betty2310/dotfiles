#!/bin/bash

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

function get_volume {
  amixer -D pulse get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function is_mute {
  amixer -D pulse get Master | grep '%' | grep -oE '[^ ]+$' | grep off >/dev/null
}

function send_notification {
  volume=$(get_volume)
  dunstify -h string:x-dunst-stack-tag:test -A 'volume,default' -a VOLUME "$volume" -i '~/.config/dunst/icons/volume.svg'
}

case $1 in
up)
  # Set the volume on (if it was muted)
  amixer -D pulse set Master on >/dev/null
  # Up the volume (+ 5%)
  amixer -D pulse sset Master 5%+ >/dev/null
  send_notification
  ;;
down)
  amixer -D pulse set Master on >/dev/null
  amixer -D pulse sset Master 5%- >/dev/null
  send_notification
  ;;
mute)
  # Toggle mute
  amixer -D pulse set Master 1+ toggle >/dev/null
  if is_mute; then
    DIR=$(dirname "$0")

    dunstify -h string:x-dunst-stack-tag:test -A 'volume,default' -a VOLUME "$volume" -i '~/.config/dunst/icons/015-sound.svg'
  else
    send_notification
  fi
  ;;
esac
