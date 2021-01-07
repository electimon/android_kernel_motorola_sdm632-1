#!/bin/bash
# Setup Variables
export ARCH=arm64
export CROSS_COMPILE=/srv/root/build/android/rvgR/prebuilts/gcc/linux-x86/aarch64/arm64-gcc/bin/aarch64-elf-
export CROSS_COMPILE_ARM32=/srv/root/build/android/los17.1/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
export DEVICE=$1
export MAKEFLAGS="O=out -j24"
cd `dirname $0`
export KERNDIR=`pwd`
export AZURREVISION=${KERNDIR: -1}

# Setup Functions
needExitCheck () {
	if [[ $NEEDSEXIT == "1" ]]; then
		echo "Well well well, looks like something went wrong..."
		if [[ `cat build.log` == *"default configuration"* ]]; then
			exit 1
		else
			exit 0
		fi
	fi
}

# Generate defconfig
make ${DEVICE}_defconfig &> build.log || export NEEDSEXIT=1

needExitCheck

# Build the kernel!
make &> build.log || export NEEDSEXIT=1

needExitCheck

# Setup revision control
if [[ -f ${DEVICE}revision ]]; then
        OLDRE=`cat ${DEVICE}revision`
	echo ${OLDRE}+1 | bc > ${DEVICE}revision
else
	echo 1 > ${DEVICE}revision
fi
export KERNELREVISION=`cat ${DEVICE}revision`

# Obtain the goodness
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel3${DEVICE}
cp out/arch/arm64/boot/dtbo.img AnyKernel3${DEVICE}

# Zip it up
cd AnyKernel3${DEVICE}
zip -r9 AzurElectricR${AZURREVISION}-${DEVICE}-${KERNELREVISION}.zip * -x .git README.md *placeholder

# Move it for all to see
mv *.zip /var/www/html/kernels/${DEVICE}/

# Cleanup
rm -rf dtbo.img Image.gz-dtb
