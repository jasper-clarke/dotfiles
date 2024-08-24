#!/usr/bin/env sh

run() {
    if ! pgrep -f "$1"; then
        "$@" &
    fi
}

#run "compfy" -b
#run "feh" --bg-fill ~/.flake/wallpapers/space-vortexes.png
#run "emacs" --daemon
#run "nvidia-settings" --load-config-only
#run "copyq"
#run "firefox" 'https://wol.jw.org/en/wol/h/r1/lp-e'
#run "mpDris2" --music-dir=~/Music
#wpctl set-mute @DEFAULT_SOURCE@ 0
#run "psi-notify"

#if ! pgrep -f "lights"; then
#    ~/.config/awesome/scripts/lights.sh &
#fi

