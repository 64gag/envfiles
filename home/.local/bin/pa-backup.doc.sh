#!/usr/bin/env bash

backup_dir=/tmp
backup_dir_final=/opt/backups
distro=$(lsb_release -cs)
date=$(date "+%F")

backup_file="${backup_dir}/${HOSTNAME}-${date}-${distro}.tar.gz"

cd /
tar -cvpzf ${backup_file} \
--exclude=${backup_file} \
--exclude=${backup_dir_final} \
--exclude=/bin \
--exclude=/boot \
--exclude=/dev \
--exclude=/home/*/.gvfs \
--exclude=/home/*/.cache \
--exclude=/home/*/.local/share/Trash \
--exclude=/lib* \
--exclude=/lost+found \
--exclude=/media \
--exclude=/mnt \
--exclude=/proc \
--exclude=/run \
--exclude=/sbin \
--exclude=/snap \
--exclude=/sys \
--exclude=/tmp \
--exclude=/usr \
--exclude=/var/log \
--exclude=/var/cache \
--exclude=/usr/src/linux-headers* \
/

echo "Backup file created in '${backup_dir}/${backup_file}'"
du -sh "${backup_dir}/${backup_file}"
echo "You may want to move it to '${backup_dir_final}'?"
echo "mv '${backup_dir}/${backup_file}' '${backup_dir_final}'"
