#!/usr/bin/env bash

# TODO GAG This script is ugly AF
# TODO GAG Make sure this script is executed from a given location

loop_dir=home
for i in ${loop_dir}/.*; do
    if [ -f $i ]; then
        ln -s "$(pwd)/$i" ~
    fi
done

mkdir -p $HOME/.config/Code/User
ln -s $PWD/home/.config/Code/User/settings.json $HOME/.config/Code/User/settings.json
