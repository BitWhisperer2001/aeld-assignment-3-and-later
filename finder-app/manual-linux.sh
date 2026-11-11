#!/bin/bash
# Script outline to install and build kernel.
# Author: MrChi

set -e
set -u

OUTDIR=/tmp/aeld
KERNEL_REPO=git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
KERNEL_VERSION=v5.15.163
BUSYBOX_VERSION=1_33_1
FINDER_APP_DIR=$(realpath $(dirname $0))
ARCH=arm64
CROSS_COMPILE=aarch64-none-linux-gnu-

if [ $# -lt 1 ]
then
	echo "Using default directory ${OUTDIR} for output"
else
	OUTDIR=$1
	echo "Using passed directory ${OUTDIR} for output"
fi

mkdir -p ${OUTDIR}

cd "$OUTDIR"

echo "Creating the staging directory for the root filesystem"
cd "$OUTDIR"
if [ -d "${OUTDIR}/rootfs" ]
then
	echo "Deleting rootfs directory at ${OUTDIR}/rootfs and starting over"
	echo 1 | sudo -S rm -rf ${OUTDIR}/rootfs
fi

# TODO: Create necessary base directories
echo 1 | sudo -S mkdir rootfs
cd rootfs
echo 1 | sudo -S mkdir -p bin sbin dev etc lib lib64 proc sys tmp usr var home
echo 1 | sudo -S mkdir -p usr/bin usr/lib usr/sbin
echo 1 | sudo -S mkdir -p var/log
cd ..
echo 1 | sudo -S chmod -R 777 rootfs

cd "$OUTDIR"
if [ ! -d "${OUTDIR}/busybox" ]
then
    git clone git://busybox.net/busybox.git
    cd busybox
    git checkout ${BUSYBOX_VERSION}
    # TODO:  Configure busybox
    make distclean
    make ARCH=$ARCH CROSS_COMPILE=${CROSS_COMPILE} defconfig
else
    cd busybox
fi

# TODO: Add library dependencies to rootfs
SYSROOT=$(${CROSS_COMPILE}gcc -print-sysroot)

# TODO: Make device nodes
echo "Make node"
echo 1 | sudo -S mknod -m 666 ${OUTDIR}/rootfs/dev/null c 1 3
echo 1 | sudo -S mknod -m 666 ${OUTDIR}/rootfs/dev/console c 5 1

# TODO: Clean and build the writer utility
echo "$(pwd)"
cd /
echo "$(ls)"
cd home
echo "$(ls)"
cd autotest-admin
echo "$(ls)"






make clean
make CROSS_COMPILE=${CROSS_COMPILE}gcc
