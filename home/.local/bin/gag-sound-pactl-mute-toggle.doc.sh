#!/usr/bin/env bash

cd "$(dirname "$0")"
pactl set-sink-mute $(./gag-sound-pactl-get-current-sink.doc.sh) toggle
