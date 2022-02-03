#!/usr/bin/env bash

sigint_received=0
notify-send -t 2500 -u low "Starting"

name_basename_arg=$1
name_date=$(date +"%Y-%m-%d_%H-%M-%S")
name_basename="${name_basename_arg}-${name_date}"

ffmpeg -f pulse -i alsa_input.usb-046d_HD_Pro_Webcam_C920_6B753E4F-02.analog-stereo.echo-cancel "${name_basename}-audio.wav" &
ffmpeg_audio_pid=$!

ffmpeg -vaapi_device /dev/dri/renderD128 -f x11grab -video_size 1920x1080 -i :0 -vf 'hwupload,scale_vaapi=format=nv12' -c:v h264_vaapi -qp 24 "${name_basename}-screen.avi" &
ffmpeg_screen_pid=$!

ffmpeg -vaapi_device /dev/dri/renderD128 -f v4l2 -video_size 640x480 -i /dev/video0 -vf 'format=nv12,hwupload' -c:v h264_vaapi "${name_basename}-cam.avi" &
ffmpeg_cam_pid=$!


function run_cleanup()
{
    kill $sleep_pid
    kill -s SIGQUIT $ffmpeg_cam_pid $ffmpeg_screen_pid $ffmpeg_audio_pid
    sigint_received=1
}

trap run_cleanup SIGINT

notification_intervals_m=(10 5 5 4 1)
remaining_time_m=0

for notification_interval_m in "${notification_intervals_m[@]}"
do
    remaining_time_m=$((remaining_time_m + $notification_interval_m))
done

for notification_interval_m in "${notification_intervals_m[@]}"
do
    sleep "${notification_interval_m}m"
    sleep_pid=$!
    if [[ "$sigint_received" -eq 1 ]]; then
        break
    fi
    remaining_time_m=$((remaining_time_m - notification_interval_m))
    if [[ "$remaining_time_m" -gt 0 ]]; then
        notify-send -t 2500 -u low "${remaining_time_m} minutes left"
    fi
done

notify-send -t 2500 -u critical "Stopping"
run_cleanup

wait ${ffmpeg_audio_pid} ${ffmpeg_screen_pid} ${ffmpeg_cam_pid}

ffmpeg -i "${name_basename}-screen.avi" -i "${name_basename}-audio.wav" -c copy "${name_basename}-screen-and-audio.avi"
