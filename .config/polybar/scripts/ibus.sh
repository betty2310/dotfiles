#!/bin/bash

engine=$(ibus engine)

ENGLISH="xkb:us::eng"
VIETNAM="Bamboo"
JA="mozc-jp"
if [[ "$engine" == "$VIETNAM" ]]; then
	echo " "
fi
if [[ "$engine" == "$ENGLISH" ]]; then
	echo " "
fi
if [[ "$engine" == "$JA" ]]; then
	echo " "
fi
