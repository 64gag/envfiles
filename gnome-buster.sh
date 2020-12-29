#!/usr/bin/env bash

gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.mutter workspaces-only-on-primary false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4
gsettings set org.gnome.shell.app-switcher current-workspace-only true
gsettings set org.gnome.desktop.wm.keybindings panel-run-dialog "['<Alt>F2', '<Super>r']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>h']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>j']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>k']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>l']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Super><Shift>h']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Super><Shift>j']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Super><Shift>k']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Super><Shift>l']"
gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"
gsettings set org.gnome.desktop.wm.keybindings maximize "['<Super>i']"
gsettings set org.gnome.desktop.wm.keybindings unmaximize "['<Super>u']"
gsettings set org.gnome.desktop.wm.keybindings move-to-side-w "['<Super>y']"
#gsettings set org.gnome.desktop.wm.keybindings move-to-side-s "['<Super>u']"
#gsettings set org.gnome.desktop.wm.keybindings move-to-side-n "['<Super>i']"
gsettings set org.gnome.desktop.wm.keybindings move-to-side-e "['<Super>o']"
gsettings set org.gnome.desktop.wm.keybindings move-to-corner-nw "['<Super><Shift>y']"
gsettings set org.gnome.desktop.wm.keybindings move-to-corner-sw "['<Super><Shift>u']"
gsettings set org.gnome.desktop.wm.keybindings move-to-corner-se "['<Super><Shift>i']"
gsettings set org.gnome.desktop.wm.keybindings move-to-corner-ne "['<Super><Shift>o']"

gsettings reset-recursively org.gnome.settings-daemon.plugins.media-keys

#gsettings set org.gnome.settings-daemon.plugins.media-keys volume-mute "['XF86AudioMute', '<Super>m']"
#gsettings set org.gnome.settings-daemon.plugins.media-keys volume-mute "['XF86AudioMute', '<Super>m']"
#gsettings set org.gnome.settings-daemon.plugins.media-keys volume-mute 'XF86AudioMute'
#gsettings get org.gnome.settings-daemon.plugins.media-keys volume-mute

custom_keybindings_names=()
custom_keybindings_command=()
custom_keybindings_bindings=()

function join_by { local IFS="$1"; shift; echo "$*"; }

function custom_keybindings_add() {
	local IFS=""
	local name="$1"
	local command="$2"
	local binding="$3"
	custom_keybindings_names=(${custom_keybindings_names[@]} "${name}")
	custom_keybindings_commands=(${custom_keybindings_commands[@]} "${command}")
	custom_keybindings_bindings=(${custom_keybindings_bindings[@]} "${binding}")
}

function custom_keybindings_apply() {
	local custom_keybindings_prefix='/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings'
	local custom_keybindings_schemas=()

	for i in "${!custom_keybindings_names[@]}"; do
		name="${custom_keybindings_names[$i]}"
		custom_keybindings_schemas=(${custom_keybindings_schemas[@]} "'${custom_keybindings_prefix}/custom${i}/'")
	done
	gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "[$(join_by ',' "${custom_keybindings_schemas[@]}")]"

	for i in "${!custom_keybindings_names[@]}"; do
		name="${custom_keybindings_names[$i]}"
		gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${custom_keybindings_prefix}/custom${i}/ name "${name}"
	done

	for i in "${!custom_keybindings_commands[@]}"; do
		command="${custom_keybindings_commands[$i]}"
		gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${custom_keybindings_prefix}/custom${i}/ command "${command}"
	done

	for i in "${!custom_keybindings_bindings[@]}"; do
		binding="${custom_keybindings_bindings[$i]}"
		gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${custom_keybindings_prefix}/custom${i}/ binding "${binding}"
	done
}

custom_keybindings_add "terminal" "gnome-terminal" "'<Super>t'"
custom_keybindings_add "calculator" "gnome-calculator" "'<Super>c'"
custom_keybindings_add "nautilus" "nautilus -w" "'<Super>f'"
custom_keybindings_add "pavucontrol" "pavucontrol" "'<Super>a'"
custom_keybindings_add "firefox" "firefox" "'<Super>b'"

custom_keybindings_apply
