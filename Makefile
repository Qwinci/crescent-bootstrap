ARCH ?= x86_64

current_dir = $(shell pwd)

all:
	qpkg --config=$(current_dir)/qpkg_$(ARCH).toml rebuild crescent crescent-apps

initramfs:
	tar -cf initramfs.tar -C sysroot .

create_image:
	IMAGE_SIZE=2G LIMINE_PATH="$(current_dir)/build/host_pkgs/limine/share/limine" \
	./scripts/create_image.sh

update_image: initramfs
	BUILD_DIR="$(current_dir)" ./scripts/update_image.sh

run:
	./scripts/qemu.py $(ARCH)

run-kvm:
	./scripts/qemu.py $(ARCH) --kvm

debug:
	./scripts/qemu.py $(ARCH) --debug

debug-kvm:
	./scripts/qemu.py $(ARCH) --kvm --debug

