#!/bin/sh

if [[ -z "${LIMINE_PATH}" ]]; then
	echo "LIMINE_PATH is unset" 1>&2
	exit 1
fi

rm -f image
fallocate -l 2G image

parted -s image mklabel gpt
parted -s image mkpart ESP fat32 2048s 100%

loop_dev=$(sudo losetup -Pf --show image)
sudo mkfs.vfat -F32 "${loop_dev}p1"

mkdir -p mountpoint
sudo mount "${loop_dev}p1" mountpoint

sudo mkdir mountpoint/usr
sudo mkdir mountpoint/etc
sudo cp "$LIMINE_PATH/limine-bios.sys" mountpoint
sudo mkdir mountpoint/EFI/BOOT
sudo cp "$LIMINE_PATH/BOOTX64.EFI" mountpoint/EFI/BOOT
sudo "$LIMINE_PATH/limine" bios-install "${loop_dev}"

sudo umount mountpoint

sudo losetup -d "${loop_dev}"
