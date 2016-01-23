kdev
=============================

Linux kernel development and testing environment

Installation
------------

    $ ./autogen.sh
    $ ./configure
    $ make
    $ sudo make install

The default install prefix is /tmp, which means that
the rootfs and pxe boot directory will be placed there.
This can be changed with ./configure --prefix=/path 
