PXEDIR		= ./pxeboot
BOOTDIR		= $(prefix)/boot
ETCDIR		= $(prefix)/rootfs/etc/
$(BOOTDIR):
	mkdir -p $(BOOTDIR)
$(BOOTDIR)/ldlinux.c32: $(BOOTDIR)
	cp $(PXEDIR)/ldlinux.c32 $(BOOTDIR)/ldlinux.c32
$(BOOTDIR)/pxelinux.0: $(BOOTDIR) 
	cp $(PXEDIR)/pxelinux.0 $(BOOTDIR)/pxelinux.0
$(BOOTDIR)/pxelinux.cfg: $(BOOTDIR)
	mkdir -p $(BOOTDIR)/pxelinux.cfg
$(BOOTDIR)/pxelinux.cfg/default: $(BOOTDIR)/pxelinux.cfg
	cp $(PXEDIR)/pxelinux.cfg/default $(BOOTDIR)/pxelinux.cfg/default
$(ETCDIR):
	mkdir -p $(ETCDIR)
	cp -r ./etc/* $(ETCDIR)

.PHONY:etc
etc: $(ETCDIR) 

.PHONY: pxeboot
pxeboot: $(BOOTDIR)/ldlinux.c32 $(BOOTDIR)/pxelinux.0 $(BOOTDIR)/pxelinux.cfg/default

install-exec-hook: pxeboot etc
