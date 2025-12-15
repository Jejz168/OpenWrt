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

# 最大连接数修改为65535
sed -i '$a net.netfilter.nf_conntrack_max=65535' package/base-files/files/etc/sysctl.conf

# 修改uhttpd配置文件,禁用https
sed -i 's/^\s*list listen_https/# &/' package/network/services/uhttpd/files/uhttpd.config
sed -i 's/^\s*option cert/# &/; s/^\s*option key/# &/' package/network/services/uhttpd/files/uhttpd.config

#nlbwmon 修复log警报
sed -i '$a net.core.wmem_max=16777216' package/base-files/files/etc/sysctl.conf
sed -i '$a net.core.rmem_max=16777216' package/base-files/files/etc/sysctl.conf

# 替换curl修改版（无nghttp3、ngtcp2）
curl_ver=$(grep -i "PKG_VERSION:=" feeds/packages/net/curl/Makefile | awk -F'=' '{print $2}')
if [ "$curl_ver" != "8.12.0" ]; then
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
# filebrowser luci-app-pushbot
rm -rf feeds/packages/net/adguardhome
clone_dir main https://github.com/xiangfeidexiaohuo/2305-ipk luci-app-adguardhome luci-app-pushbot luci-app-poweroff

# 替换immortalwrt插件
clone_dir master https://github.com/immortalwrt/luci luci-app-syncdial luci-app-eqos luci-app-nps luci-app-frpc luci-app-frps luci-app-hd-idle luci-app-n2n luci-app-softethervpn

# 补全依赖
clone_dir master https://github.com/immortalwrt/packages nps n2n socat

# 同时兼容firewall3/4 的luci-app-socat
clone_dir main https://github.com/chenmozhijin/luci-app-socat luci-app-socat

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

# unblockneteasemusic
# git_clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic

# smartdns
git_clone https://github.com/pymumu/luci-app-smartdns luci-app-smartdns
git_clone https://github.com/pymumu/openwrt-smartdns smartdns

# mosdns
clone_all v5 https://github.com/sbwml/luci-app-mosdns

# openlist
git_clone https://github.com/sbwml/packages_lang_golang golang
clone_all https://github.com/sbwml/luci-app-openlist

# ssr-plus
clone_all https://github.com/fw876/helloworld

# passwall
clone_all https://github.com/xiaorouji/openwrt-passwall-packages
clone_all https://github.com/xiaorouji/openwrt-passwall

# passwall2
# clone_all https://github.com/xiaorouji/openwrt-passwall2

# Nikki
clone_all https://github.com/nikkinikki-org/OpenWrt-nikki

# Momo
clone_all https://github.com/nikkinikki-org/OpenWrt-momo

# homeproxy
git_clone https://github.com/immortalwrt/homeproxy luci-app-homeproxy

# luci-app-filemanager
git_clone https://github.com/sbwml/luci-app-filemanager luci-app-filemanager

# openclash
clone_dir master https://github.com/vernesong/OpenClash luci-app-openclash
# clone_dir dev https://github.com/vernesong/OpenClash luci-app-openclash
# 编译 po2lmo (如果有po2lmo可跳过)
pushd feeds/luci/applications/luci-app-openclash/tools/po2lmo
make && sudo make install
popd

# argon 主题
# git_clone https://github.com/jerrykuku/luci-theme-argon
# git_clone https://github.com/jerrykuku/luci-app-argon-config
clone_all https://github.com/sbwml/luci-theme-argon

