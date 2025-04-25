#!/bin/bash

set -e

make ARCH=aarch64 BOARD=msm all initramfs bootimg

adb wait-for-device
adb reboot bootloader
fastboot boot boot.img
