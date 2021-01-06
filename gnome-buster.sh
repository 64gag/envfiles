#!/usr/bin/env bash

gsettings reset-recursively org.gnome.desktop.wm.preferences
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4
gsettings set org.gnome.desktop.wm.preferences audible-bell false
gsettings set org.gnome.desktop.wm.preferences button-layout "appmenu:minimize,maximize,close"
gsettings set org.gnome.desktop.wm.preferences mouse-button-modifier "<Alt>"

gsettings reset-recursively org.gnome.desktop.wm.keybindings
gsettings set org.gnome.desktop.wm.keybindings panel-run-dialog "['<Alt>F2', '<Super>r']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
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
#gsettings set org.gnome.desktop.wm.keybindings move-to-side-w "['<Super>y']"
#gsettings set org.gnome.desktop.wm.keybindings move-to-side-s "['<Super>u']"
#gsettings set org.gnome.desktop.wm.keybindings move-to-side-n "['<Super>i']"
#gsettings set org.gnome.desktop.wm.keybindings move-to-side-e "['<Super>o']"
#gsettings set org.gnome.desktop.wm.keybindings move-to-corner-nw "['<Super><Shift>y']"
#gsettings set org.gnome.desktop.wm.keybindings move-to-corner-sw "['<Super><Shift>u']"
#gsettings set org.gnome.desktop.wm.keybindings move-to-corner-se "['<Super><Shift>i']"
#gsettings set org.gnome.desktop.wm.keybindings move-to-corner-ne "['<Super><Shift>o']"

gsettings reset-recursively org.gnome.desktop.interface
gsettings set org.gnome.desktop.interface clock-show-date true

gsettings reset-recursively org.gnome.desktop.background
gsettings set org.gnome.desktop.background show-desktop-icons true

gsettings reset-recursively org.gnome.desktop.input-sources
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+altgr-intl')]"

gsettings reset-recursively org.gnome.mutter
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.mutter workspaces-only-on-primary false

gsettings reset-recursively org.gnome.shell
gsettings set org.gnome.shell.app-switcher current-workspace-only true

function join_by { local IFS="$1"; shift; echo "$*"; }

function media_keys_custom_keybindings_reset() {
    gsettings reset-recursively org.gnome.settings-daemon.plugins.media-keys

    #gsettings set org.gnome.settings-daemon.plugins.media-keys volume-mute "['XF86AudioMute', '<Super>m']"
    #gsettings set org.gnome.settings-daemon.plugins.media-keys volume-mute "['XF86AudioMute', '<Super>m']"
    #gsettings set org.gnome.settings-daemon.plugins.media-keys volume-mute 'XF86AudioMute'
    #gsettings get org.gnome.settings-daemon.plugins.media-keys volume-mute

    custom_keybindings_names=()
    custom_keybindings_command=()
    custom_keybindings_bindings=()
}

function media_keys_custom_keybindings_add() {
    local IFS=""
    local name="$1"
    local command="$2"
    local binding="$3"
    custom_keybindings_names=(${custom_keybindings_names[@]} "${name}")
    custom_keybindings_commands=(${custom_keybindings_commands[@]} "${command}")
    custom_keybindings_bindings=(${custom_keybindings_bindings[@]} "${binding}")
}

function media_keys_custom_keybindings_apply() {
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

media_keys_custom_keybindings_reset
media_keys_custom_keybindings_add "terminal" "gnome-terminal" "'<Super>t'"
media_keys_custom_keybindings_add "calculator" "gnome-calculator" "'<Super>c'"
media_keys_custom_keybindings_add "nautilus" "nautilus -w" "'<Super>f'"
media_keys_custom_keybindings_add "pavucontrol" "pavucontrol" "'<Super>a'"
media_keys_custom_keybindings_add "firefox" "firefox" "'<Super>b'"
media_keys_custom_keybindings_apply
