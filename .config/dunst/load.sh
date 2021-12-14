#!/bin/bash

#########################################
# SHAMELESS RIPOFF FROM ANOTHER GUY LUL #
#########################################

pkill dunst
dunst -config ~/.config/dunst/dunstrc &

notify-send -a Notification -u low "Hi Betty!" -i "~/.config/dunst/icons/welcome.svg"
