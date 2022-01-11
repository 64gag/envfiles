#!/usr/bin/env bash

# TODO Make sure this script is executed from a given location

loop_dir=home
for i in ${loop_dir}/.*; do
    if [ -f $i ]; then
        ln -s "$(pwd)/$i" ~
    fi
done
