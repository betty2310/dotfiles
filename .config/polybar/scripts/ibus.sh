#!/bin/bash

engine=$(ibus engine)

ENGLISH="xkb:us::eng"
VIETNAM="Bamboo"
JA="mozc-jp"
if [[ "$engine" == "$VIETNAM" ]]; then
  echo "VI"
fi
if [[ "$engine" == "$ENGLISH" ]]; then
  echo "EN"
fi
if [[ "$engine" == "$JA" ]]; then
  echo "JA"
fi

