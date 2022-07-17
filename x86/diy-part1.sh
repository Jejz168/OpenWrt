#!/bin/bash
#===============================================
# Description: DIY script part 1
# File name: diy-part1.sh
# Lisence: MIT
# Author: P3TERX
# By：Jejz
# Blog: https://p3terx.com
#===============================================

# Add a feed source
sed -i "/helloworld/d" "feeds.conf.default"
echo "src-git helloworld https://github.com/fw876/helloworld.git" >> "feeds.conf.default"
echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall;packages' >>feeds.conf.default




mkdir wget

cat>rename.sh<<-\EOF
#!/bin/bash
rm -rf  bin/targets/x86/64/config.buildinfo
rm -rf  bin/targets/x86/64/feeds.buildinfo
rm -rf  bin/targets/x86/64/openwrt-x86-64-generic-kernel.bin
rm -rf  bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined-efi.vmdk
rm -rf  bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined.vmdk
rm -rf  bin/targets/x86/64/openwrt-x86-64-generic-squashfs-rootfs.img.gz
rm -rf  bin/targets/x86/64/openwrt-x86-64-generic.manifest
rm -rf bin/targets/x86/64/sha256sums
rm -rf  bin/targets/x86/64/version.buildinfo
sleep 2
str1=`grep "KERNEL_PATCHVER:="  target/linux/x86/Makefile | cut -d = -f 2` #判断当前默认内核版本号如5.10
ver54=`grep "LINUX_VERSION-5.4 ="  include/kernel-5.4 | cut -d . -f 3`
ver510=`grep "LINUX_VERSION-5.10 ="  include/kernel-5.10 | cut -d . -f 3`
ver515=`grep "LINUX_VERSION-5.15 ="  include/kernel-5.15 | cut -d . -f 3`
ver518=`grep "LINUX_VERSION-5.18 ="  include/kernel-5.18 | cut -d . -f 3`
ver519=`grep "LINUX_VERSION-5.19 ="  include/kernel-5.19 | cut -d . -f 3`
if [ "$str1" = "5.4" ];then
   mv  bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined.img.gz       bin/targets/x86/64/openwrt_x86-64_${str1}.${ver54}_bios.img.gz
   mv  bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined-efi.img.gz   bin/targets/x86/64/openwrt_x86-64_${str1}.${ver54}_uefi.img.gz
elif [ "$str1" = "5.10" ];then
   mv  bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined.img.gz       bin/targets/x86/64/openwrt_x86-64_${str1}.${ver510}_bios.img.gz
   mv  bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined-efi.img.gz   bin/targets/x86/64/openwrt_x86-64_${str1}.${ver510}_uefi.img.gz
elif [ "$str1" = "5.15" ];then
   mv  bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined.img.gz       bin/targets/x86/64/openwrt_x86-64_${str1}.${ver515}_bios.img.gz
   mv  bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined-efi.img.gz   bin/targets/x86/64/openwrt_x86-64_${str1}.${ver515}_uefi.img.gz
elif [ "$str1" = "5.18" ];then
   mv  bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined.img.gz       bin/targets/x86/64/openwrt_x86-64_${str1}.${ver518}_bios.img.gz
   mv  bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined-efi.img.gz   bin/targets/x86/64/openwrt_x86-64_${str1}.${ver518}_uefi.img.gz   
elif [ "$str1" = "5.19" ];then
   mv  bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined.img.gz       bin/targets/x86/64/openwrt_x86-64_${str1}.${ver519}_bios.img.gz
   mv  bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined-efi.img.gz   bin/targets/x86/64/openwrt_x86-64_${str1}.${ver519}_uefi.img.gz
fi
#md5
ls -l  "bin/targets/x86/64" | awk -F " " '{print $9}' > wget/open_dev_md5
dev_version=`grep "_uefi.img.gz" wget/open_dev_md5 | cut -d - -f 2 | cut -d _ -f 2 `
openwrt_dev=openwrt_x86-64_${dev_version}_bios.img.gz
openwrt_dev_uefi=openwrt_x86-64_${dev_version}_uefi.img.gz
cd bin/targets/x86/64
md5sum $openwrt_dev > openwrt_bios.md5
md5sum $openwrt_dev_uefi > openwrt_uefi.md5
exit 0
EOF
