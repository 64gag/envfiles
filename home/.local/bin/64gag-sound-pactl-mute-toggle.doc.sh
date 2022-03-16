#!/usr/bin/env bash

cd "$(dirname "$0")"
pactl set-sink-mute $(./64gag-sound-pactl-get-current-sink.doc.sh) toggle
