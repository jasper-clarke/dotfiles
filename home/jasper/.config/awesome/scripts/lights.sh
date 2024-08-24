#!/usr/bin/env sh

while true; do
	LAST_BATTERY_LEVEL="$BATTERY_LEVEL"
	BATTERY_LEVEL=$(headsetcontrol -cb 2>/dev/null)

	if [ -z "$LAST_BATTERY_LEVEL" ] && [ -n "$BATTERY_LEVEL" ]; then
		# Headset connected
		headsetcontrol -cl0
	fi
	sleep 2
done
