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

function git_sparse_clone(){
    repo=$(echo $1 | rev | cut -d'/' -f 1 | rev)
    pkg=$(echo $2 | rev | cut -d'/' -f 1 | rev)
    branch=$3  # 获取第三个参数作为分支名，如果不存在则使用默认分支
    new_name=$4  # 获取第四个参数作为新的本地仓库名称，如果不存在则使用第三个参数或默认仓库名

    if [ -z "$branch" ]; then
        if [ -z "$new_name" ]; then
            git clone --depth=1 --single-branch $1
        else
            git clone --depth=1 --single-branch $1 $new_name
        fi
    else
        if [ -z "$new_name" ] || [ ! "$new_name" ]; then
            git clone --depth=1 --single-branch -b $branch $1
        else
            git clone --depth=1 --single-branch -b $branch $1 $new_name
        fi
    fi

    mv $2 package/custom/
    rm -rf $repo
}
rm -rf package/custom; mkdir package/custom

# 允许ROOT编译
export FORCE_UNSAFE_CONFIGURE=1

# 修改默认IP
sed -i 's/192.168.1.1/192.168.8.8/g' package/base-files/files/bin/config_generate

# Autocore
sed -i 's/DEPENDS:=@(.*/DEPENDS:=@(TARGET_bcm27xx||TARGET_bcm53xx||TARGET_ipq40xx||TARGET_ipq806x||TARGET_ipq807x||TARGET_mvebu||TARGET_rockchip||TARGET_armvirt) \\/g' package/lean/autocore/Makefile

#设置ttyd免帐号登录
sed -i 's/\/bin\/login/\/bin\/login -f root/' feeds/packages/utils/ttyd/files/ttyd.config

# 报错修复
# rm -rf package/kernel/mac80211/patches/brcm/999-backport-to-linux-5.18.patch
# sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=4.8/g' tools/sed/Makefile
# sed -i 's/PKG_HASH:=.*/PKG_HASH:=f79b0cfea71b37a8eeec8490db6c5f7ae7719c35587f21edb0617f370eeff633/g' tools/sed/Makefile
# sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.7.2/g' feeds/Jejz/xray-core/Makefile
# sed -i 's/PKG_HASH:=.*/PKG_HASH:=e35824e19e8acc06296ce6bfa78a14a6f3ee8f42a965f7762b7056b506457a29/g' feeds/Jejz/xray-core/Makefile
# cp -f $GITHUB_WORKSPACE/personal/hysteria/* feeds/Jejz/hysteria

# svn co 复制 仓库下的文件夹 git clone 复制整个仓库
# OpenAppFilter 应用过滤
git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter

# vssr
# git clone https://github.com/jerrykuku/lua-maxminddb.git package/lua-maxminddb
# git clone https://github.com/jerrykuku/luci-app-vssr.git package/luci-app-vssr
git_sparse_clone https://github.com/xiangfeidexiaohuo/extra-ipk extra-ipk/patch/wall-luci/lua-maxminddb
git_sparse_clone https://github.com/xiangfeidexiaohuo/extra-ipk extra-ipk/patch/wall-luci/luci-app-vssr

# ikoolproxy
# git clone https://github.com/iwrt/luci-app-ikoolproxy.git package/luci-app-ikoolproxy
# cp -f $GITHUB_WORKSPACE/personal/files/* package/luci-app-ikoolproxy/koolproxy/files

# ddnsto
git_sparse_clone https://github.com/linkease/nas-packages-luci nas-packages-luci/luci/luci-app-ddnsto
git_sparse_clone https://github.com/linkease/nas-packages nas-packages/network/services/ddnsto

# poweroff
git clone https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff

# 阿里云盘webdav
rm -rf feeds/luci/applications/luci-app-aliyundrive-webdav
rm -rf feeds/packages/multimedia/aliyundrive-webdav
git_sparse_clone https://github.com/messense/aliyundrive-webdav aliyundrive-webdav/openwrt/luci-app-aliyundrive-webdav
git_sparse_clone https://github.com/messense/aliyundrive-webdav aliyundrive-webdav/openwrt/aliyundrive-webdav

# 阿里云盘fuse
# rm -rf feeds/luci/applications/luci-app-aliyundrive-fuse
# rm -rf feeds/packages/multimedia/aliyundrive-fuse
# git_sparse_clone https://github.com/messense/aliyundrive-fuse aliyundrive-fuse/openwrt/luci-app-aliyundrive-fuse
# git_sparse_clone https://github.com/messense/aliyundrive-fuse aliyundrive-fuse/openwrt/aliyundrive-fuse

# autotimeset 定时
# git clone https://github.com/sirpdboy/luci-app-autotimeset package/luci-app-autotimeset

# unblockneteasemusic
# git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/luci-app-unblockneteasemusic

# adguardhome
# git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome
git_sparse_clone https://github.com/xiangfeidexiaohuo/extra-ipk extra-ipk/luci-app-adguardhome

# dockerman
# rm -rf feeds/luci/applications/luci-app-dockerman
# svn co https://github.com/lisaac/luci-app-dockerman/trunk/applications/luci-app-dockerman package/luci-app-dockerman

# filebrowser 文件浏览器
git_sparse_clone https://github.com/Lienol/openwrt-package openwrt-package/luci-app-filebrowser

# passwall
git_sparse_clone https://github.com/xiaorouji/openwrt-passwallopenwrt-passwall/luci-app-passwall

# passwall2
git_sparse_clone https://github.com/xiaorouji/openwrt-passwall2 openwrt-passwall2/luci-app-passwall2

