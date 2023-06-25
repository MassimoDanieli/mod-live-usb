
# also change in archiso/liveusb/profiledef.sh
VERSION = 9

all: iso

# step 1: build toolchain

toolchain: toolchain/.stamp_built

toolchain/.stamp_built: toolchain/build.sh toolchain/Dockerfile
	./$<

# step 2a: build common bootstrap packages

bootstrap: bootstrap/.stamp_built

bootstrap/.stamp_built: bootstrap/build.sh toolchain
	./$<

# step 2b: build plugins bootstrap

plugins-bootstrap: plugins/.stamp_built

plugins/.stamp_built: plugins/build.sh plugins/Dockerfile toolchain
	./$<

# step 3a: build mod-os image

mod-os: mod-os/.stamp_built

mod-os/.stamp_built: mod-os/build.sh mod-os/Dockerfile bootstrap
	./$<

# step 3b: build plugins

plugins: plugins-bootstrap
	$(MAKE) -C plugins

# .PHONY: plugins

# step 6: build ISO

iso: archiso/output/mod-live-usb-v$(VERSION)-x86_64.iso

archiso/output/%.iso: archiso/build.sh archiso/Dockerfile archiso/liveusb/packages.x86_64 mod-os
	./$<

run:
	./archiso/run_archiso.sh -i ./archiso/output/mod-live-usb-v$(VERSION)-x86_64.iso
