#!/usr/bin/env bash
if [ "$1" = "off" ]; then
  pactl unload-module module-loopback
else
  pactl load-module module-loopback latency_msec=1
fi
