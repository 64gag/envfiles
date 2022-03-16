#!/usr/bin/env bash

case $1 in
    "terminal")
        lxterminal
        ;;
    "web_browser")
        firefox
        ;;
    "file_manager")
        pcmanfm
        ;;
    "calculator")
        galculator
        ;;
    "quit")
        lxsession-logout
        ;;
    "screenshot")
        ;;
    "launcher")
        ;;
    "audio_player")
        snap run spotify
        ;;
esac
