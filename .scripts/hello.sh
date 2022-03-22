#!/usr/bin/sh

# Frenzy's totally not stolen (liar) from someone else welcome script

# This lil script gives you a warm welcome cuz it feels good to not feel alone XD

# Dependencies:
# dunstify

datey=$(date +%H)
quotes=$(motivate --no-colors)
if [[ "$datey" -lt 12 ]]; then
	dunstify -i ~/.config/awesome/icons/cat1.png "👋 Good Morning, Betty!" "$quotes" -t 5000
elif [[ "$datey" -lt 16 ]]; then
	dunstify -i ~/.config/awesome/icons/cat1.png "👋 Good Afternoon, Betty!" "$quotes" -t 5000
elif [[ "$datey" -lt 18 ]]; then
	dunstify -i ~/.config/awesome/icons/cat1.png "👋 Good Evening, Betty!" "$quotes" -t 5000
elif [[ "$datey" -lt 0 ]]; then
	dunstify -i ~/.config/awesome/icons/cat1.png "👋 Good Night, Betty!" "$quotes" -t 5000
elif [[ "$datey" -lt 3 ]]; then
	dunstify -i ~/.config/awesome/icons/cat1.png "🤚 Go to sleep, Betty!" "$quotes" -t 5000
fi
