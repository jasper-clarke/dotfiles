#!/usr/bin/env sh

run() {
	if ! pgrep -f "$1"; then
		"$@" &
	fi
}

run "picom" --daemon
nitrogen --restore
run "copyq"
run "firefox" 'https://wol.jw.org/en/wol/h/r1/lp-e'
run "clipse" -listen-shell
#run "mpDris2" --music-dir=~/Music
wpctl set-mute @DEFAULT_SOURCE@ 0
#run "psi-notify"

if ! pgrep -f "lights"; then
	~/.config/awesome/scripts/lights.sh &
fi