# sbwml主题背景
# 替换所有文件内容中的 bg.webp 为 bg1.jpg
find "feeds/luci/themes/luci-theme-argon" -type f -exec sed -i 's/bg\.webp/bg1.jpg/g' {} +
# 替换所有文件名
find "feeds/luci/themes/luci-theme-argon" -type f -name "bg.webp" -exec bash -c 'mv "$1" "${1/bg.webp/bg1.jpg}"' _ {} \;

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
    PRIMARY_COLORS=("#FF8C00" "#1E90FF" "#FF69B4" "#FF1493" "#FFD700" "#00CED1" "#DC143C")
    DARK_PRIMARY_COLORS=("#9370DB" "#8A2BE2" "#D87093" "#C71585" "#B8860B" "#4682B4" "#8B0000")
    WEEKDAY=$(date +%w)
    sed -i "s/option primary '#[0-9a-fA-F]\{6\}'/option primary '${PRIMARY_COLORS[$WEEKDAY]}'/" $ARGON_CONFIG_FILE
    sed -i "s/option dark_primary '#[0-9a-fA-F]\{6\}'/option dark_primary '${DARK_PRIMARY_COLORS[$WEEKDAY]}'/" $ARGON_CONFIG_FILE

    echo "argon theme has been customized!"
fi
ARGON_CONFIG_FILES="$destination_dir/luci-app-argon-config/root/etc/config/argon"
if [ -f "$ARGON_CONFIG_FILES" ]; then
    # 设置Argon主题的登录页面壁纸为内建
    sed -i "s/option online_wallpaper 'bing'/option online_wallpaper 'none'/" $ARGON_CONFIG_FILES
    # 设置Argon主题的登录表单模糊度
    sed -i "s/option blur '[0-9]*'/option blur '0'/" $ARGON_CONFIG_FILES
    sed -i "s/option blur_dark '[0-9]*'/option blur_dark '0'/" $ARGON_CONFIG_FILES
    # 设置Argon主题颜色
    PRIMARY_COLORS=("#FF8C00" "#1E90FF" "#FF69B4" "#FF1493" "#e2c312" "#00CED1" "#DC143C")
    DARK_PRIMARY_COLORS=("#9370DB" "#8A2BE2" "#D87093" "#C71585" "#B8860B" "#4682B4" "#8B0000")
    WEEKDAY=$(date +%w)
    sed -i "s/option primary '#[0-9a-fA-F]\{6\}'/option primary '${PRIMARY_COLORS[$WEEKDAY]}'/" $ARGON_CONFIG_FILES
    sed -i "s/option dark_primary '#[0-9a-fA-F]\{6\}'/option dark_primary '${DARK_PRIMARY_COLORS[$WEEKDAY]}'/" $ARGON_CONFIG_FILES

    echo "argon theme has been customized!"
fi

# 修改主题多余版本信息
sed -i 's|<a class="luci-link" href="https://github.com/openwrt/luci"|<a|g' feeds/luci/themes/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i 's|<a class="luci-link" href="https://github.com/openwrt/luci"|<a|g' feeds/luci/themes/luci-theme-argon/luasrc/view/themes/argon/footer_login.htm
sed -i 's|<a href="https://github.com/jerrykuku/luci-theme-argon" target="_blank">|<a>|g' feeds/luci/themes/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i 's|<a href="https://github.com/jerrykuku/luci-theme-argon" target="_blank">|<a>|g' feeds/luci/themes/luci-theme-argon/luasrc/view/themes/argon/footer_login.htm

