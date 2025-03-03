#!/usr/bin/env bash
# apt install cryptsetup

while [[ $# -gt 0 ]]
do
    case $1 in
        --action)
            action=$2
            shift 2
            ;;
        --file)
            horse_file=$(realpath "$2")
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

if [ -z "${horse_file}" ]; then
    echo "Arguments error!"
    exit 1
fi

horse_unique="horse-${horse_file//\//-}"
horse_container_dir="/dev/mapper/${horse_unique}"
horse_mnt_dir=/mnt/${horse_unique}

case $action in
    create)
        fallocate --length 1GiB "${horse_file}"
        cryptsetup luksFormat "${horse_file}"
        cryptsetup luksOpen "${horse_file}" "${horse_unique}"
        mkfs.ext4 "${horse_container_dir}"
        cryptsetup luksClose "${horse_unique}"
        ;;
    open)
        mkdir "${horse_mnt_dir}"
        cryptsetup luksOpen "${horse_file}" "${horse_unique}" && mount "${horse_container_dir}" "${horse_mnt_dir}" && chmod go-rwx "${horse_mnt_dir}"
        ;;
    close)
        umount "${horse_mnt_dir}" && cryptsetup luksClose "${horse_unique}" && rm -r "${horse_mnt_dir}"
        ;;
esac
