ARCH ?= x86_64
BOARD ?= virt

current_dir = $(shell pwd)

initrd = "$(current_dir)/initramfs_$(ARCH).tar"

DTB ?= "$(current_dir)/dtb"

all:
	CRESCENT_BOARD=$(BOARD) qpkg --config=$(current_dir)/qpkg_$(ARCH).toml rebuild crescent

initramfs:
	tar -cf $(initrd) -C sysroot_$(ARCH) .

create_image:
	IMAGE_SIZE=2G LIMINE_PATH="$(current_dir)/build_$(ARCH)/host_pkgs/limine/share/limine" \
	IMAGE_PATH=image_$(ARCH) ./scripts/create_image.sh

update_image: initramfs
	BUILD_DIR="$(current_dir)" IMAGE_PATH=image_$(ARCH) ARCH=$(ARCH) ./scripts/update_image.sh

bootimg: initramfs
	mkbootimg \
		--header_version 2 \
		--os_version 11.0.0 \
		--os_patch_level 2024-03 \
		--kernel "$(current_dir)/sysroot_$(ARCH)/usr/crescent/crescent.bin" \
		--ramdisk "$(initrd)" \
		--dtb $(DTB) \
		--cmdline '' \
		-o boot.img

run:
	./scripts/qemu.py $(ARCH)

run-kvm:
	./scripts/qemu.py $(ARCH) --kvm

debug:
	./scripts/qemu.py $(ARCH) --debug

debug-kvm:
	./scripts/qemu.py $(ARCH) --kvm --debug

