export DEVICE=$1
export ARCH=arm64
export CROSS_COMPILE=/srv/root/build/android/rvgR/prebuilts/gcc/linux-x86/aarch64/arm64-gcc/bin/aarch64-elf-
export CROSS_COMPILE_ARM32=/srv/root/build/android/halium10/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-

if [[ $DEVICE == "ocean" ]];
then
make O=out -j24 ocean_defconfig
make O=out -j24
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel3Ocean/
cp out/arch/arm64/boot/dtbo.img AnyKernel3Ocean/
cd AnyKernel3Ocean

misato=n

if [[ misato == "y" ]];
then
zip -r9 AzurElectricR5-G7P.zip * -x .git README.md *placeholder
else
zip -r9 a.zip * -x .git README.md *placeholder
fi

mv *.zip /var/www/html/

rm -rf *.zip Image.gz-dtb dtbo.img
fi

if [[ $DEVICE == "ginna" ]];
then
make O=out -j24 ginna_defconfig
make O=out -j24
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel3Ginna/
cp out/arch/arm64/boot/dtbo.img AnyKernel3Ginna/
cd AnyKernel3Ginna

misato=n

if [[ misato == "y" ]];
then
zip -r9 AzurElectricR5-E7.zip * -x .git README.md *placeholder
else
zip -r9 a.zip * -x .git README.md *placeholder
fi

mv *.zip /var/www/html/

rm -rf *.zip Image.gz-dtb dtbo.img
fi
