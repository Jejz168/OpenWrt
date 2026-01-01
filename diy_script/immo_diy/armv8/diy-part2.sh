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

# 修改默认IP
sed -i 's/192.168.1.1/192.168.8.8/g' package/base-files/files/bin/config_generate

# 设置ttyd免帐号登录
sed -i 's/\/bin\/login/\/bin\/login -f root/' feeds/packages/utils/ttyd/files/ttyd.config

# 默认 shell 为 bash
sed -i 's/\/bin\/ash/\/bin\/bash/g' package/base-files/files/etc/passwd

# 精简 UPnP 菜单名称
sed -i 's#\"title\": \"UPnP IGD \& PCP/NAT-PMP\"#\"title\": \"UPnP\"#g' feeds/luci/applications/luci-app-upnp/root/usr/share/luci/menu.d/luci-app-upnp.json

# 修改uhttpd配置文件,禁用https
sed -i 's/^\s*list listen_https/# &/' package/network/services/uhttpd/files/uhttpd.config
sed -i 's/^\s*option cert/# &/; s/^\s*option key/# &/' package/network/services/uhttpd/files/uhttpd.config

# 优化socat中英翻译
sed -i 's/仅IPv6/仅 IPv6/g' package/feeds/luci/luci-app-socat/po/zh_Hans/socat.po

## samba设置
# enable multi-channel
sed -i '/workgroup/a \\n\t## enable multi-channel' feeds/packages/net/samba4/files/smb.conf.template
sed -i '/enable multi-channel/a \\tserver multi channel support = yes' feeds/packages/net/samba4/files/smb.conf.template
# default config
sed -i 's/#aio read size = 0/aio read size = 0/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/#aio write size = 0/aio write size = 0/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/invalid users = root/#invalid users = root/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/bind interfaces only = yes/bind interfaces only = no/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/#create mask/create mask/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/#directory mask/directory mask/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/0666/0644/g;s/0744/0755/g;s/0777/0755/g' feeds/luci/applications/luci-app-samba4/htdocs/luci-static/resources/view/samba4.js
sed -i 's/0666/0644/g;s/0777/0755/g' feeds/packages/net/samba4/files/samba.config
sed -i 's/0666/0644/g;s/0777/0755/g' feeds/packages/net/samba4/files/smb.conf.template

# samba工作组冲突
WORKGROUP_NAME="WORKGROUP$(date +%s | tail -c 4)"
sed -i "s/WORKGROUP/${WORKGROUP_NAME}/g" feeds/packages/net/samba4/files/samba.config
sed -i "s/workgroup \"WORKGROUP\"/workgroup \"${WORKGROUP_NAME}\"/g" feeds/packages/net/samba4/files/samba.init

# 取消bootstrap为默认主题
sed -i '/set_opt main.mediaurlbase \/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i 's/Bootstrap theme/Argon theme/g' feeds/luci/collections/*/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/*/Makefile

# luci-compat - 修复上移下移按钮翻译
sed -i 's/<%:Up%>/<%:Move up%>/g' feeds/luci/modules/luci-compat/luasrc/view/cbi/tblsection.htm
sed -i 's/<%:Down%>/<%:Move down%>/g' feeds/luci/modules/luci-compat/luasrc/view/cbi/tblsection.htm

# luci-compat - remove extra line breaks from description
sed -i '/<br \/>/d' feeds/luci/modules/luci-compat/luasrc/view/cbi/full_valuefooter.htm

# 修复procps-ng-top导致首页cpu使用率无法获取
sed -i 's#top -n1#\/bin\/busybox top -n1#g' feeds/luci/modules/luci-base/root/usr/share/rpcd/ucode/luci

# 最大连接数修改为65535
sed -i '$a net.netfilter.nf_conntrack_max=65535' package/base-files/files/etc/sysctl.conf

#nlbwmon 修复log警报
sed -i '$a net.core.wmem_max=16777216' package/base-files/files/etc/sysctl.conf
sed -i '$a net.core.rmem_max=16777216' package/base-files/files/etc/sysctl.conf

# 删除所有包含 luci-app-attendedsysupgrade 的 Makefile 行
for f in $(grep -rl 'luci-app-attendedsysupgrade' package feeds | grep 'Makefile$'); do
    echo -n "Cleaning $f ..."
    sed -i '/luci-app-attendedsysupgrade/d' "$f"
    echo "✅"
done

# 报错修复
# sed -i 's/+libpcre/+libpcre2/g' package/feeds/telephony/freeswitch/Makefile

# rust(ci false)
if [ "$REPO_BRANCH" != "openwrt-23.05" ]; then
  if ! grep -q -- '--ci[[:space:]]\+false' feeds/packages/lang/rust/Makefile; then
    echo -n "Repair rust ..."
    # sed -i 's/--set=llvm\.download-ci-llvm=true/--set=llvm.download-ci-llvm=false/' feeds/packages/lang/rust/Makefile
    sed -i 's/--build-dir\ $(HOST_BUILD_DIR)\/build/--build-dir\ $(HOST_BUILD_DIR)\/build\ \\\n\		--ci\ false/' feeds/packages/lang/rust/Makefile
    echo "✅"
  fi
