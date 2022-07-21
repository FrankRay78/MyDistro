#!/bin/sh

#Targets
DOWNLOAD=false
BUILD=false
PACKAGE=true
BOOT=true

KERNEL_VERSION=5.4.205
BUSYBOX_VERSION=1.35.0

SOURCE_DIR=$PWD
ROOTFS=$SOURCE_DIR/rootfs
STAGING=$SOURCE_DIR/staging
ISO_DIR=$SOURCE_DIR/iso



#Exit immediately if a command exits with a non-zero status.
#Print commands and their arguments as they are executed.
set -ex



if [ "$DOWNLOAD" = true ] ; then

#
#DOWNLOADS
#
set -e
rm -fdr $STAGING
mkdir -p $STAGING
set -ex

cd $STAGING

wget -nc -O kernel.tar.xz http://kernel.org/pub/linux/kernel/v5.x/linux-${KERNEL_VERSION}.tar.xz
wget -nc -O busybox.tar.bz2 http://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2

tar -xvf kernel.tar.xz
tar -xvf busybox.tar.bz2

fi



if [ "$BUILD" = true ] ; then

#
#LINUX KERNEL
#
cd $STAGING/linux-${KERNEL_VERSION}

#make -j$(nproc) tinyconfig
#make -j$(nproc) kvmconfig
make -j$(nproc) defconfig
scripts/config --set-str CONFIG_DEFAULT_HOSTNAME "MyDistro"

make bzImage -j$(nproc)
make headers_install -j$(nproc)


#
#BUSYBOX
#
cd $STAGING/busybox-${BUSYBOX_VERSION}

make defconfig
LDFLAGS="--static" make busybox install -j$(nproc)

#Remove linuxrc as we aren't using initrd
rm -f _install/linuxrc

fi



if [ "$PACKAGE" = true ] ; then

set -e
rm -fdr $ROOTFS
mkdir -p $ROOTFS

rm -fdr $ISO_DIR
mkdir -p $ISO_DIR/boot
set -ex


cp $STAGING/linux-${KERNEL_VERSION}/arch/x86/boot/bzImage $ISO_DIR/boot/bzImage
cp $STAGING/linux-${KERNEL_VERSION}/System.map $ISO_DIR/boot/System.map
cp -r $STAGING/linux-${KERNEL_VERSION}/include $ROOTFS/include
cp -r $STAGING/busybox-${BUSYBOX_VERSION}/_install/* $ROOTFS/


cd $ROOTFS

mkdir --parents bin dev etc lib lib64 mnt/root proc root sbin sys
mkdir --parents dev/sda1

#6.8. Populating /dev (Linux From Scratch)
#https://tldp.org/LDP/lfs/LFS-BOOK-6.1.1-HTML/chapter06/devices.html
sudo mknod dev/null    c 1 3
sudo mknod dev/ttyS0   c 4 64
sudo mknod dev/console c 5 1

echo '#!/bin/sh' > init
echo 'mount -t devtmpfs none /dev' >> init
echo 'mount -t proc none /proc' >> init
echo 'mount -t sysfs none /sys' >> init
echo 'setsid cttyhack sh' >> init
echo 'exec /bin/sh' >> init

chmod a+x init


find . | cpio -R root:root -H newc -o | gzip > $ISO_DIR/boot/initramfs.cpio.gz

fi



set +ex



if [ "$BOOT" = true ] ; then

echo '-------------------------------------------'
echo 'Press enter to boot the newly build distro...'
echo '-------------------------------------------'
read _

#Troubleshooting
#https://nickdesaulniers.github.io/blog/2018/10/24/booting-a-custom-linux-kernel-in-qemu-and-debugging-it-with-gdb/
#https://sthbrx.github.io/blog/2017/01/30/extracting-early-boot-messages-in-qemu/
#https://superuser.com/questions/1087859/how-to-quit-the-qemu-monitor-when-not-using-a-gui

qemu-system-x86_64 -kernel $ISO_DIR/boot/bzImage -initrd $ISO_DIR/boot/initramfs.cpio.gz -nographic -append "root=/dev/sda1 rdinit=/init console=ttyS0"

fi