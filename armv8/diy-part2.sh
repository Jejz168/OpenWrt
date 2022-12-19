#!/bin/bash
#===============================================
# Description: DIY script part 2
# File name: diy-part2.sh
# Lisence: MIT
# By: Jejz
#===============================================

echo "========================="
echo "开始 DIY2 配置……"
echo "========================="

#允许ROOT编译
export FORCE_UNSAFE_CONFIGURE=1

# 修改默认IP
sed -i 's/192.168.1.1/192.168.8.8/g' package/base-files/files/bin/config_generate

# Autocore
sed -i 's/DEPENDS:=@(.*/DEPENDS:=@(TARGET_bcm27xx||TARGET_bcm53xx||TARGET_ipq40xx||TARGET_ipq806x||TARGET_ipq807x||TARGET_mvebu||TARGET_rockchip||TARGET_armvirt) \\/g' package/lean/autocore/Makefile

#设置ttyd免帐号登录
sed -i 's/\/bin\/login/\/bin\/login -f root/' feeds/packages/utils/ttyd/files/ttyd.config

# 报错修复
# rm -rf package/kernel/mac80211/patches/brcm/999-backport-to-linux-5.18.patch
# sed
# sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=4.8/g' tools/sed/Makefile
# sed -i 's/PKG_HASH:=.*/PKG_HASH:=f79b0cfea71b37a8eeec8490db6c5f7ae7719c35587f21edb0617f370eeff633/g' tools/sed/Makefile

# svn co 复制 仓库下的文件夹 git clone 复制整个仓库
# OpenAppFilter 应用过滤
git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter

# vssr
git clone https://github.com/jerrykuku/lua-maxminddb.git package/lua-maxminddb
git clone https://github.com/jerrykuku/luci-app-vssr.git package/luci-app-vssr

# ikoolproxy
git clone https://github.com/iwrt/luci-app-ikoolproxy.git package/luci-app-ikoolproxy
cp -f $GITHUB_WORKSPACE/personal/files/* package/luci-app-ikoolproxy/koolproxy/files

# ddnsto
svn co https://github.com/linkease/nas-packages-luci/trunk/luci/luci-app-ddnsto package/luci-app-ddnsto
svn co https://github.com/linkease/nas-packages/trunk/network/services/ddnsto package/ddnsto

# poweroff
git clone https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff

# 阿里云盘webdav
rm -rf feeds/luci/applications/luci-app-aliyundrive-webdav
rm -rf feeds/packages/multimedia/aliyundrive-webdav
svn co https://github.com/messense/aliyundrive-webdav/trunk/openwrt/luci-app-aliyundrive-webdav package/luci-app-aliyundrive-webdav
svn co https://github.com/messense/aliyundrive-webdav/trunk/openwrt/aliyundrive-webdav package/aliyundrive-webdav

# 阿里云盘fuse
rm -rf feeds/luci/applications/luci-app-aliyundrive-fuse
rm -rf feeds/packages/multimedia/aliyundrive-fuse
svn co https://github.com/messense/aliyundrive-fuse/trunk/openwrt/luci-app-aliyundrive-fuse package/luci-app-aliyundrive-fuse
svn co https://github.com/messense/aliyundrive-fuse/trunk/openwrt/aliyundrive-fuse package/aliyundrive-fuse

# autotimeset 定时
git clone https://github.com/sirpdboy/luci-app-autotimeset package/luci-app-autotimeset

# unblockneteasemusic
git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/luci-app-unblockneteasemusic

# adguardhome
# git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome
svn co https://github.com/xiangfeidexiaohuo/openwrt-packages/trunk/luci-app-adguardhome package/luci-app-adguardhome

# dockerman
rm -rf feeds/luci/applications/luci-app-dockerman
svn co https://github.com/lisaac/luci-app-dockerman/trunk/applications/luci-app-dockerman package/luci-app-dockerman

# filebrowser 文件浏览器
svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-filebrowser package/luci-app-filebrowser

# passwall
svn co https://github.com/xiaorouji/openwrt-passwall/branches/luci/luci-app-passwall package/luci-app-passwall

# passwall2
svn co https://github.com/xiaorouji/openwrt-passwall2/trunk/luci-app-passwall2 package/luci-app-passwall2

# smartdns
# git clone -b lede https://github.com/pymumu/luci-app-smartdns.git package/luci-app-smartdns

# mosdns
# find ./ | grep Makefile | grep mosdns | xargs rm -f
rm -rf feeds/packages/net/mosdns
rm -rf feeds/luci/applications/luci-app-mosdns
svn co https://github.com/sbwml/luci-app-mosdns/trunk/luci-app-mosdns package/luci-app-mosdns
svn co https://github.com/sbwml/luci-app-mosdns/trunk/mosdns package/mosdns


# turboacc 去dns
# sed -i '60,70d' feeds/luci/applications/luci-app-turboacc/Makefile
# sed -i '54,78d' feeds/luci/applications/luci-app-turboacc/luasrc/model/cbi/turboacc.lua
# sed -i '7d;15d;21d' feeds/luci/applications/luci-app-turboacc/luasrc/view/turboacc/turboacc_status.htm
rm -rf feeds/luci/applications/luci-app-turboacc
svn co https://github.com/xiangfeidexiaohuo/openwrt-packages/trunk/patch/luci-app-turboacc package/luci-app-turboacc

# netdata 中文
# rm -rf feeds/luci/applications/luci-app-netdata
# svn co https://github.com/sirpdboy/sirpdboy-package/trunk/luci-app-netdata package/luci-app-netdata

# ddns-go 动态域名
git clone https://github.com/sirpdboy/luci-app-ddns-go.git package/ddns-go

# eqos 限速
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-eqos package/luci-app-eqos

# 科学上网插件依赖
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
# svn co https://github.com/vernesong/OpenClash/branches/dev/luci-app-openclash package/luci-app-openclash
# 编译 po2lmo (如果有po2lmo可跳过)
pushd package/luci-app-openclash/tools/po2lmo
make && sudo make install
popd

# Themes 主题
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-netgear
svn co https://github.com/rosywrt/luci-theme-rosy/trunk/luci-theme-rosy package/luci-theme-rosy
svn co https://github.com/haiibo/packages/trunk/luci-theme-atmaterial_new package/luci-theme-atmaterial_new
svn co https://github.com/haiibo/packages/trunk/luci-theme-opentomcat package/luci-theme-opentomcat
svn co https://github.com/haiibo/packages/trunk/luci-theme-netgear package/luci-theme-netgear
git clone https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone https://github.com/sirpdboy/luci-theme-opentopd package/luci-theme-opentopd
git clone https://github.com/thinktip/luci-theme-neobird package/luci-theme-neobird

# 主机名右上角符号❤
# sed -i 's/❤/❤/g' package/lean/luci-theme-argon_armygreen/luasrc/view/themes/argon_armygreen/header.htm

# 修改主题多余版本信息
sed -i 's/<a class=\"luci-link\" href=\"https:\/\/github.com\/openwrt\/luci\">/<a>/g' package/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i 's/<a href=\"https:\/\/github.com\/jerrykuku\/luci-theme-argon\">/<a>/g' package/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i 's/<a href=\"https:\/\/github.com\/coolsnowwolf\/luci\">/<a>/g' feeds/luci/themes/luci-theme-bootstrap/luasrc/view/themes/bootstrap/footer.htm

# 显示增加编译时间(F大打包工具会替换)
# sed -i "s/<%=pcdata(ver.distname)%> <%=pcdata(ver.distversion)%>/<%=pcdata(ver.distname)%> <%=pcdata(ver.distversion)%> (By @Jejz build $(TZ=UTC-8 date "+%Y-%m-%d %H:%M"))/g" package/lean/autocore/files/arm/index.htm

# 修改概览里时间显示为中文数字(F大打包工具会替换)
# sed -i 's/os.date()/os.date("%Y年%m月%d日") .. " " .. translate(os.date("%A")) .. " " .. os.date("%X")/g' package/lean/autocore/files/arm/index.htm

# 去除型号右侧肿瘤式跑分信息
# sed -i "s|\ <%=luci.sys.exec(\"cat \/etc\/bench.log\") or \" \"%>||g" feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm

# 固件更新地址(F大打包工具会替换)
# sed -i '/CPU usage/a\                <tr><td width="33%"><%:Compile update%></td><td><a target="_blank" href="https://github.com/Jejz168/OpenWrt/releases">👆查看</a></td></tr>'  package/lean/autocore/files/arm/index.htm
# cat >>feeds/luci/modules/luci-base/po/zh-cn/base.po<<- EOF

# msgid "Compile update"
# msgstr "固件地址"
# EOF

# 晶晨宝盒
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic
sed -i "s|https.*/OpenWrt|https://github.com/Jejz168/OpenWrt|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|opt/kernel|backup/kernel|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|ARMv8|ARMv8|g" package/luci-app-amlogic/root/etc/config/amlogic

