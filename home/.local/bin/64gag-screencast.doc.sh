#!/usr/bin/env bash
ffmpeg -f x11grab -video_size 1920x1080 -framerate 25 -i $DISPLAY -f jack -i ffmpeg -c:v libx264 -crf 26 -tune stillimage -preset fast -c:a aac -b:a 128k /tmp/screencast.mp4
#ffmpeg -f jack -i ffmpeg -y out.wav
