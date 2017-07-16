#!/bin/bash
#
# null oneplus2 build script
#
clear

# Resources
THREAD="-j4"
KERNEL="Image.gz-dtb"
DEFCONFIG="oneplus2_defconfig"
DEVICE="oneplus2"

# Kernel Details
VARIANT=$(date +"%Y%m%d")
export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE=${HOME}/Android/ToolChains/aarch64-linux-android-4.9/bin/aarch64-linux-android-

# Paths
KERNEL_DIR="${HOME}/Android/kernel/lios"
ANYKERNEL_DIR="$KERNEL_DIR/anykernel2"
MODULES_DIR="$ANYKERNEL_DIR/modules"
ZIP_MOVE_NIGHTLY="${HOME}/Android/kernel/one_plus_2/out/$DEVICE"
ZIMAGE_DIR="$KERNEL_DIR/arch/arm64/boot"

# Functions
function clean_all {
		echo
		find . -name "*~" -type f -delete
		rm -rf $ANYKERNEL_DIR/$KERNEL
		rm -rf $MODULES_DIR/*
		make clean && make mrproper
}

function make_kernel {
		echo
		make $DEFCONFIG
		make $THREAD
}

function make_zip {
		cp -vr $ZIMAGE_DIR/$KERNEL $ANYKERNEL_DIR/$KERNEL
		cd $ANYKERNEL_DIR
		zip -r9 tocino-$DEVICE-$KERNEL_VER.zip *
		mv tocino-$DEVICE-$KERNEL_VER.zip $ZIP_MOVE_NIGHTLY
		cd $KERNEL_DIR
}

cat << "EOF"

icon placeholder

EOF

echo "You are building lios kernel $KERNEL_VER for $DEVICE";
echo

while read -p "Do you want to clean stuffs (y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
		clean_all
		echo
		echo "All Cleaned now."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to build kernel (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		DATE_START=$(date +"%s")
		make_kernel
		if [ -f $ZIMAGE_DIR/$KERNEL ];
		then
			make_zip
		else
			echo
			echo "Kernel build failed."
			echo
		fi
		break
		;;
	n|N )
		DATE_START=$(date +"%s")
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo
