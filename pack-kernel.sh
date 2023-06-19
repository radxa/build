#!/bin/bash

usage() {
    echo "====USAGE: pack-kernel.sh -d <kernel defconfig> -r <release_number>===="
    echo "pack-kernel.sh -d rockchip_linux_defconfig -r 1"
}

while getopts "d:r:h" flag; do
    case $flag in
        d)
            export KERNEL_DEFCONFIG="$OPTARG"
            ;;
        r)
            export RELEASE_NUMBER="$OPTARG"
            ;;
    esac
done

if [ ! $KERNEL_DEFCONFIG ] && [ ! $RELEASE_NUMBER ]; then
    usage
    exit
fi

CMD=`realpath $0`
BUILD_DIR=`dirname $CMD`
ROCKCHIP_BSP_DIR=$(realpath $BUILD_DIR/..)
PACKAGES_DIR=$ROCKCHIP_BSP_DIR/out/packages
[ ! -d "$PACKAGES_DIR" ] && mkdir -p $PACKAGES_DIR
KERNEL_DIR=$ROCKCHIP_BSP_DIR/kernel

#build on native arm64
if [ "X$(uname -m)" == "Xaarch64" ]; then
        export KERNEL_MAKE="make"
fi

echo -e "\e[31m Start to pack kernel. \e[0m"
cd ${KERNEL_DIR} && make distclean && make -f $ROCKCHIP_BSP_DIR/build/kernel-package.mk kernel-package

mv $ROCKCHIP_BSP_DIR/linux-*${RELEASE_NUMBER}-rockchip*.deb $PACKAGES_DIR
mv $ROCKCHIP_BSP_DIR/linux-*${RELEASE_NUMBER}-rockchip*.changes $PACKAGES_DIR
echo -e "\e[31m Packing kernel is done. \e[0m"
