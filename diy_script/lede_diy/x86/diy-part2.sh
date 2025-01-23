#!/bin/bash
#===============================================
# Description: DIY script part 2
# File name: diy-part2.sh
# Lisence: MIT
# By: Jejz
#===============================================

echo "开始 DIY2 配置……"
echo "========================="

# Git稀疏克隆，只克隆指定目录到本地
chmod +x $GITHUB_WORKSPACE/diy_script/function.sh
source $GITHUB_WORKSPACE/diy_script/function.sh

# 修改主机名字，修改你喜欢的就行（不能纯数字或者使用中文）
# sed -i "/uci commit system/i\uci set system.@system[0].hostname='Jejz'" package/lean/default-settings/files/zzz-default-settings
# sed -i "s/hostname='.*'/hostname='Jejz'/g" ./package/base-files/files/bin/config_generate

# 修改默认IP
sed -i 's/192.168.1.1/192.168.8.3/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.1.1/192.168.8.3/g' package/base-files/luci2/bin/config_generate

# 设置密码为空（安装固件时无需密码登陆，然后自己修改想要的密码）
sed -i '/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF./d' package/lean/default-settings/files/zzz-default-settings

# 调整 x86 型号只显示 CPU 型号
sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' package/lean/autocore/files/x86/autocore

# 修改版本号
# sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%y.%m.%d)'|g" package/lean/default-settings/files/zzz-default-settings

# 设置ttyd免帐号登录
sed -i 's/\/bin\/login/\/bin\/login -f root/' feeds/packages/utils/ttyd/files/ttyd.config

# 默认 shell 为 bash
sed -i 's/\/bin\/ash/\/bin\/bash/g' package/base-files/files/etc/passwd

# samba解除root限制
# sed -i 's/invalid users = root/#&/g' feeds/packages/net/samba4/files/smb.conf.template

# coremark跑分定时清除
sed -i '/\* \* \* \/etc\/coremark.sh/d' feeds/packages/utils/coremark/*

# 修改 argon 为默认主题
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i 's/Bootstrap theme/Argon theme/g' feeds/luci/collections/*/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/*/Makefile

##切换为samba4
# sed -i 's/luci-app-samba/luci-app-samba4/g' package/lean/autosamba/Makefile

# 替换curl修改版（无nghttp3、ngtcp2）
curl_ver=$(grep -i "PKG_VERSION:=" feeds/packages/net/curl/Makefile | awk -F'=' '{print $2}')
if [ "$curl_ver" != "8.11.1" ]; then
    echo "当前 curl 版本是: $curl_ver,开始替换......"
    rm -rf feeds/packages/net/curl
    cp -rf $GITHUB_WORKSPACE/personal/curl feeds/packages/net/curl
fi

# 报错修复
# sed -i 's/9625784cf2e4fd9842f1d407681ce4878b5b0dcddbcd31c6135114a30c71e6a8/5de8c8e29aaa3fb9cc6b47bb27299f271354ebb72514e3accadc7d38b5bbaa72/g' feeds/packages/utils/jq/Makefile
# sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.7.2/g' feeds/Jejz/xray-core/Makefile
# sed -i 's/PKG_HASH:=.*/PKG_HASH:=e35824e19e8acc06296ce6bfa78a14a6f3ee8f42a965f7762b7056b506457a29/g' feeds/Jejz/xray-core/Makefile
# cp -f $GITHUB_WORKSPACE/personal/hysteria/* feeds/Jejz/hysteria
# cp -f $GITHUB_WORKSPACE/personal/chinadns-ng/* feeds/Jejz/chinadns-ng
# rm -rf feeds/packages/utils/v2dat

# 添加整个源仓库(git_clone)/添加源仓库内的指定目录(clone_dir)/添加源仓库内的所有目录(clone_all)
# vssr adguardhome turboacc去dns
rm -rf feeds/packages/net/adguardhome
clone_dir master https://github.com/xiangfeidexiaohuo/extra-ipk luci-app-adguardhome luci-app-poweroff lua-maxminddb luci-app-vssr

# 修复frps
clone_dir https://github.com/superzjg/luci-app-frpc_frps luci-app-frpc luci-app-frps

# 修复adguardhome重定向端口识别
# cp -f $GITHUB_WORKSPACE/personal/AdGuardHome/base.lua $destination_dir/luci-app-adguardhome/luasrc/model/cbi/AdGuardHome/base.lua

# ddns-go 动态域名
# clone_all https://github.com/sirpdboy/luci-app-ddns-go

# chatgpt
# git_clone https://github.com/sirpdboy/luci-app-chatgpt-web luci-app-chatgpt

# lucky 大吉
clone_all https://github.com/gdy666/luci-app-lucky

# ddnsto
clone_dir main https://github.com/linkease/nas-packages-luci luci-app-ddnsto
clone_dir master https://github.com/linkease/nas-packages ddnsto
cp -f $GITHUB_WORKSPACE/personal/ddnsto/Makefile $destination_dir/ddnsto/Makefile

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
# clone_all https://github.com/xiaorouji/openwrt-passwall2