fi

# 修复ramfree位置问题
sed -i '/"order":/{s/\([0-9]\+\)/"\1"/}' package/feeds/luci/luci-app-ramfree/root/usr/share/luci/menu.d/luci-app-ramfree.json

# 添加整个源仓库(git_clone)/添加源仓库内的指定目录(clone_dir)/添加源仓库内的所有目录(clone_all)
# filebrowser luci-app-pushbot
clone_dir main https://github.com/xiangfeidexiaohuo/2305-ipk luci-app-adguardhome luci-app-pushbot luci-app-poweroff luci-app-socat socat

# 同时兼容firewall3/4 的luci-app-socat
clone_dir main https://github.com/chenmozhijin/luci-app-socat luci-app-socat

# luci-app-tailscale
sed -i '/\/etc\/init\.d\/tailscale/d;/\/etc\/config\/tailscale/d;' feeds/packages/net/tailscale/Makefile
git_clone https://github.com/asvow/luci-app-tailscale luci-app-tailscale

# 看门狗(菜单项放到服务里面)
clone_dir main https://github.com/sirpdboy/luci-app-watchdog.git luci-app-watchdog watchdog
sed -i '/"admin\/control"[[:space:]]*:/,/^[[:space:]]*},/d' $destination_dir/luci-app-watchdog/root/usr/share/luci/menu.d/luci-app-watchdog.json
sed -i 's#"admin/control/#"admin/services/#g' $destination_dir/luci-app-watchdog/root/usr/share/luci/menu.d/luci-app-watchdog.json

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
    echo -n "当前 ddnsto 版本是: $ddnsto_ver, 开始替换......"

    sed -i 's|PKG_SOURCE_URL:=.*|PKG_SOURCE_URL:=https://github.com/Jejz168/OpenWrt/raw/refs/heads/main/personal/ddnsto/|' $destination_dir/ddnsto/Makefile

    echo "✅ 替换完成！"
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

# alist
git_clone https://github.com/sbwml/packages_lang_golang golang
clone_all https://github.com/sbwml/luci-app-alist

# ssr-plus
clone_all https://github.com/fw876/helloworld

# passwall
clone_all https://github.com/xiaorouji/openwrt-passwall-packages
clone_all https://github.com/xiaorouji/openwrt-passwall

# passwall2
# clone_all https://github.com/xiaorouji/openwrt-passwall2

# Nikki
clone_all https://github.com/nikkinikki-org/OpenWrt-nikki

# filemanager文件管理
git_clone https://github.com/sbwml/luci-app-filemanager luci-app-filemanager

# netspeedtest网络测试
clone_dir main https://github.com/sbwml/openwrt_pkgs luci-app-netspeedtest speedtest-cli

# openclash
clone_dir master https://github.com/vernesong/OpenClash luci-app-openclash
# clone_dir dev https://github.com/vernesong/OpenClash luci-app-openclash
# 编译 po2lmo (如果有po2lmo可跳过)
pushd feeds/luci/applications/luci-app-openclash/tools/po2lmo
make && sudo make install
popd

# 添加主题
git_clone https://github.com/sirpdboy/luci-theme-kucat
git_clone https://github.com/sirpdboy/luci-app-kucat-config
# git_clone https://github.com/kiddin9/luci-theme-edge
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
    PRIMARY_COLORS=("#FF8C00" "#1E90FF" "#FF69B4" "#FF1493" "#e2c312" "#00CED1" "#DC143C")
    DARK_PRIMARY_COLORS=("#9370DB" "#8A2BE2" "#D87093" "#C71585" "#B8860B" "#4682B4" "#8B0000")
    WEEKDAY=$(date +%w)
    sed -i "s/option primary '#[0-9a-fA-F]\{6\}'/option primary '${PRIMARY_COLORS[$WEEKDAY]}'/" $ARGON_CONFIG_FILE
    sed -i "s/option dark_primary '#[0-9a-fA-F]\{6\}'/option dark_primary '${DARK_PRIMARY_COLORS[$WEEKDAY]}'/" $ARGON_CONFIG_FILE

    echo "argon theme has been customized!"
fi

# 修改主题多余版本信息
sed -i 's|<a class="luci-link" href="https://github.com/openwrt/luci"|<a|g' feeds/luci/themes/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i 's|<a class="luci-link" href="https://github.com/openwrt/luci"|<a|g' feeds/luci/themes/luci-theme-argon/luasrc/view/themes/argon/footer_login.htm
sed -i 's|<a href="https://github.com/jerrykuku/luci-theme-argon" target="_blank">|<a>|g' feeds/luci/themes/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i 's|<a href="https://github.com/jerrykuku/luci-theme-argon" target="_blank">|<a>|g' feeds/luci/themes/luci-theme-argon/luasrc/view/themes/argon/footer_login.htm

