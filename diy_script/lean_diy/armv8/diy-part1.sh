#!/bin/bash
#===============================================
# Description: DIY script part 1
# File name: diy-part1.sh
# Lisence: MIT
# By: Jejz
#===============================================


# Add a feed source
sed -i "/helloworld/d" feeds.conf.default
sed -i '$a src-git Jejz https://github.com/Jejz168/openwrt-packages' feeds.conf.default
# sed -i '$a src-git helloworld https://github.com/fw876/helloworld' feeds.conf.default
# sed -i '$a src-git PWpackages https://github.com/xiaorouji/openwrt-passwall.git;packages' feeds.conf.default
