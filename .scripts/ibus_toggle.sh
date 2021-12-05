#!/bin/bash
engine=$(ibus engine)

ENGLISH="xkb:us::eng"
VIETNAM="Bamboo"
JA="mozc-jp"
if [[ "$engine" == "$ENGLISH" ]]; then
    ibus engine $VIETNAM
    polybar-msg hook ibus 1 &>/dev/null || true
    dunstify -h string:x-dunst-stack-tag:ibus -A 'ibus,default' -a "IBUS" -i "~/.config/dunst/icons/keyboard_vi.svg" "VI"
fi
if [[ "$engine" == "$VIETNAM" ]]; then
    ibus engine $JA
    polybar-msg hook ibus 1 &>/dev/null || true
    dunstify -h string:x-dunst-stack-tag:ibus -A 'ibus,default' -a "IBUS" -i "~/.config/dunst/icons/keyboard_us.svg" "JA"
fi
if [[ "$engine" == "$JA" ]]; then
    ibus engine $ENGLISH
    polybar-msg hook ibus 1 &>/dev/null || true
    dunstify -h string:x-dunst-stack-tag:ibus -A 'ibus,default' -a "IBUS" -i "~/.config/dunst/icons/keyboard_us.svg" "US"
fi