# mihomo
# clone_all https://github.com/morytyann/OpenWrt-mihomo

# homeproxy
# git_clone https://github.com/immortalwrt/homeproxy luci-app-homeproxy

# nekobox
# rm -rf feeds/packages/net/sing-box
# clone_all nekobox https://github.com/Thaolga/openwrt-nekobox

# openclash
clone_dir master https://github.com/vernesong/OpenClash luci-app-openclash
# clone_dir dev https://github.com/vernesong/OpenClash luci-app-openclash
# 编译 po2lmo (如果有po2lmo可跳过)
pushd $destination_dir/luci-app-openclash/tools/po2lmo
make && sudo make install
popd

# argon 主题
git_clone 18.06 https://github.com/jerrykuku/luci-theme-argon
git_clone 18.06 https://github.com/jerrykuku/luci-app-argon-config

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
    sed -i "s/option primary '#[0-9a-fA-F]\{6\}'/option primary '#FF8C00'/" $ARGON_CONFIG_FILE
    sed -i "s/option dark_primary '#[0-9a-fA-F]\{6\}'/option dark_primary '#9370DB'/" $ARGON_CONFIG_FILE

    echo "argon theme has been customized!"
fi

# 主机名右上角符号❤
# sed -i 's/❤/❤/g' package/lean/luci-theme-argon_armygreen/luasrc/view/themes/argon_armygreen/header.htm

# 修改主题多余版本信息
sed -i 's|<a class="luci-link" href="https://github.com/openwrt/luci"|<a|g' feeds/luci/themes/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i 's|<a href="https://github.com/jerrykuku/luci-theme-argon" target="_blank">|<a>|g' feeds/luci/themes/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i 's/<a href=\"https:\/\/github.com\/coolsnowwolf\/luci\">/<a>/g' feeds/luci/themes/luci-theme-bootstrap/luasrc/view/themes/bootstrap/footer.htm

# 显示增加编译时间
sed -i "s/<%=pcdata(ver.distname)%> <%=pcdata(ver.distversion)%>/<%=pcdata(ver.distname)%> <%=pcdata(ver.distversion)%> (By @Jejz build $(TZ=UTC-8 date "+%Y-%m-%d %H:%M"))/g" package/lean/autocore/files/x86/index.htm

# 修改概览里时间显示为中文数字
sed -i 's/os.date()/os.date("%Y年%m月%d日") .. " " .. translate(os.date("%A")) .. " " .. os.date("%X")/g' package/lean/autocore/files/x86/index.htm

# 修改欢迎banner
# cp -f $GITHUB_WORKSPACE/personal/banner package/base-files/files/etc/banner
# wget -O ./package/base-files/files/etc/banner https://raw.githubusercontent.com/Jejz168/OpenWrt/main/personal/banner
sed -i "/\\   DE \//s/$/  [31mBy @Jejz build $(TZ=UTC-8 date '+%Y.%m.%d')[0m/" package/base-files/files/etc/banner
cat package/base-files/files/etc/banner

# 固件更新地址
sed -i '/CPU usage/a\                <tr><td width="33%"><%:Compile update%></td><td><a target="_blank" href="https://github.com/Jejz168/OpenWrt/releases">👆查看</a></td></tr>'  package/lean/autocore/files/x86/index.htm
cat >>feeds/luci/modules/luci-base/po/zh-cn/base.po<<- EOF

msgid "Compile update"
msgstr "固件地址"
EOF

# 修改makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/luci\.mk/include \$(TOPDIR)\/feeds\/luci\/luci\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/lang\/golang\/golang\-package\.mk/include \$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang\-package\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHREPO/PKG_SOURCE_URL:=https:\/\/github\.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload\.github\.com/g' {}

# 调整V2ray服务到VPN菜单
sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/controller/*.lua
sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/model/cbi/v2ray_server/*.lua
sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/view/v2ray_server/*.htm

# 修改插件名字
# sed -i 's/"挂载 SMB 网络共享"/"挂载共享"/g' `grep "挂载 SMB 网络共享" -rl ./`
# sed -i 's/"Argon 主题设置"/"Argon 设置"/g' `grep "Argon 主题设置" -rl ./`
# sed -i 's/"阿里云盘 WebDAV"/"阿里云盘"/g' `grep "阿里云盘 WebDAV" -rl ./`
# sed -i 's/"USB 打印服务器"/"USB 打印"/g' `grep "USB 打印服务器" -rl ./`
# sed -i 's/"网络存储"/"存储"/g' `grep "网络存储" -rl ./`
# sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' `grep "Turbo ACC 网络加速" -rl ./`
# sed -i 's/"实时流量监测"/"流量"/g' `grep "实时流量监测" -rl ./`
# sed -i 's/"KMS 服务器"/"KMS激活"/g' `grep "KMS 服务器" -rl ./`
# sed -i 's/"TTYD 终端"/"命令窗"/g' `grep "TTYD 终端" -rl ./`
# sed -i 's/"USB 打印服务器"/"打印服务"/g' `grep "USB 打印服务器" -rl ./`

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
