#!/bin/bash
#===============================================
# Description: DIY script part 2
# File name: diy-part2.sh
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#===============================================

# 切换内核版本
#sed -i 's/KERNEL_PATCHVER:=5.15/KERNEL_PATCHVER:=5.4/g' ./target/linux/x86/Makefile

# 修改主机名字，修改你喜欢的就行（不能纯数字或者使用中文）
#sed -i "/uci commit system/i\uci set system.@system[0].hostname='Jejz'" package/lean/default-settings/files/zzz-default-settings
#sed -i "s/hostname='OpenWrt'/hostname='Jejz'/g" ./package/base-files/files/bin/config_generate

# 修改默认IP
sed -i 's/192.168.1.1/192.168.8.3/g' package/base-files/files/bin/config_generate

# 设置密码为空（安装固件时无需密码登陆，然后自己修改想要的密码）
#sed -i 's@.*CYXluq4wUazHjmCDBCqXF*@#&@g' package/lean/default-settings/files/zzz-default-settings

#设置ttyd免帐号登录
sed -i 's/\/bin\/login/\/bin\/login -f root/' feeds/packages/utils/ttyd/files/ttyd.config

# 修改 argon 为默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' ./feeds/luci/collections/luci/Makefile

# 移除重复软件包
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-netgear
rm -rf feeds/luci/applications/luci-app-netdata
rm -rf feeds/luci/applications/luci-app-serverchan
rm -rf feeds/luci/applications/luci-app-frpc
rm -rf feeds/luci/applications/luci-app-socat
rm -rf feeds/luci/applications/luci-app-wrtbwmon

# 添加额外软件包
git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter
git clone https://github.com/jerrykuku/lua-maxminddb.git package/lua-maxminddb
git clone https://github.com/jerrykuku/luci-app-vssr.git package/luci-app-vssr
git clone https://github.com/tty228/luci-app-serverchan.git package/luci-app-serverchan
git clone https://github.com/semigodking/redsocks.git package/redsocks2
git clone https://github.com/kuoruan/luci-app-frpc.git package/luci-app-frpc
git clone https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff
git clone https://github.com/sirpdboy/luci-app-autotimeset package/luci-app-autotimeset
git clone https://github.com/siwind/luci-app-wolplus package/luci-app-wolplus
svn co https://github.com/rufengsuixing/luci-app-adguardhome/trunk package/luci-app-adguardhome
svn co https://github.com/sirpdboy/sirpdboy-package/trunk/luci-app-socat package/luci-app-socat
svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-filebrowser package/luci-app-filebrowser
svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/luci-app-ssr-plus
svn co https://github.com/xiaorouji/openwrt-passwall/branches/luci/luci-app-passwall package/luci-app-passwall
svn co https://github.com/xiaorouji/openwrt-passwall2/trunk/luci-app-passwall2 package/luci-app-passwall2
svn co https://github.com/sirpdboy/sirpdboy-package/trunk/luci-app-smartdns package/luci-app-smartdns
svn co https://github.com/doushang/luci-app-shortcutmenu/trunk/luci-app-shortcutmenu package/luci-app-shortcutmenu
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-eqos package/luci-app-eqos

# 科学上网插件依赖
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
# 编译 po2lmo (如果有po2lmo可跳过)
pushd package/luci-app-openclash/tools/po2lmo
make && sudo make install
popd

# Themes
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config

#主机名右上角符号❤
#sed -i 's/❤/❤/g' package/lean/luci-theme-argon_armygreen/luasrc/view/themes/argon_armygreen/header.htm

#修改主题多余版本信息
sed -i 's/<a class=\"luci-link\" href=\"https:\/\/github.com\/openwrt\/luci\">/<a>/g' package/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i "/(<%= ver.luciversion %>)/d" package/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i 's/<a href=\"https:\/\/github.com\/jerrykuku\/luci-theme-argon\">/<a>/g' package/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i 's/<a href=\"https:\/\/github.com\/coolsnowwolf\/luci\">/<a>/g' feeds/luci/themes/luci-theme-bootstrap/luasrc/view/themes/bootstrap/footer.htm

