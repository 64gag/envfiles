#!/usr/bin/env bash

cd "$(dirname "$0")"
pactl set-sink-mute $(./pa-sound-pactl-get-current-sink.sh) toggle