# smartdns
rm -rf feeds/packages/net/smartdns
rm -rf feeds/luci/applications/luci-app-smartdns
git clone -b lede https://github.com/pymumu/luci-app-smartdns.git package/luci-app-smartdns
git clone https://github.com/pymumu/openwrt-smartdns package/smartdns

# alist
# rm -rf feeds/packages/lang/golang
# git clone https://github.com/sbwml/packages_lang_golang -b 20.x feeds/packages/lang/golang
git clone https://github.com/sbwml/luci-app-alist package/alist

# mosdns
# find ./ | grep Makefile | grep mosdns | xargs rm -f
rm -rf feeds/packages/net/mosdns
rm -rf feeds/luci/applications/luci-app-mosdns
git_sparse_clone https://github.com/sbwml/luci-app-mosdns luci-app-mosdns
git_sparse_clone https://github.com/sbwml/luci-app-mosdns luci-app-mosdns/mosdns

# turboacc 去dns
# sed -i '60,70d' feeds/luci/applications/luci-app-turboacc/Makefile
# sed -i '54,78d' feeds/luci/applications/luci-app-turboacc/luasrc/model/cbi/turboacc.lua
# sed -i '7d;15d;21d' feeds/luci/applications/luci-app-turboacc/luasrc/view/turboacc/turboacc_status.htm
rm -rf feeds/luci/applications/luci-app-turboacc
git_sparse_clone https://github.com/xiangfeidexiaohuo/extra-ipk extra-ipk/patch/luci-app-turboacc

# netdata 中文
# rm -rf feeds/luci/applications/luci-app-netdata
# svn co https://github.com/sirpdboy/sirpdboy-package/trunk/luci-app-netdata package/luci-app-netdata

# ddns-go 动态域名
# git clone https://github.com/sirpdboy/luci-app-ddns-go.git package/ddns-go

# lucky 大吉
git clone https://github.com/gdy666/luci-app-lucky.git package/lucky

# eqos 限速
# git_sparse_clone https://github.com/kenzok8/openwrt-packages openwrt-packages/luci-app-eqos

# openclash
git_sparse_clone https://github.com/vernesong/OpenClash OpenClash/luci-app-openclash
# svn co https://github.com/vernesong/OpenClash/branches/dev/luci-app-openclash package/luci-app-openclash
# 编译 po2lmo (如果有po2lmo可跳过)
pushd package/custom/luci-app-openclash/tools/po2lmo
make && sudo make install
popd

# Themes 主题
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-netgear
rm -rf feeds/luci/themes/luci-theme-design
rm -rf feeds/luci/applications/luci-app-argon-config
rm -rf feeds/luci/applications/luci-app-design-config
git_sparse_clone https://github.com/rosywrt/luci-theme-rosy luci-theme-rosy
git_sparse_clone https://github.com/haiibo/openwrt-packages openwrt-packages/luci-theme-atmaterial_new
git_sparse_clone https://github.com/haiibo/openwrt-packages openwrt-packages/luci-theme-opentomcat
git_sparse_clone https://github.com/haiibo/openwrt-packages openwrt-packages/luci-theme-netgear
git clone https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
git clone https://github.com/sirpdboy/luci-theme-opentopd package/luci-theme-opentopd
git clone https://github.com/thinktip/luci-theme-neobird package/luci-theme-neobird
git clone https://github.com/gngpp/luci-theme-design.git package/luci-theme-design
git clone https://github.com/gngpp/luci-app-design-config.git package/luci-app-design-config

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
git_sparse_clone https://github.com/ophub/luci-app-amlogic amlogic/luci-app-amlogic main amlogic
sed -i "s|https.*/OpenWrt|https://github.com/Jejz168/OpenWrt|g" package/custom/luci-app-amlogic/root/etc/config/amlogic
# sed -i "s|http.*/library|https://github.com/Jejz168/OpenWrt/backup/kernel|g" package/custom/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|ARMv8|ARMv8|g" package/custom/luci-app-amlogic/root/etc/config/amlogic

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
sed -i 's/services/nas/g' package/custom/luci-app-aliyundrive-webdav/luasrc/controller/*.lua
sed -i 's/services/nas/g' package/custom/luci-app-aliyundrive-webdav/luasrc/model/cbi/aliyundrive-webdav/*.lua
sed -i 's/services/nas/g' package/custom/luci-app-aliyundrive-webdav/luasrc/view/aliyundrive-webdav/*.htm

# 调整阿里云盘fuse到存储菜单
# sed -i 's/services/nas/g' package/custom/luci-app-aliyundrive-fuse/luasrc/controller/*.lua
# sed -i 's/services/nas/g' package/custom/luci-app-aliyundrive-fuse/luasrc/model/cbi/aliyundrive-fuse/*.lua
# sed -i 's/services/nas/g' package/custom/luci-app-aliyundrive-fuse/luasrc/view/aliyundrive-fuse/*.htm

# 修改插件名字
# sed -i 's/"挂载 SMB 网络共享"/"挂载共享"/g' `grep "挂载 SMB 网络共享" -rl ./`
# sed -i 's/"Argon 主题设置"/"Argon 设置"/g' `grep "Argon 主题设置" -rl ./`
# sed -i 's/"阿里云盘 WebDAV"/"阿里云盘"/g' `grep "阿里云盘 WebDAV" -rl ./`
# sed -i 's/"USB 打印服务器"/"USB 打印"/g' `grep "USB 打印服务器" -rl ./`


./scripts/feeds update -a
./scripts/feeds install -a

echo "========================="
echo " DIY2 配置完成……"
