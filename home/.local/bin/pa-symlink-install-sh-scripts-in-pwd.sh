#!/usr/bin/env bash

dir_script=$(pwd)

chmod +x *.sh
ln -s $dir_script/*.sh ~/.local/bin/
