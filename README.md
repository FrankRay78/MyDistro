# MyDistro
My own Linux distro

## Overview
A single shell script to fetch the linux kernel and busybox source, then build and package them into a bootable 'distro'. 

Busybox is a suite of GNU coreutils type utilities but intended for embedded devices, hence small.

The `build` script produces a kernel bzImage and a compressed, cpio rootfs image. Both of these file can easily be packaged again into a single, bootable ISO file, however I've ommitted this for the time being and just pass them into QEMU as two arguments. 

## Pre-requisites
Run the following command to install the required dependencies:
`sudo apt install`

## Usage
1. Clone the repo locally
2. Execute `.build.sh`
3. The script runs, and once finished, will prompt you to hit enter to proceed with booting the distro
4. The distro boots inside QEMU - nb. it will appear to hang after a few seconds, however all going well, it's actually finished booting and now ready to accept BusyBox commands. A good one to start with is `pwd`:


## Testing

Following the instructions above, the build script has been tested on a clean install of Ubuntu 22.04 LTS running inside VMWare Workstation Pro
