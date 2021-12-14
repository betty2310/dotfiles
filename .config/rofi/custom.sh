#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

dir="$HOME/.config/rofi/"
rofi_command="rofi -theme $dir/powermenu.rasi"

uptime=$(uptime -p | sed -e 's/up //g')

# Options
config=""
search=""
bluetooth=""

# Variable passed to rofi
options="$config\n$search\n$bluetooth"

chosen="$(echo -e "$options" | $rofi_command -p "$uptime" -dmenu -selected-row 0)"
case $chosen in
$config)
  sh ~/.scripts/rofi-edit.sh
  ;;
$search)
  sh ~/.scripts/web-search.sh
  ;;
$bluetooth)
  rofi-bluetooth
  ;;
esac
