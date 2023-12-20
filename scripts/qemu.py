#!/usr/bin/env python3

import argparse
import subprocess
import sys

qemu_args = [
	"-drive", "file=image,format=raw",
	"-m", "2G",
	"-M", "q35",
	"-smp", "4",
	"-no-reboot",
	"-no-shutdown",
	"-cpu", "qemu64,+umip,+smep,+smap",
	"-device", "ich9-intel-hda,bus=pcie.0,addr=0x1B",
	"-device", "hda-output,audiodev=hda",
	"-audiodev", "pa,id=hda",
	"-serial", "stdio"
]

parser = argparse.ArgumentParser(description="Run qemu")
parser.add_argument("arch", type=str, help="architecture")
parser.add_argument("--kvm", action="store_true", help="Use kvm")
parser.add_argument("--debug", action="store_true", help="Wait for gdb attach at localhost:1234")
args = parser.parse_args()

if args.kvm:
	qemu_args += ["--enable-kvm"]
if args.debug:
	qemu_args += ["-S", "-s"]

qemu = "qemu-system-{}".format(args.arch)

print("Running qemu")
try:
	subprocess.check_call([qemu, *qemu_args])
except subprocess.CalledProcessError:
	sys.exit(1)
