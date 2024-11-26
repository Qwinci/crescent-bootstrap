#!/usr/bin/env python3

import argparse
import subprocess
import sys

qemu_args = [
	"-drive", "file=image,format=raw",
	"-m", "2G",
	"-M", "q35",
	"-smp", "1",
	"-cpu", "qemu64,+umip,+smep,+smap",
	"-serial", "stdio"
]

parser = argparse.ArgumentParser(description="Run qemu")
parser.add_argument("arch", type=str, help="architecture", default="x86_64")
parser.add_argument("--kvm", action="store_true", help="Use kvm")
parser.add_argument("--debug", action="store_true", help="Wait for gdb attach at localhost:1234")
parser.add_argument("--sound", action="store_true", help="Add a sound device")
args = parser.parse_args()

if args.kvm:
	qemu_args += ["--enable-kvm"]
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
