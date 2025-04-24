#!/bin/bash
#===============================================
# Description: DIY script part 1
# File name: diy-part1.sh
# Lisence: MIT
# By: Jejz
#===============================================

# Add a feed source
sed -i "/helloworld/d" feeds.conf.default
# sed -i '$a src-git Jejz https://github.com/Jejz168/openwrt-packages' feeds.conf.default
# sed -i '$a src-git helloworld https://github.com/fw876/helloworld' feeds.conf.default
# sed -i '$a src-git PWpackages https://github.com/xiaorouji/openwrt-passwall.git;packages' feeds.conf.default



cat>rename.sh<<-\EOF
#!/bin/bash
# 删除无关的文件
ls -l bin/targets/x86/64/
rm -rf  bin/targets/x86/64/config.buildinfo
rm -rf  bin/targets/x86/64/feeds.buildinfo
rm -rf  bin/targets/x86/64/openwrt-x86-64-generic-kernel.bin
rm -rf  bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined-efi.vmdk
rm -rf  bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined.vmdk
rm -rf  bin/targets/x86/64/openwrt-x86-64-generic-squashfs-rootfs.img.gz
rm -rf  bin/targets/x86/64/openwrt-x86-64-generic.manifest
rm -rf  bin/targets/x86/64/sha256sums
rm -rf  bin/targets/x86/64/version.buildinfo
rm -rf  bin/targets/x86/64/profiles.json

# 暂停 2 秒
sleep 2

# 获取默认内核版本号（例如：5.10）
kernel_version=$(grep "KERNEL_PATCHVER:=" target/linux/x86/Makefile | cut -d "=" -f 2 | xargs)

# 获取补丁版本号，若不存在则默认为0
patch_version=$( (grep "LINUX_VERSION-${kernel_version} =" include/kernel-${kernel_version} 2>/dev/null || \
                  grep "LINUX_VERSION-${kernel_version} =" target/linux/generic/kernel-${kernel_version} 2>/dev/null) | \
                cut -d "." -f 3)
patch_version=${patch_version:-0}

Kernel="${kernel_version}.${patch_version}"
echo "Kernel Version: $Kernel"

# 文件重命名
if [ -f "bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined.img.gz" ]; then
    mv bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined.img.gz \
       bin/targets/x86/64/openwrt_x86-64_${kernel_version}.${patch_version}_bios.img.gz
else
    echo "Error: File openwrt-x86-64-generic-squashfs-combined.img.gz not found!"
    exit 1
fi

if [ -f "bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined-efi.img.gz" ]; then
    mv bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined-efi.img.gz \
       bin/targets/x86/64/openwrt_x86-64_${kernel_version}.${patch_version}_uefi.img.gz
else
    echo "Error: File openwrt-x86-64-generic-squashfs-combined-efi.img.gz not found!"
    exit 1
fi

# 直接指定文件名
openwrt_dev="openwrt_x86-64_${kernel_version}.${patch_version}_bios.img.gz"
openwrt_dev_uefi="openwrt_x86-64_${kernel_version}.${patch_version}_uefi.img.gz"

# 生成 MD5 校验和
cd bin/targets/x86/64  || exit 1

if [ -f "$openwrt_dev" ]; then
    md5sum "$openwrt_dev" > openwrt_bios.md5
else
    echo "Error: File $openwrt_dev not found!"
    exit 1
fi

if [ -f "$openwrt_dev_uefi" ]; then
    md5sum "$openwrt_dev_uefi" > openwrt_uefi.md5
else
    echo "Error: File $openwrt_dev_uefi not found!"
    exit 1
fi
exit 0
EOF
