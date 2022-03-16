#!/usr/bin/env bash

cd "$(dirname "$0")"
pactl set-sink-volume $(./pa-sound-pactl-get-current-sink.sh) +5%
