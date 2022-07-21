# MyDistro
My own Linux distro

## Overview
A single shell script to fetch the [Linux kernel](http://kernel.org/) and [BusyBox](https://busybox.net/) source, then build and package them into a bootable 'distro'. 

Busybox is a suite of GNU coreutils *like* utilities but intended for embedded devices, hence small.

The build script produces a kernel bzImage and a compressed, cpio rootfs image. Both of these file can easily be packaged again into a single, bootable ISO file, however I've omitted this for the time being and just pass them into QEMU as two arguments. 

## Pre-requisites
Run the following command to install the required dependencies:

`sudo apt install wget make gawk gcc bc bison flex xorriso libelf-dev libssl-dev grub-common`

`sudo apt install qemu-kvm qemu-utils libvirt-daemon-system libvirt-clients bridge-utils virtinst`

## Usage
**Please note:** Absolutely no warranty is offered, implied or express. Use at your own risk, the author will not be held liable for any damages.

1. Clone this repo locally
2. Execute `./build.sh`
3. The script runs, and once finished, will prompt you to hit enter to proceed with booting the distro
4. The distro boots inside QEMU
5. nb. it will appear to hang after a few seconds, however all going well, it's actually finished booting and now ready to accept BusyBox commands. A good one to start with is `pwd`:
6. 

![image](https://user-images.githubusercontent.com/52075808/180305755-d6dfc5af-6af6-47df-a247-5f0273b9a0a4.png)

## Testing
Following the instructions above, the build script was tested on a clean install of Ubuntu 22.04 LTS running inside VMWare Workstation Pro.

## References
I (Frank Ray) cetainly didn't invent the above, rather I packaged together various ideas and similar approaches I saw elsewhere. I would like pay particular thanks to the following articles (and their authors) for their contribution:
* [Building a tiny Linux kernel](https://weeraman.com/building-a-tiny-linux-kernel-8c07579ae79d)
* [A single script to build a minimal live Linux operating system from source code that runs Doom on boot.](https://medium.com/@shadlyd15/a-single-script-to-build-a-minimal-live-linux-operating-system-from-source-code-that-runs-doom-on-fc4c981b1e5)

And also the most amazing website, [OSDev.org](https://wiki.osdev.org/Main_Page), for sheer inspiration.
