#!/usr/bin/env bash
echo "Usage example:"
echo "TARGET=sim@sim-core.local rsync_pwd_to_remote_home.doc.sh"
echo ""

BASENAME_PWD=$(basename "$(pwd)")
rsync -avH "$(pwd)/" -e ssh "${TARGET}:~/${BASENAME_PWD}" \
	--exclude '*.o' \
	--exclude '*.out' \
	--exclude '*.bin' \
	--exclude '*.BIN' \
	--exclude '*.so' \
	--exclude '*.log' \
	--exclude '*.db' \
	--exclude '*_exec' \
	--exclude '*_app' \
	--exclude 'build' \
	--exclude '.git' \
	--exclude 'dist' \
	--exclude 'mission_ATS_aller.json' \
	--exclude 'mission_ATS_retour.json' \
	--exclude '*.egg-info' \

	# Generally, you would want to exclude non-source files...
