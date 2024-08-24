#!/usr/bin/env sh

device=$(wpctl inspect @DEFAULT_SOURCE@)

if [[ $device == *"Audio/Source"* ]]; then
    wpctl set-mute @DEFAULT_SOURCE@ toggle
fi
