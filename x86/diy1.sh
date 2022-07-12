#!/bin/bash


pwd
ls -l
echo "开始 DIY1 配置……"
pwd
ls -l


# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages' >>feeds.conf.default
#echo 'src-git small https://github.com/kenzok8/small' >>feeds.conf.default
echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default


#svn co 复制 仓库下的文件夹 git clone 复制整个仓库
# vssr
git clone https://github.com/jerrykuku/lua-maxminddb.git package/lua-maxminddb
git clone https://github.com/jerrykuku/luci-app-vssr.git package/luci-app-vssr

# serverchan通知
git clone https://github.com/tty228/luci-app-serverchan.git package/luci-app-serverchan

# 关机
git clone https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff

# unblockneteasemusic
git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/luci-app-unblockneteasemusic

#adguardhome
svn co https://github.com/sirpdboy/sirpdboy-package/trunk/luci-app-adguardhome package/luci-app-adguardhome

# filebrowser
svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-filebrowser package/luci-app-filebrowser

#passwall
svn co https://github.com/xiaorouji/openwrt-passwall/branches/luci/luci-app-passwall package/luci-app-passwall

# passwall2
# svn co https://github.com/xiaorouji/openwrt-passwall2/trunk/luci-app-passwall2 package/luci-app-passwall2

# smartdns
svn co https://github.com/sirpdboy/sirpdboy-package/trunk/luci-app-smartdns package/luci-app-smartdns

# SSRP
svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/luci-app-ssr-plus

# 科学上网插件依赖
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
# 编译 po2lmo (如果有po2lmo可跳过)
pushd package/luci-app-openclash/tools/po2lmo
make && sudo make install
popd

# Themes
rm -rf feeds/luci/themes/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config

echo "DIY1 配置完成……"
