#!/usr/bin/env bash

script_name=$(basename "$0")

backup_dir="/tmp"

exclude_values=(/bin /sbin /boot /dev /proc /sys /run /media /mnt /usr /lib* /snap /var/cache /var/lib /var/log)
exclude_values+=(/root/.cache /home/*/.cache /home/*/.gvfs /home/*/.local/share/Trash /lost+found)
exclude_values+=(/tmp)

date=$(date "+%F-%H-%M-%S")
description="gag-backup"

# NOTE: all the parameters up to this point can be modified in the following sourced file

conf_file=/etc/gag/${script_name}.conf
if [ -f "${conf_file}" ]; then
    source "${conf_file}"
fi

# Use final values of these variables!! (after the `source "${conf_file}"` above)
backup_name="${HOSTNAME}-${description}"
exclude_values+=(${backup_dir})

exclude_arguments=()
for item in "${exclude_values[@]}"; do
    exclude_arguments+=("--exclude")
    exclude_arguments+=("$item")
done

if [ -z "${PASSPHRASE+x}" ]; then # duplicity uses PASSPHRASE so we just play along
    echo -n "Enter encryption key: "
    read -s PASSPHRASE
    echo
    echo -n "Confirm encryption key: "
    read -s PASSPHRASE_CONFIRM
    echo

    if [ "$PASSPHRASE" != "$PASSPHRASE_CONFIRM" ]; then
        echo "Encryption keys do not match. Aborting."
        exit 1
    fi

    export PASSPHRASE
fi

# Actual action begins
mkdir -p "${backup_dir}"

if [[ "${backup_tool}" == "duplicity" ]]; then
    exclude_arguments+=("--exclude")
    exclude_arguments+=(**/tmp*) # TODO confirm this works

    time duplicity --archive-dir "${backup_dir}" --name "${backup_name}" "${exclude_arguments[@]}" / "${duplicity_target_url}"
else
    exclude_arguments+=("--exclude")
    exclude_arguments+=(tmp*) # duplicity does not like this syntax...

    backup_tar_file="${backup_dir}/${backup_name}-${date}.tar.gz"
    backup_tar_checksum_file="${backup_tar_file}.sha256"
    backup_tar_encrypted_file="${backup_tar_file}.gpg"
    backup_tar_encrypted_checksum_file="${backup_tar_encrypted_file}.sha256"

    time tar -cvpzf "${backup_tar_file}" "${exclude_arguments[@]}" /
    time sha256sum "${backup_tar_file}" > ${backup_tar_checksum_file}

    echo ""
    echo ""
    echo "Backup file created: ${backup_tar_file}"
    du -sh "${backup_tar_file}"
    echo "sha256 checksum found in: ${backup_tar_checksum_file}"
    cat "${backup_tar_checksum_file}"

    echo "Encrypting the document with gpg to: ${backup_tar_encrypted_file}"
    gpg --batch --passphrase $PASSPHRASE --output "${backup_tar_encrypted_file}" --symmetric "${backup_tar_file}"
    time sha256sum "${backup_tar_encrypted_file}" > ${backup_tar_encrypted_checksum_file}

    echo "sha256 checksum found in: ${backup_tar_encrypted_checksum_file}"
    cat "${backup_tar_encrypted_checksum_file}"

    split -b 200M "${backup_tar_encrypted_file}" "${backup_tar_encrypted_file}_part_"
fi
