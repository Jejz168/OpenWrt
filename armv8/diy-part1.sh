#!/bin/bash
#===============================================
# Description: DIY script part 1
# File name: diy-part1.sh
# By: Jejz
#===============================================


# Add a feed source
sed -i "/helloworld/d" "feeds.conf.default"
echo "src-git helloworld https://github.com/fw876/helloworld.git" >> "feeds.conf.default"
echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall;packages' >>feeds.conf.default
