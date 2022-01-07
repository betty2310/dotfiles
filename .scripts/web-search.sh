#!/usr/bin/bash

declare -A URLS

URLS=(
  ["google"]="https://www.google.com/search?q="
  ["translate"]="https://translate.google.com/?hl=vi&sl=ja&tl=vi&text="
  ["youtube"]="https://www.youtube.com/results?search_query="
  ["github"]="https://github.com/search?q="
  ["stackoverflow"]="http://stackoverflow.com/search?q="
  ["piratebay"]="https://thepiratebay.org/search/"
)

# List for rofi
gen_list() {
    for i in "${!URLS[@]}"
    do
      echo "$i"
    done
}

main() {
  # Pass the list to rofi
  platform=$( (gen_list) | rofi -theme ~/.config/rofi/nord/nord.rasi -dmenu -matching fuzzy -no-custom -location 0 -p "Search > " )

  if [[ -n "$platform" ]]; then
    query=$( (echo ) | rofi -theme ~/.config/rofi/nord/search.rasi -dmenu -matching fuzzy -location 0 -p "Query > " )

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
