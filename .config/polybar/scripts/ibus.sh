#!/bin/bash

engine=$(ibus engine)

ENGLISH="xkb:us::eng"
VIETNAM="Bamboo"
if [[ "$engine" == "$VIETNAM" ]]; then
  echo "VI"
fi
if [[ "$engine" == "$ENGLISH" ]]; then
  echo "EN"
else
  echo "JA"
fi
