#!/bin/bash
engine=$(ibus engine)

ENGLISH="xkb:us::eng"
VIETNAM="Bamboo"
JA="mozc-jp"
if [[ "$engine" == "$ENGLISH" ]]; then
	ibus engine $VIETNAM
	dunstify -h string:x-dunst-stack-tag:ibus -A 'ibus,default' -a "IBUS" -i "~/.scripts/img/vn.svg" "VI"
fi
if [[ "$engine" == "$VIETNAM" ]]; then
	ibus engine $JA
	dunstify -h string:x-dunst-stack-tag:ibus -A 'ibus,default' -a "IBUS" -i "~/.scripts/img/ja1.svg" "JA"
fi
if [[ "$engine" == "$JA" ]]; then
	ibus engine $ENGLISH
	dunstify -h string:x-dunst-stack-tag:ibus -A 'ibus,default' -a "IBUS" -i "~/.scripts/img/us.svg" "US"
fi
