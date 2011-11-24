#!/bin/bash

if [ "$1" == "DEBUG" ]; then
	echo '##################### DEBUG VERSION #################'
	sed -i 's/# CONFIG_FRAMEBUFFER_CONSOLE is not set/CONFIG_FRAMEBUFFER_CONSOLE=y/' .config
	sed -i 's/# CONFIG_CMDLINE_FORCE is not set/CONFIG_CMDLINE_FORCE=y/' .config
	DEBUG=1
else
	sed -i 's/CONFIG_FRAMEBUFFER_CONSOLE=y/# CONFIG_FRAMEBUFFER_CONSOLE is not set/' .config
	sed -i 's/CONFIG_CMDLINE_FORCE=y/# CONFIG_CMDLINE_FORCE is not set/' .config
	DEBUG=0
fi

RELVER=`cat .version`
##let RELVER=RELVER+1

#ensure there is no more old bcm4329 module
rm drivers/net/wireless/bcm4329/bcm4329.ko drivers/net/wireless/bcmdhd/bcm4329.ko

TEST=experimental

. ./setenv.sh

#echo "building kernel with voodoo color"
#sed -i 's/^.*FB_VOODOO.*$//' .config
#echo 'CONFIG_FB_VOODOO=y
## CONFIG_FB_VOODOO_DEBUG_LOG is not set' >> .config

make -j8

echo "creating boot.img "
$ANDROID_BUILD_TOP/device/samsung/aries-common/mkshbootimg.py release/boot.img arch/arm/boot/zImage $ANDROID_BUILD_TOP/out/target/product/galaxysmtd/ramdisk.img $ANDROID_BUILD_TOP/out/target/product/galaxysmtd/ramdisk-recovery.img

echo "launching packaging script"
. release/doit.sh ${RELVER}v


