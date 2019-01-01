#!/usr/bin/env bash

cd "$(dirname "$0")"
pactl set-sink-volume $(./sound-pactl-get-current-sink.sh) -5%
