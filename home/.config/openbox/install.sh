#!/usr/bin/env bash

dir_script=$(realpath $(dirname "$0"))
file_name_target=~/.config/openbox/lxde-rc.xml
#file_name_target=~/.config/openbox/lubuntu-rc.xml

cd "$dir_script"

cp "$file_name_target" "$file_name_target.backup"
sed -e '/<keyboard>/,/<\/keyboard>/!b' -e '/<\/keyboard>/!d;r lxde-rc.xml' -e 'd' -i "$file_name_target"

openbox --reconfigure