# 显示增加编译时间
sed -i "s/<%=pcdata(ver.luciname)%> (<%=pcdata(ver.luciversion)%>)/ By @Jejz build $(TZ=UTC-8 date "+%Y-%m-%d %H:%M")/g" package/lean/autocore/files/x86/index.htm

# 修改概览里时间显示为中文数字
sed -i 's/os.date()/os.date("%Y年%m月%d日") .. " " .. translate(os.date("%A")) .. " " .. os.date("%X")/g' package/lean/autocore/files/x86/index.htm

#修改欢迎banner
cp -f $GITHUB_WORKSPACE/personal/banner package/base-files/files/etc/banner

#固件更新地址
sed -i '/CPU usage/a\                <tr><td width="33%"><%:Compile update%></td><td><a target="_blank" href="https://github.com/Jejz168/OpenWrt/releases">👆查看</a></td></tr>'  package/lean/autocore/files/x86/index.htm
cat >>feeds/luci/modules/luci-base/po/zh-cn/base.po<<- EOF
\n
msgid "Compile update"
msgstr "固件地址"
EOF

# 实时监控
svn co https://github.com/sirpdboy/sirpdboy-package/trunk/luci-app-netdata package/luci-app-netdata

# 流量监控
svn co https://github.com/sirpdboy/sirpdboy-package/trunk/luci-app-wrtbwmon package/luci-app-wrtbwmon
svn co https://github.com/sirpdboy/sirpdboy-package/trunk/wrtbwmon package/wrtbwmon

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
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-aliyundrive-webdav/luasrc/controller/*.lua
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-aliyundrive-webdav/luasrc/model/cbi/aliyundrive-webdav/*.lua
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-aliyundrive-webdav/luasrc/view/aliyundrive-webdav/*.htm
# 调整阿里云盘fuse到存储菜单
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-aliyundrive-fuse/luasrc/controller/*.lua
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-aliyundrive-fuse/luasrc/model/cbi/aliyundrive-fuse/*.lua
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-aliyundrive-fuse/luasrc/view/aliyundrive-fuse/*.htm

# 修改插件名字
#sed -i 's/"挂载 SMB 网络共享"/"挂载共享"/g' `grep "挂载 SMB 网络共享" -rl ./`
#sed -i 's/"Argon 主题设置"/"Argon 设置"/g' `grep "Argon 主题设置" -rl ./`
#sed -i 's/"阿里云盘 WebDAV"/"阿里云盘"/g' `grep "阿里云盘 WebDAV" -rl ./`
#sed -i 's/"USB 打印服务器"/"USB 打印"/g' `grep "USB 打印服务器" -rl ./`
#sed -i 's/网页快捷菜单/端口访问/g' `grep "网页快捷菜单" -rl ./`
#sed -i 's/"网络存储"/"存储"/g' `grep "网络存储" -rl ./`
#sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' `grep "Turbo ACC 网络加速" -rl ./`
#sed -i 's/"实时流量监测"/"流量"/g' `grep "实时流量监测" -rl ./`
#sed -i 's/"KMS 服务器"/"KMS激活"/g' `grep "KMS 服务器" -rl ./`
#sed -i 's/"TTYD 终端"/"命令窗"/g' `grep "TTYD 终端" -rl ./`
#sed -i 's/"USB 打印服务器"/"打印服务"/g' `grep "USB 打印服务器" -rl ./`
#sed -i 's/"Web 管理"/"Web"/g' `grep "Web 管理" -rl ./`
#sed -i 's/"管理权"/"改密码"/g' `grep "管理权" -rl ./`
#sed -i 's/"带宽监控"/"监控"/g' `grep "带宽监控" -rl ./`

./scripts/feeds update -a
./scripts/feeds install -a
