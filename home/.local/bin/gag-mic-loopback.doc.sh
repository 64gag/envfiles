#!/usr/bin/env bash

while [[ $# -gt 0 ]]
do
    case $1 in
        --echo-cancel)
            pactl load-module module-echo-cancel use_volume_sharing=no
            shift
            ;;
        --loopback)
            pactl load-module module-loopback latency_msec=10
            shift
            ;;
        --unload)
            shift
            pactl unload-module module-loopback
            pactl unload-module module-echo-cancel
            ;;
        *)
            shift
            ;;
    esac
done
