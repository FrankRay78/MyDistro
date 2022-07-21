# MyDistro
My own Linux distro

## Overview
A single shell script to fetch the linux kernel and busybox source, then build and package them into a bootable 'distro'. 

Busybox is a suite of GNU coreutils type utilities but intended for embedded devices, hence small.

The 'build' shell script produces a kernel bzImage and a compressed, cpio rootfs image. Both of these file can easily be packaged again into a single, bootable ISO file, however I've ommitted this for the time being and just pass them into QEMU as two arguments. 
