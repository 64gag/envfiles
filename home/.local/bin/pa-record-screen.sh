#!/usr/bin/env bash
ffmpeg -video_size 1920x1080 -framerate 25 -f x11grab -i :0.0+0,0 -c:v mpeg1video -q:v 3 -c:a libmp3lame output.avi
