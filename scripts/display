#!/usr/bin/env bash
# pactl list short sinks
# pactl set-sink-volume <id> +10%
# pactl set-sink-volume <id> -- -10%

if [ "$1" = "mirror" ]; then
  xrandr --output HDMI1 --off
  xrandr --output HDMI1 --mode 1360x768
  xrandr --output LVDS1 --mode 1360x768
  pacmd set-card-profile 0 output:hdmi-stereo
elif [ "$1" = "extend" ]; then
  xrandr --output HDMI1 --off
  xrandr --output LVDS1 --mode 1360x768
  xrandr --output HDMI1 --mode 1360x768 --right-of LVDS1
  pacmd set-card-profile 0 output:hdmi-stereo
elif [ "$1" = "hdmi" ]; then
  xrandr --output HDMI1 --mode 1360x768
  xrandr --output LVDS1 --off
  pacmd set-card-profile 0 output:hdmi-stereo
else
  xrandr --output LVDS1 --mode 1360x768
  xrandr --output HDMI1 --off
  pacmd set-card-profile 0 output:analog-stereo
  xbacklight -set 100%
fi
