#!/usr/bin/env bash

cd "$(dirname "$0")"
pactl set-sink-volume $(./64gag-sound-pactl-get-current-sink.doc.sh) -5%
