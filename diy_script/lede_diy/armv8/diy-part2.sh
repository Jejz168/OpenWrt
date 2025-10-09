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

# Git稀疏克隆，只克隆指定目录到本地
chmod +x $GITHUB_WORKSPACE/diy_script/function.sh
source $GITHUB_WORKSPACE/diy_script/function.sh

# 修改默认IP
sed -i 's/192.168.1.1/192.168.8.8/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.1.1/192.168.8.8/g' package/base-files/luci2/bin/config_generate

# Autocore
sed -i 's/DEPENDS:=@(.*/DEPENDS:=@(TARGET_bcm27xx||TARGET_bcm53xx||TARGET_ipq40xx||TARGET_ipq806x||TARGET_ipq807x||TARGET_mvebu||TARGET_rockchip||TARGET_armvirt) \\/g' package/lean/autocore/Makefile

# 设置ttyd免帐号登录
sed -i 's/\/bin\/login/\/bin\/login -f root/' feeds/packages/utils/ttyd/files/ttyd.config

# 默认 shell 为 bash
sed -i 's/\/bin\/ash/\/bin\/bash/g' package/base-files/files/etc/passwd

# samba解除root限制
# sed -i 's/invalid users = root/#&/g' feeds/packages/net/samba4/files/smb.conf.template

# coremark跑分定时清除
sed -i '/\* \* \* \/etc\/coremark.sh/d' feeds/packages/utils/coremark/*

# 替换curl修改版（无nghttp3、ngtcp2）
curl_ver=$(grep -i "PKG_VERSION:=" feeds/packages/net/curl/Makefile | awk -F'=' '{print $2}')
if [ "$curl_ver" != "8.11.1" ]; then
    echo "当前 curl 版本是: $curl_ver,开始替换......"
    rm -rf feeds/packages/net/curl
    cp -rf $GITHUB_WORKSPACE/personal/curl feeds/packages/net/curl
fi

# 报错修复
# rm -rf package/kernel/mac80211/patches/brcm/999-backport-to-linux-5.18.patch
# sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=4.8/g' tools/sed/Makefile
# sed -i 's/PKG_HASH:=.*/PKG_HASH:=f79b0cfea71b37a8eeec8490db6c5f7ae7719c35587f21edb0617f370eeff633/g' tools/sed/Makefile
# sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.7.2/g' feeds/Jejz/xray-core/Makefile
# sed -i 's/PKG_HASH:=.*/PKG_HASH:=e35824e19e8acc06296ce6bfa78a14a6f3ee8f42a965f7762b7056b506457a29/g' feeds/Jejz/xray-core/Makefile
# cp -f $GITHUB_WORKSPACE/personal/hysteria/* feeds/Jejz/hysteria
# rm -rf feeds/packages/utils/v2dat

# 添加整个源仓库(git_clone)/添加源仓库内的指定目录(clone_dir)/添加源仓库内的所有目录(clone_all)
# vssr adguardhome turboacc去dns
rm -rf feeds/packages/net/adguardhome
clone_dir master https://github.com/xiangfeidexiaohuo/extra-ipk luci-app-adguardhome luci-app-poweroff lua-maxminddb luci-app-vssr

# 修复frps
clone_dir https://github.com/superzjg/luci-app-frpc_frps luci-app-frpc luci-app-frps

# ddns-go 动态域名
# clone_all https://github.com/sirpdboy/luci-app-ddns-go

# chatgpt
# git_clone https://github.com/sirpdboy/luci-app-chatgpt-web luci-app-chatgpt

# lucky 大吉
clone_all https://github.com/gdy666/luci-app-lucky

# ddnsto
clone_dir main https://github.com/linkease/nas-packages-luci luci-app-ddnsto
clone_dir master https://github.com/linkease/nas-packages ddnsto
ddnsto_ver=$(grep -i "PKG_VERSION:=" $destination_dir/ddnsto/Makefile | awk -F'=' '{print $2}' | tr -d ' ')
if [ "$ddnsto_ver" == "3.0.4" ]; then
    echo "当前 ddnsto 版本是: $ddnsto_ver, 开始替换......"

    sed -i 's|PKG_SOURCE_URL:=.*|PKG_SOURCE_URL:=https://github.com/Jejz168/OpenWrt/raw/refs/heads/main/personal/ddnsto/|' $destination_dir/ddnsto/Makefile

    echo "替换完成！"
fi

# OpenAppFilter 应用过滤
clone_all https://github.com/sbwml/OpenAppFilter

# autotimeset 定时
# git_clone https://github.com/sirpdboy/luci-app-autotimeset

# dockerman
# clone_dir https://github.com/lisaac/luci-app-dockerman luci-app-dockerman

# eqos 限速
# clone_dir master https://github.com/kenzok8/openwrt-packages luci-app-eqos

# unblockneteasemusic
# git_clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic

# filebrowser 文件浏览器
clone_dir main https://github.com/Lienol/openwrt-package luci-app-filebrowser

# smartdns
git_clone lede https://github.com/pymumu/luci-app-smartdns luci-app-smartdns
git_clone https://github.com/pymumu/openwrt-smartdns smartdns

# mosdns
clone_all v5-lua https://github.com/sbwml/luci-app-mosdns

# alist
git_clone https://github.com/sbwml/packages_lang_golang golang
clone_all lua https://github.com/sbwml/luci-app-alist

# ssr-plus
clone_all https://github.com/fw876/helloworld

# passwall
clone_all https://github.com/xiaorouji/openwrt-passwall-packages
clone_all https://github.com/xiaorouji/openwrt-passwall

# passwall2
clone_all https://github.com/xiaorouji/openwrt-passwall2

# mihomo
# clone_all https://github.com/morytyann/OpenWrt-mihomo

