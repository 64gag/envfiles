#!/usr/bin/env bash
notify-send -t 1000 -u low "Starting"

ffmpeg -video_size 1920x1080 -framerate 25 -f x11grab -i :0.0+0,0 -f alsa -ac 2 -i hw:0 -c:v mpeg1video -q:v 3 -c:a libmp3lame "$1.avi" &
ffmpeg_pid=$!

sleep 10m
notify-send -t 1000 -u low "15 minutes left"
sleep 5m
notify-send -t 1000 -u normal "10 minutes left"
sleep 5m
notify-send -t 1000 -u normal "5 minutes left"
sleep 4m
notify-send -t 1000 -u normal "1 minute left"
sleep 1m
notify-send -t 1000 -u critical "Stopping"

kill -s SIGINT $ffmpeg_pid
wait
