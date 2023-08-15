#!/usr/bin/env bash

script_name=$(basename "$0")

backup_dir="/tmp"

exclude_values=(/bin /sbin /boot /dev /proc /sys /run /media /mnt /usr /lib* /snap /var/cache /var/lib /var/log)
exclude_values+=(/home/*/.gvfs /home/*/.cache /home/*/.local/share/Trash /lost+found)
exclude_values+=(/tmp)
exclude_values+=(tmp*)

date=$(date "+%F-%H-%M-%S")
description="64gag-backup"

# NOTE: all the parameters up to this point can be modified in the following sourced file

conf_file=/etc/64gag/${script_name}.conf
if [ -f "${conf_file}" ]; then
    source "${conf_file}"
fi

exclude_values+=(${backup_dir}) # Exclude the final value of this variable

backup_tar_file="${backup_dir}/${HOSTNAME}-${date}-${description}.tar.gz"
backup_tar_checksum_file="${backup_tar_file}.sha256"
backup_tar_encrypted_file="${backup_tar_file}.gpg"
backup_tar_encrypted_checksum_file="${backup_tar_encrypted_file}.sha256"

exclude_arguments=()
for item in "${exclude_values[@]}"; do
    exclude_arguments+=("--exclude=$item")
done

# Actual action begins
mkdir -p "${backup_dir}"
time tar -cvpzf "${backup_tar_file}" "${exclude_arguments[@]}" /
time sha256sum "${backup_tar_file}" > ${backup_tar_checksum_file}

echo ""
echo ""
echo "Backup file created: ${backup_tar_file}"
du -sh "${backup_tar_file}"
echo "sha256 checksum found in: ${backup_tar_checksum_file}"
cat "${backup_tar_checksum_file}"

echo "Encrypting the document with gpg to: ${backup_tar_encrypted_file}"
gpg --output "${backup_tar_encrypted_file}" --symmetric "${backup_tar_file}"
time sha256sum "${backup_tar_encrypted_file}" > ${backup_tar_encrypted_checksum_file}

echo "sha256 checksum found in: ${backup_tar_encrypted_checksum_file}"
cat "${backup_tar_encrypted_checksum_file}"

split -b 50G "${backup_tar_encrypted_file}" "${backup_tar_encrypted_file}_part_"
