PXEDIR = ./pxeboot
BOOTDIR = ../boot

$(BOOTDIR):
	mkdir $(BOOTDIR)
$(BOOTDIR)/ldlinux.c32: $(BOOTDIR)
	cp $(PXEDIR)/ldlinux.c32 $(BOOTDIR)/ldlinux.c32
$(BOOTDIR)/pxelinux.0: $(BOOTDIR) 
	cp $(PXEDIR)/pxelinux.0 $(BOOTDIR)/pxelinux.0
$(BOOTDIR)/pxelinux.cfg: $(BOOTDIR)
	mkdir $(BOOTDIR)/pxelinux.cfg
$(BOOTDIR)/pxelinux.cfg/default: $(BOOTDIR)/pxelinux.cfg
	cp $(PXEDIR)/pxelinux.cfg/default $(BOOTDIR)/pxelinux.cfg/default
all: $(BOOTDIR)/ldlinux.c32 $(BOOTDIR)/pxelinux.0 $(BOOTDIR)/pxelinux.cfg/default