# 显示增加编译时间(时间4改5)
pushd package/lean/default-settings/files
export orig_version=$(cat "zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
export date_version="By @Jejz build $(TZ=UTC-8 date '+%Y-%m-%d') $(TZ=UTC-8 date +'%H' | sed -e 's/4/5/g'):$(TZ=UTC-8 date +%M | sed -e 's/4/5/g')"
sed -i "s/${orig_version}/${orig_version} (${date_version})/g" zzz-default-settings
popd
echo -e "\e[41m当前写入的编译时间:\e[0m \e[33m$(grep 'DISTRIB_REVISION=' package/lean/default-settings/files/zzz-default-settings)\e[0m"

# 修改欢迎banner
# cp -f $GITHUB_WORKSPACE/personal/banner package/base-files/files/etc/banner
# wget -O ./package/base-files/files/etc/banner https://raw.githubusercontent.com/Jejz168/OpenWrt/main/personal/banner
sed -i "/\\   DE \//s/$/  [31mBy @Jejz build $(TZ=UTC-8 date '+%Y.%m.%d')[0m/" package/base-files/files/etc/banner
cat package/base-files/files/etc/banner

# 修改makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/luci\.mk/include \$(TOPDIR)\/feeds\/luci\/luci\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/lang\/golang\/golang\-package\.mk/include \$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang\-package\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHREPO/PKG_SOURCE_URL:=https:\/\/github\.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload\.github\.com/g' {}

# 设置 nlbwmon 独立菜单
sed -i 's/524288/16777216/g' feeds/packages/net/nlbwmon/files/nlbwmon.config
sed -i 's/option commit_interval.*/option commit_interval 24h/g' feeds/packages/net/nlbwmon/files/nlbwmon.config
sed -i 's/services\/nlbw/nlbw/g; /path/s/admin\///g' feeds/luci/applications/luci-app-nlbwmon/root/usr/share/luci/menu.d/luci-app-nlbwmon.json
sed -i 's/services\///g' feeds/luci/applications/luci-app-nlbwmon/htdocs/luci-static/resources/view/nlbw/config.js

# 调整位置
#sed -i 's/services/nas/g' feeds/luci/applications/luci-app-p910nd/root/usr/share/luci/menu.d/luci-app-p910nd.json
#sed -i 's/services/nas/g' feeds/luci/applications/luci-app-aria2/root/usr/share/luci/menu.d/luci-app-aria2.json
#sed -i 's/services/nas/g' feeds/luci/applications/luci-app-filebrowser/root/usr/share/luci/menu.d/luci-app-filebrowser.json
#sed -i 's/services/nas/g' feeds/luci/applications/luci-app-ksmbd/root/usr/share/luci/menu.d/luci-app-ksmbd.json
#sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
#sed -i 's/services/network/g' $destination_dir/luci-app-eqos/root/usr/share/luci/menu.d/luci-app-eqos.json
primary_dir="feeds/luci/applications"
fallback_dir="$destination_dir"
apps=(
    "luci-app-p910nd:services/nas"
    "luci-app-aria2:services/nas"
    "luci-app-filebrowser:services/nas"
    "luci-app-ksmbd:services/nas"
    "luci-app-ttyd:services/system"
    "luci-app-eqos:services/network"
)
# 遍历模块和替换规则
for app_rule in "${apps[@]}"; do
    app=${app_rule%%:*}      # 提取模块名
    rule=${app_rule#*:}      # 提取替换规则
    src=${rule%/*}           # 提取替换前的内容
    dst=${rule#*/}           # 提取替换后的内容

    # 查找路径并执行替换
    if [ -d "$primary_dir/$app" ]; then
        sed -i "s/$src/$dst/g" "$primary_dir/$app/root/usr/share/luci/menu.d/$app.json"
        echo "Processed $app in $primary_dir."
    elif [ -d "$fallback_dir/$app" ]; then
        sed -i "s/$src/$dst/g" "$fallback_dir/$app/root/usr/share/luci/menu.d/$app.json"
        echo "Processed $app in $fallback_dir."
    else
        echo "Error: $app not found in either $primary_dir or $fallback_dir."
    fi
done

# 更改 ttyd 顺序和名称
sed -i '3a \		"order": 10,' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i 's,终端,TTYD 终端,g' feeds/luci/applications/luci-app-ttyd/po/zh_Hans/ttyd.po

# 重命名
sed -i 's,frp 服务器,Frp 服务器,g' feeds/luci/applications/luci-app-frps/po/zh_Hans/frps.po
sed -i 's,frp 客户端,Frp 客户端,g' feeds/luci/applications/luci-app-frpc/po/zh_Hans/frpc.po

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