# homeproxy
# git_clone https://github.com/immortalwrt/homeproxy luci-app-homeproxy

# nekobox
# rm -rf feeds/packages/net/sing-box
# clone_all nekobox https://github.com/Thaolga/openwrt-nekobox

# 阿里云盘webdav
clone_dir main https://github.com/messense/aliyundrive-webdav luci-app-aliyundrive-webdav aliyundrive-webdav

# openclash
clone_dir master https://github.com/vernesong/OpenClash luci-app-openclash
# clone_dir dev https://github.com/vernesong/OpenClash luci-app-openclash
# 编译 po2lmo (如果有po2lmo可跳过)
pushd $destination_dir/luci-app-openclash/tools/po2lmo
make && sudo make install
popd

# Themes 主题
clone_dir openwrt-18.06 https://github.com/rosywrt/luci-theme-rosy luci-theme-rosy
clone_dir master https://github.com/haiibo/openwrt-packages luci-theme-atmaterial_new luci-theme-opentomcat luci-theme-netgear
clone_dir classic https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom luci-theme-infinityfreedom
git_clone 18.06 https://github.com/jerrykuku/luci-theme-argon
git_clone 18.06 https://github.com/jerrykuku/luci-app-argon-config
git_clone https://github.com/sirpdboy/luci-theme-opentopd
git_clone https://github.com/thinktip/luci-theme-neobird

# 更改argon主题背景
# cp -f $GITHUB_WORKSPACE/personal/bg1.jpg feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
# 获取当天的星期几 (0=星期日, 1=星期一,...,6=星期六)
bg_file="bg$((($(date +%w) + 6) % 7 + 1)).jpg"
# argon登录页面美化
ARGON_IMG_FILE="feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg"
if [ -f "$ARGON_IMG_FILE" ]; then
    # 替换Argon主题内建壁纸
    cp -f "$GITHUB_WORKSPACE/personal/$bg_file" "$ARGON_IMG_FILE"

    echo "$bg_file argon wallpaper has been replaced!"
fi
ARGON_CONFIG_FILE="feeds/luci/applications/luci-app-argon-config/root/etc/config/argon"
if [ -f "$ARGON_CONFIG_FILE" ]; then
    # 设置Argon主题的登录页面壁纸为内建
    sed -i "s/option online_wallpaper 'bing'/option online_wallpaper 'none'/" $ARGON_CONFIG_FILE
    # 设置Argon主题的登录表单模糊度
    sed -i "s/option blur '[0-9]*'/option blur '0'/" $ARGON_CONFIG_FILE
    sed -i "s/option blur_dark '[0-9]*'/option blur_dark '0'/" $ARGON_CONFIG_FILE
    # 设置Argon主题颜色
    PRIMARY_COLORS=("#FF8C00" "#1E90FF" "#FF69B4" "#FF1493" "#e2c312" "#00CED1" "#DC143C")
    DARK_PRIMARY_COLORS=("#9370DB" "#8A2BE2" "#D87093" "#C71585" "#B8860B" "#4682B4" "#8B0000")
    WEEKDAY=$(date +%w)
    sed -i "s/option primary '#[0-9a-fA-F]\{6\}'/option primary '${PRIMARY_COLORS[$WEEKDAY]}'/" $ARGON_CONFIG_FILE
    sed -i "s/option dark_primary '#[0-9a-fA-F]\{6\}'/option dark_primary '${DARK_PRIMARY_COLORS[$WEEKDAY]}'/" $ARGON_CONFIG_FILE

    echo "argon theme has been customized!"
fi

# 主机名右上角符号❤
# sed -i 's/❤/❤/g' package/lean/luci-theme-argon_armygreen/luasrc/view/themes/argon_armygreen/header.htm

# 修改主题多余版本信息
sed -i 's|<a class="luci-link" href="https://github.com/openwrt/luci"|<a|g' feeds/luci/themes/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i 's|<a href="https://github.com/jerrykuku/luci-theme-argon" target="_blank">|<a>|g' feeds/luci/themes/luci-theme-argon/luasrc/view/themes/argon/footer.htm
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
clone_dir main https://github.com/ophub/luci-app-amlogic luci-app-amlogic
sed -i "s|https.*/OpenWrt|https://github.com/Jejz168/OpenWrt|g" $destination_dir/luci-app-amlogic/root/etc/config/amlogic
# sed -i "s|http.*/library|https://github.com/Jejz168/OpenWrt/backup/kernel|g" $destination_dir/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|ARMv8|ARMv8|g" $destination_dir/luci-app-amlogic/root/etc/config/amlogic

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

# 修改插件名字
# sed -i 's/"挂载 SMB 网络共享"/"挂载共享"/g' `grep "挂载 SMB 网络共享" -rl ./`
# sed -i 's/"Argon 主题设置"/"Argon 设置"/g' `grep "Argon 主题设置" -rl ./`
# sed -i 's/"阿里云盘 WebDAV"/"阿里云盘"/g' `grep "阿里云盘 WebDAV" -rl ./`
# sed -i 's/"USB 打印服务器"/"USB 打印"/g' `grep "USB 打印服务器" -rl ./`

# 转换插件语言翻译
for e in $(ls -d $destination_dir/luci-*/po feeds/luci/applications/luci-*/po); do
    if [[ -d $e/zh-cn && ! -d $e/zh_Hans ]]; then
        ln -s zh-cn $e/zh_Hans 2>/dev/null
    elif [[ -d $e/zh_Hans && ! -d $e/zh-cn ]]; then
        ln -s zh_Hans $e/zh-cn 2>/dev/null
    fi
done


./scripts/feeds update -a
./scripts/feeds install -a

echo "========================="
echo " DIY2 配置完成……"
