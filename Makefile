.PHONY: all
all: install_local_bin install_lxde_rc

.PHONY: install_local_bin
install_local_bin:
	-home/.local/bin/install.sh

install_lxde_rc:
	-home/.config/openbox/install.sh
