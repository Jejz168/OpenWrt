#!/bin/bash
#===============================================
# Description: DIY script part 2
# File name: diy-part2.sh
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#===============================================

#允许ROOT编译
export FORCE_UNSAFE_CONFIGURE=1

# 切换内核版本
#sed -i 's/KERNEL_PATCHVER:=5.15/KERNEL_PATCHVER:=5.4/g' ./target/linux/x86/Makefile

# 修改主机名字，修改你喜欢的就行（不能纯数字或者使用中文）
#sed -i "/uci commit system/i\uci set system.@system[0].hostname='Jejz'" package/lean/default-settings/files/zzz-default-settings
#sed -i "s/hostname='OpenWrt'/hostname='Jejz'/g" ./package/base-files/files/bin/config_generate

# 修改默认IP
sed -i 's/192.168.1.1/192.168.8.3/g' package/base-files/files/bin/config_generate

