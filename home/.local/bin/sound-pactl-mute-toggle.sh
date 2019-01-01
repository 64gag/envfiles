#!/usr/bin/env bash

cd "$(dirname "$0")"
pactl set-sink-mute $(./sound-pactl-get-current-sink.sh) toggle
