#!/bin/sh

if [[ -z "${BUILD_DIR}" ]]; then
	echo "BUILD_DIR is unset" 1>&2
	exit 1
fi

if [[ -z "${ARCH}" ]]; then
	echo "ARCH is unset" 1>&2
	exit 1
fi

if [[ -z "${IMAGE_PATH}" ]]; then
	echo "IMAGE_PATH is unset" 1>&2
	exit 1
fi

files="
$BUILD_DIR/sysroot_$ARCH/usr/crescent/crescent
$BUILD_DIR/sysroot_$ARCH/usr/crescent/limine.conf
$BUILD_DIR/initramfs_$ARCH.tar
"

loop_dev=$(sudo losetup -Pf --show "$IMAGE_PATH")

mkdir -p mountpoint
sudo mount "${loop_dev}p1" mountpoint
sudo rsync -a --delete --no-perms --no-group --no-owner --no-links "$BUILD_DIR/sysroot_$ARCH/usr/" mountpoint/usr
sudo cp $files mountpoint

sudo umount mountpoint

sudo losetup -d "${loop_dev}"

