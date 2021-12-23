#!/bin/bash
# Orignal Author: 2007, by Robert Manea Date
# Modified by:  https://github.com/mohabaks  Wed 25 Oct 2017
# Description: A simple popup calendar using dzen2
#
[ "$(pidof -x $0 | wc -w)" -gt 1 ] && pkill dzen && exit 0

main_bg="#3B4252"
main_fg="#E5E9F0"
month_fg="#BF616A"
weekday_fg="#81A1C1"
today_fg="#88C0D0"

TODAY=$(expr $(date +'%d') + 0 | sed 's/^\(.\)$/ \1/')
MONTH=$(date +'%m')
YEAR=$(date +'%Y')
LINES=$(cal -m | wc -l)
LINES=$((LINES + 1))

(
	#date +'%A, %d %b %Y %H:%M'
	date +'^bg(#00000000) '
	date +''

	#n30f -d -x 720 -y 36 $HOME/.config/popups/calendar/bg.png &
	# current month, highlight header and today

	cal -m | sed -r -e "1 s/.*/^fg($month_fg)&^fg()/" -e "2 s/.*/^fg($weekday_fg)&^fg()/" -e "0,/(^| )($TODAY)($| )/s//\1^bg($today_fg)^fg($main_bg)\2^fg()^bg()\3/" -e "s/^(.*)$/  \1/"
) | dzen2 -fn "Liga SFMono Nerd Font:size=12" -x 1750 -y -1070 -w 310 -h 25 -l $LINES -tw 1 -p -e 'onstart=uncollapse,hide;button1=exit;' -fg "$main_fg" -bg "$main_bg"
#pkill n30f
