PXEDIR		= ./pxeboot
BOOTDIR		= $(prefix)/boot
KERNELSRC	= ../src/linux/linux
BUSYBOXSRC	= ../src/busybox/busybox
$(BOOTDIR):
	mkdir -p $(BOOTDIR)
$(BOOTDIR)/ldlinux.c32: $(BOOTDIR)
	cp $(PXEDIR)/ldlinux.c32 $(BOOTDIR)/ldlinux.c32
$(BOOTDIR)/pxelinux.0: $(BOOTDIR) 
	cp $(PXEDIR)/pxelinux.0 $(BOOTDIR)/pxelinux.0
$(BOOTDIR)/pxelinux.cfg: $(BOOTDIR)
	mkdir $(BOOTDIR)/pxelinux.cfg
$(BOOTDIR)/pxelinux.cfg/default: $(BOOTDIR)/pxelinux.cfg
	cp $(PXEDIR)/pxelinux.cfg/default $(BOOTDIR)/pxelinux.cfg/default
$(KERNELSRC)/.config:
	cp linux.config $(KERNELSRC)/.config
$(BUSYBOXSRC)/.config:
	cp busybox.config $(BUSYBOXSRC)/.config

.PHONY: srcconf
srcconf: $(KERNELSRC)/.config $(BUSYBOXSRC)/.config
.PHONY: pxeboot
pxeboot: $(BOOTDIR)/ldlinux.c32 $(BOOTDIR)/pxelinux.0 $(BOOTDIR)/pxelinux.cfg/default


all: pxeboot srcconf