# 修改makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/luci\.mk/include \$(TOPDIR)\/feeds\/luci\/luci\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/lang\/golang\/golang\-package\.mk/include \$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang\-package\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHREPO/PKG_SOURCE_URL:=https:\/\/github\.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload\.github\.com/g' {}

# 调整V2ray服务到VPN菜单
sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/controller/*.lua
sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/model/cbi/v2ray_server/*.lua
sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/view/v2ray_server/*.htm

# 调整阿里云盘webdav到存储菜单
sed -i 's/services/nas/g' package/luci-app-aliyundrive-webdav/luasrc/controller/*.lua
sed -i 's/services/nas/g' package/luci-app-aliyundrive-webdav/luasrc/model/cbi/aliyundrive-webdav/*.lua
sed -i 's/services/nas/g' package/luci-app-aliyundrive-webdav/luasrc/view/aliyundrive-webdav/*.htm

# 调整阿里云盘fuse到存储菜单
sed -i 's/services/nas/g' package/luci-app-aliyundrive-fuse/luasrc/controller/*.lua
sed -i 's/services/nas/g' package/luci-app-aliyundrive-fuse/luasrc/model/cbi/aliyundrive-fuse/*.lua
sed -i 's/services/nas/g' package/luci-app-aliyundrive-fuse/luasrc/view/aliyundrive-fuse/*.htm

# 修改插件名字
# sed -i 's/"挂载 SMB 网络共享"/"挂载共享"/g' `grep "挂载 SMB 网络共享" -rl ./`
# sed -i 's/"Argon 主题设置"/"Argon 设置"/g' `grep "Argon 主题设置" -rl ./`
# sed -i 's/"阿里云盘 WebDAV"/"阿里云盘"/g' `grep "阿里云盘 WebDAV" -rl ./`
# sed -i 's/"USB 打印服务器"/"USB 打印"/g' `grep "USB 打印服务器" -rl ./`


./scripts/feeds update -a
./scripts/feeds install -a

echo "========================="
echo " DIY2 配置完成……"
