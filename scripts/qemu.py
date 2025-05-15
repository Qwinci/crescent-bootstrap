#!/usr/bin/env python3

import argparse
import subprocess
import sys

parser = argparse.ArgumentParser(description="Run qemu")
parser.add_argument("arch", type=str, help="architecture", default="x86_64")
parser.add_argument("--kvm", action="store_true", help="Use kvm")
parser.add_argument("--debug", action="store_true", help="Wait for gdb attach at localhost:1234")
parser.add_argument("--sound", action="store_true", help="Add a sound device")
args = parser.parse_args()

if args.arch == "x86_64":
	qemu_args = [
		"-drive", "file=image_x86_64,format=raw",
		"-m", "2G",
		"-M", "q35",
		"-smp", "1",
		"-cpu", "qemu64,+umip,+smep,+smap",
		"-serial", "stdio",
		#"-device", "nvme,serial=deadbeef"
		"-netdev", "user,id=net0,hostfwd=tcp::4321-:4321",
		"-device", "rtl8139,netdev=net0",
		#"-object", "filter-dump,id=fl0,netdev=net0,file=netdump.dat",
		"-device", "ich9-intel-hda,msi=on",
		"-device", "hda-output,audiodev=hda",
		"-audiodev", "pa,id=hda"
	]
elif args.arch == "aarch64":
	qemu_args = [
		"-M", "virt,gic-version=3",
		"-cpu", "cortex-a76",
		"-m", "1G",
		"-smp", "20",
		"-serial", "stdio",
		"-device", "ramfb",
		"-kernel", "sysroot_aarch64/usr/crescent/crescent.bin",
		"-initrd", "initramfs_aarch64.tar"
	]

if args.kvm:
	qemu_args += ["--enable-kvm", "-cpu", "host"]
if args.debug:
	qemu_args += ["-S", "-s"]

if args.sound:
	qemu_args += [
		"-device", "ich9-intel-hda,bus=pcie.0,addr=0x1B",
		"-device", "hda-output,audiodev=hda",
		"-audiodev", "pa,id=hda"
	]

qemu = "qemu-system-{}".format(args.arch)

print("Running qemu")
try:
	subprocess.check_call([qemu, *qemu_args])
except subprocess.CalledProcessError:
	sys.exit(1)
