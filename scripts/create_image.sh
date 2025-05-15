#!/bin/sh

if [[ -z "${LIMINE_PATH}" ]]; then
	echo "LIMINE_PATH is unset" 1>&2
	exit 1
fi

if [[ -z "${IMAGE_SIZE}" ]]; then
	echo "IMAGE_SIZE is unset" 1>&2
	exit 1
fi

if [[ -z "${IMAGE_PATH}" ]]; then
	echo "IMAGE_PATH is unset" 1>&2
	exit 1
fi

rm -f "$IMAGE_PATH"
fallocate -l ${IMAGE_SIZE} "$IMAGE_PATH"

parted -s "$IMAGE_PATH" mklabel gpt
parted -s "$IMAGE_PATH" mkpart ESP fat32 2048s 100%

loop_dev=$(sudo losetup -Pf --show "$IMAGE_PATH")
sudo mkfs.vfat -F32 "${loop_dev}p1"

mkdir -p mountpoint
sudo mount "${loop_dev}p1" mountpoint

sudo mkdir mountpoint/usr
sudo cp "$LIMINE_PATH/limine-bios.sys" mountpoint
sudo mkdir -p mountpoint/EFI/BOOT
sudo cp "$LIMINE_PATH/BOOTX64.EFI" mountpoint/EFI/BOOT
sudo "$LIMINE_PATH/limine" bios-install "${loop_dev}"

sudo umount mountpoint

sudo losetup -d "${loop_dev}"

