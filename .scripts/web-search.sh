#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Info:
#   author:    Miroslav Vidovic
#   file:      web-search.sh
#   created:   24.02.2017.-08:59:54
#   revision:  ---
#   version:   1.0
# -----------------------------------------------------------------------------
# Requirements:
#   rofi
# Description:
#   Use rofi to search the web.
# Usage:
#   web-search.sh
# -----------------------------------------------------------------------------
# Script:

declare -A URLS

URLS=(
  ["google"]="https://www.google.com/search?q="
  ["youtube"]="https://www.youtube.com/results?search_query="
  ["github"]="https://github.com/search?q="
  ["reddit"]="https://reddit.com/search/?q="
  ["stackoverflow"]="http://stackoverflow.com/search?q="
  ["searchcode"]="https://searchcode.com/?q="
  ["piratebay"]="https://thepiratebay.org/search/"
)

# List for rofi
gen_list() {
  for i in "${!URLS[@]}"; do
    echo "$i"
  done
}

main() {
  # Pass the list to rofi
  platform=$( (gen_list) | rofi -dmenu -matching fuzzy -location 0 -p -theme ~/.config/rofi/launcher.rasi "Search > ")

  if [[ -n "$platform" ]]; then
    query=$( (echo) | rofi -dmenu -matching fuzzy -location 0 -p -theme ~/.config/rofi/launcher.rasi "Query > ")

    if [[ -n "$query" ]]; then
      url=${URLS[$platform]}$query
      xdg-open "$url"
    else
      exit
    fi

  else
    exit
  fi
}

main

exit 0
