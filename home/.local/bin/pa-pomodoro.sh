#!/usr/bin/env bash

notify-send -t 1000 -u low "Starting"

name_basename_arg=$1
name_date=$(date +"%Y-%m-%d_%H-%M-%S")
name_basename="${name_basename_arg}-${name_date}"

ffmpeg -video_size 1920x1080 -framerate 25 -f x11grab -i :0.0+0,0 -f alsa -ac 2 -i hw:0 -c:v mpeg1video -q:v 3 -c:a libmp3lame "${name_basename}-video.avi" &
#ffmpeg -video_size 1920x1080 -f x11grab -framerate 30 -i $DISPLAY -c:v h264_nvenc -qp 0 "${name_basename}-video.avi" &
ffmpeg_video_pid=$!
#ffmpeg -f pulse -i alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp__sink.monitor "${name_basename}-audio.wav" &
ffmpeg -f pulse -i alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp__source.echo-cancel "${name_basename}-audio.wav" &
ffmpeg_audio_pid=$!

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

trap "kill -s SIGINT $ffmpeg_audio_pid $ffmpeg_video_pid " SIGINT
wait ${ffmpeg_video_pid}

ffmpeg -i "${name_basename}-video.avi" -i "${name_basename}-audio.wav" -c copy "${name_basename}.avi"
