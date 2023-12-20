#!/bin/sh

if [[ -z "${BUILD_DIR}" ]]; then
	echo "BUILD_DIR is unset" 1>&2
	exit 1
fi

files="
$BUILD_DIR/system-root/usr/crescent/crescent
$BUILD_DIR/system-root/usr/crescent/Tamsyn8x16r.psf
$BUILD_DIR/system-root/usr/crescent/limine.cfg
$BUILD_DIR/initramfs.tar
"

loop_dev=$(sudo losetup -Pf --show image)

mkdir -p mountpoint
sudo mount "${loop_dev}p1" mountpoint
sudo rsync -a --delete --no-perms --no-group --no-owner "$BUILD_DIR/system-root/usr/" mountpoint/usr
sudo rsync -a --delete --no-perms --no-group --no-owner "$BUILD_DIR/system-root/etc/" mountpoint/etc
sudo cp $files mountpoint

sudo umount mountpoint

sudo losetup -d "${loop_dev}"
