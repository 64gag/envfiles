#!/usr/bin/env bash
ffmpeg -video_size 1920x1080 -framerate 25 -f x11grab -i :0.0+0,0 -c:v mpeg1video -q:v 3 -c:a libmp3lame "$1.avi"
#ffmpeg -video_size 1920x1080 -framerate 25 -f x11grab -i :0.0+0,0 -f alsa -ac 2 -i hw:0 -c:v mpeg1video -q:v 3 -c:a libmp3lame "$1.avi"

# To record multiple screens...
#ffmpeg -video_size 1920x1080 -framerate 25 -f x11grab -i :0.0+0,0 -c:v mpeg1video -q:v 3 -c:a libmp3lame "$1-top.avi" &
#ffmpeg -video_size 1920x1080 -framerate 25 -f x11grab -i :0.0+0,1080 -c:v mpeg1video -q:v 3 -c:a libmp3lame "$1-bottom.avi"
