ACLOCAL_AMFLAGS = -I m4
SUBDIRS        = skel src
EXTRA_DIST     = get-version autogen.sh

dist-hook:
	echo $(VERSION) > $(distdir)/.dist-version

install-data-hook:
	echo "Build initramfs from $(prefix)/rootfs"
	(cd $(prefix)/rootfs && find . | cpio --owner 0:0 -H newc -o | \
	gzip > $(prefix)/boot/initramfs.cpio.gz)