# 显示增加编译时间(时间为4改5)
if [ "${REPO_BRANCH#*-}" = "23.05" ]; then
   sed -i "s/DISTRIB_DESCRIPTION=.*/DISTRIB_DESCRIPTION=\"ImmortalWrt R$(TZ=UTC-8 date +'%y.%-m.%-d') (By @Jejz build $(TZ=UTC-8 date '+%Y-%m-%d') $(TZ=UTC-8 date +'%H' | sed -e 's/4/5/g'):$(TZ=UTC-8 date +%M | sed -e 's/4/5/g'))\"/g" package/base-files/files/etc/openwrt_release
   echo -e "\e[41m当前写入的编译时间:\e[0m \e[33m$(grep 'DISTRIB_DESCRIPTION' package/base-files/files/etc/openwrt_release)\e[0m"
else
   sed -i "s/DISTRIB_DESCRIPTION=.*/DISTRIB_DESCRIPTION=\"ImmortalWrt By @Jejz\"/g"  package/base-files/files/etc/openwrt_release
   sed -i "s/OPENWRT_RELEASE=.*/OPENWRT_RELEASE=\"ImmortalWrt R$(TZ=UTC-8 date +'%y.%-m.%-d') (By @Jejz build $(TZ=UTC-8 date '+%Y-%m-%d') $(TZ=UTC-8 date +'%H' | sed -e 's/4/5/g'):$(TZ=UTC-8 date +%M | sed -e 's/4/5/g'))\"/g" package/base-files/files/usr/lib/os-release
   echo -e "\e[41m当前写入的编译时间:\e[0m \e[33m$(grep 'OPENWRT_RELEASE' package/base-files/files/usr/lib/os-release)\e[0m"
fi

# 修改欢迎banner
cp -f $GITHUB_WORKSPACE/diy_script/immo_diy/x86/99-default-settings package/emortal/default-settings/files/99-default-settings
# cp -f $GITHUB_WORKSPACE/personal/banner-immo package/base-files/files/etc/banner
# wget -O ./package/base-files/files/etc/banner https://raw.githubusercontent.com/Jejz168/OpenWrt/main/personal/banner
sed -i "/%D/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ [31m By @Jejz build $(TZ=UTC-8 date '+%Y.%m.%d') [0m" package/base-files/files/etc/banner
cat package/base-files/files/etc/banner

# 补充 firewall4 luci 中文翻译
cat >> "feeds/luci/applications/luci-app-firewall/po/zh_Hans/firewall.po" <<-EOF
	
	msgid ""
	"Custom rules allow you to execute arbitrary nft commands which are not "
	"otherwise covered by the firewall framework. The rules are executed after "
	"each firewall restart, right after the default ruleset has been loaded."
	msgstr ""
	"自定义规则允许您执行不属于防火墙框架的任意 nft 命令。每次重启防火墙时，"
	"这些规则在默认的规则运行后立即执行。"
	
	msgid ""
	"Applicable to internet environments where the router is not assigned an IPv6 prefix, "
	"such as when using an upstream optical modem for dial-up."
	msgstr ""
	"适用于路由器未分配 IPv6 前缀的互联网环境，例如上游使用光猫拨号时。"

	msgid "NFtables Firewall"
	msgstr "NFtables 防火墙"

	msgid "IPtables Firewall"
	msgstr "IPtables 防火墙"
EOF

# 晶晨宝盒
clone_dir main https://github.com/ophub/luci-app-amlogic luci-app-amlogic
sed -i "s|https.*/OpenWrt|https://github.com/Jejz168/OpenWrt|g" $destination_dir/luci-app-amlogic/root/etc/config/amlogic
# sed -i "s|http.*/library|https://github.com/Jejz168/OpenWrt/backup/kernel|g" $destination_dir/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|ARMv8|ARMv8|g" $destination_dir/luci-app-amlogic/root/etc/config/amlogic

# 修正部分从第三方仓库拉取的软件 Makefile 路径问题
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/lang\/golang\/golang-package.mk/$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang-package.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHREPO/PKG_SOURCE_URL:=https:\/\/github.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload.github.com/g' {}

# 设置 nlbwmon 独立菜单
sed -i 's/524288/16777216/g' feeds/packages/net/nlbwmon/files/nlbwmon.config
sed -i 's/option commit_interval.*/option commit_interval 24h/g' feeds/packages/net/nlbwmon/files/nlbwmon.config
sed -i 's/services\/nlbw/nlbw/g; /path/s/admin\///g' feeds/luci/applications/luci-app-nlbwmon/root/usr/share/luci/menu.d/luci-app-nlbwmon.json
sed -i 's/services\///g' feeds/luci/applications/luci-app-nlbwmon/htdocs/luci-static/resources/view/nlbw/config.js

# 调整位置
primary_dir="feeds/luci/applications"
fallback_dir="$destination_dir"
apps=(
    "luci-app-filebrowser:services/nas"
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
sed -i 's,UPnP IGD 和 PCP,UPnP,g' feeds/luci/applications/luci-app-upnp/po/zh_Hans/upnp.po
sed -i 's/msgstr "主题设置"/msgstr "Argon 设置"/g' $(grep 'msgstr "主题设置"' -rl ./)
sed -i '/msgstr "/s/KuCat\(主题设置\|主题颜色\|设置\)/KuCat \1/g' $(grep -rl 'msgstr "KuCat' ./)

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
