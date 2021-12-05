#!/usr/bin/fish

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

function get_volume
    amixer -D pulse get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
end

function is_mute
    amixer -D pulse get Master | grep '%' | grep -oE '[^ ]+$' | grep off >/dev/null
end

function send_notification
    set volume (get_volume)
    dunstify -h string:x-dunst-stack-tag:test -A 'volume,default' -a VOLUME "$volume" -i '~/.config/dunst/icons/volume.svg'
end

switch $argv[1]
    case up
        amixer -D pulse set Master on >/dev/null
        amixer -D pulse sset Master 5%+ >/dev/null
        send_notification
    case down
        amixer -D pulse set Master on >/dev/null
        amixer -D pulse sset Master 5%- >/dev/null
        send_notification

    case mute
        amixer -D pulse set Master 1+ toggle >/dev/null
        if is_mute
            set DIR (dirname "$0")
            dunstify -h string:x-dunst-stack-tag:test -A 'volume,default' -a VOLUME "$volume" -i '~/.config/dunst/icons/volume.svg'
        else
            send_notification
        end
end
