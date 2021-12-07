LIGHT=$(light)
light -A 10
dunstify -h string:fgcolor:#ebcb8b '      ' -a "Light $LIGHT" -i ~/.config/dunst/icons/icons8-light.svg "Bring me light!!!!"
