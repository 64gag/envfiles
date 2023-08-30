#!/usr/bin/env bash

cd "$(dirname "$0")"
pactl set-sink-volume $(./gag-sound-pactl-get-current-sink.doc.sh) -5%
