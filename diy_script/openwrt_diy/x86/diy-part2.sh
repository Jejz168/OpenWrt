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
sed -i 's/192.168.1.1/192.168.8.3/g' package/base-files/files/bin/config_generate

# 替换时区
sed -i "s/timezone='.*'/timezone='CST-8'/g" package/base-files/files/bin/config_generate
if ! grep -q "zonename=" package/base-files/files/bin/config_generate; then
    sed -i "/timezone='CST-8'/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ set system.@system[-1].zonename='Asia/Shanghai'" package/base-files/files/bin/config_generate
else
    sed -i "s/zonename='.*'/zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate
fi

# 替换ntp服务器
sed -i 's/0.openwrt.pool.ntp.org/ntp.tencent.com/g' package/base-files/files/bin/config_generate
sed -i 's/1.openwrt.pool.ntp.org/ntp1.aliyun.com/g' package/base-files/files/bin/config_generate
sed -i 's/2.openwrt.pool.ntp.org/ntp.ntsc.ac.cn/g' package/base-files/files/bin/config_generate
sed -i 's/3.openwrt.pool.ntp.org/cn.ntp.org.cn/g' package/base-files/files/bin/config_generate

# 设置ttyd免帐号登录
sed -i 's/\/bin\/login/\/bin\/login -f root/' feeds/packages/utils/ttyd/files/ttyd.config

# 默认 shell 为 bash
sed -i 's/\/bin\/ash/\/bin\/bash/g' package/base-files/files/etc/passwd

# 精简 UPnP 菜单名称
sed -i 's#\"title\": \"UPnP IGD \& PCP/NAT-PMP\"#\"title\": \"UPnP\"#g' feeds/luci/applications/luci-app-upnp/root/usr/share/luci/menu.d/luci-app-upnp.json

# samba解除root限制
sed -i 's/invalid users = root/#&/g' feeds/packages/net/samba4/files/smb.conf.template

# samba工作组冲突
WORKGROUP_NAME="WORKGROUP_$(date +%s | tail -c 4)"
sed -i "s/workgroup = .*/workgroup = ${WORKGROUP_NAME}/g" feeds/packages/net/samba4/files/smb.conf.template

# 取消bootstrap为默认主题
sed -i '/set_opt main.mediaurlbase \/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i 's/Bootstrap theme/Argon theme/g' feeds/luci/collections/*/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/*/Makefile

# 修复上移下移按钮翻译
sed -i 's/<%:Up%>/<%:Move up%>/g' feeds/luci/modules/luci-compat/luasrc/view/cbi/tblsection.htm
sed -i 's/<%:Down%>/<%:Move down%>/g' feeds/luci/modules/luci-compat/luasrc/view/cbi/tblsection.htm

# 修复procps-ng-top导致首页cpu使用率无法获取
sed -i 's#top -n1#\/bin\/busybox top -n1#g' feeds/luci/modules/luci-base/root/usr/share/rpcd/ucode/luci

# 最大连接数修改为65535
sed -i '$a net.netfilter.nf_conntrack_max=65535' package/base-files/files/etc/sysctl.conf

#nlbwmon 修复log警报
sed -i '$a net.core.wmem_max=16777216' package/base-files/files/etc/sysctl.conf
sed -i '$a net.core.rmem_max=16777216' package/base-files/files/etc/sysctl.conf

# 报错修复
# rm -rf feeds/packages/utils/v2dat

# 添加整个源仓库(git_clone)/添加源仓库内的指定目录(clone_dir)/添加源仓库内的所有目录(clone_all)
# filebrowser luci-app-pushbot
rm -rf feeds/packages/net/adguardhome
clone_dir main https://github.com/xiangfeidexiaohuo/2305-ipk luci-app-adguardhome luci-app-pushbot luci-app-poweroff

# 判断 REPO_BRANCH 再设置
if [ "$REPO_BRANCH" = "openwrt-23.05" ]; then
    echo "Detected REPO_BRANCH as openwrt-23.05..."
    # 替换immortalwrt插件
    clone_dir openwrt-23.05 https://github.com/immortalwrt/luci luci-app-zerotier luci-app-openvpn-server luci-app-ipsec-vpnd luci-app-ramfree luci-app-vsftpd luci-app-usb-printer luci-app-autoreboot luci-app-syncdial luci-app-eqos luci-app-nps luci-app-socat luci-app-n2n luci-app-softethervpn luci-app-vlmcsd
    # 补全依赖
    clone_dir openwrt-23.05 https://github.com/immortalwrt/packages zerotier nps n2n socat strongswan vlmcsd vsftpd
else
    # 替换immortalwrt插件
    clone_dir master https://github.com/immortalwrt/luci luci-app-zerotier luci-app-openvpn-server luci-app-ipsec-vpnd luci-app-ramfree luci-app-vsftpd luci-app-usb-printer luci-app-autoreboot luci-app-syncdial luci-app-eqos luci-app-nps luci-app-socat luci-app-n2n luci-app-softethervpn luci-app-vlmcsd
    # 补全依赖
    clone_dir master https://github.com/immortalwrt/packages zerotier nps n2n socat strongswan vlmcsd vsftpd
fi

# ddns-go 动态域名
# clone_all https://github.com/sirpdboy/luci-app-ddns-go

# chatgpt
# git_clone https://github.com/sirpdboy/luci-app-chatgpt-web luci-app-chatgpt

# lucky 大吉
clone_all https://github.com/gdy666/luci-app-lucky

# ddnsto
clone_dir main https://github.com/linkease/nas-packages-luci luci-app-ddnsto
clone_dir master https://github.com/linkease/nas-packages ddnsto

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

# mihomo
clone_all https://github.com/morytyann/OpenWrt-mihomo

# homeproxy
git_clone https://github.com/immortalwrt/homeproxy luci-app-homeproxy

# luci-app-filemanager
git_clone https://github.com/sbwml/luci-app-filemanager luci-app-filemanager

# openclash
clone_dir master https://github.com/vernesong/OpenClash luci-app-openclash
# clone_dir dev https://github.com/vernesong/OpenClash luci-app-openclash
# 编译 po2lmo (如果有po2lmo可跳过)
pushd $destination_dir/luci-app-openclash/tools/po2lmo
make && sudo make install
popd

# argon 主题
# git_clone https://github.com/kiddin9/luci-theme-edge
git_clone https://github.com/jerrykuku/luci-theme-argon
git_clone https://github.com/jerrykuku/luci-app-argon-config
# clone_all https://github.com/sbwml/luci-theme-argon

# argon主题设置
# cp -f $GITHUB_WORKSPACE/personal/bg1.jpg $destination_dir/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
# 获取当天的星期几 (1=星期一, ..., 7=星期日)
bg_file="bg$((($(date +%w) + 6) % 7 + 1)).jpg"
# argon登录页面美化
ARGON_IMG_FILE="$destination_dir/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg"
if [ -f "$ARGON_IMG_FILE" ]; then
    # 替换Argon主题内建壁纸
    cp -f "$GITHUB_WORKSPACE/personal/$bg_file" "$ARGON_IMG_FILE"

    echo "$bg_file argon wallpaper has been replaced!"
fi
ARGON_CONFIG_FILE="$destination_dir/luci-app-argon-config/root/etc/config/argon"
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

# 修改主题多余版本信息
sed -i 's|<a class="luci-link" href="https://github.com/openwrt/luci"|<a|g' $destination_dir/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i 's|<a class="luci-link" href="https://github.com/openwrt/luci"|<a|g' $destination_dir/luci-theme-argon/luasrc/view/themes/argon/footer_login.htm
sed -i 's|<a href="https://github.com/jerrykuku/luci-theme-argon" target="_blank">|<a>|g' $destination_dir/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i 's|<a href="https://github.com/jerrykuku/luci-theme-argon" target="_blank">|<a>|g' $destination_dir/luci-theme-argon/luasrc/view/themes/argon/footer_login.htm

# 显示增加编译时间
if [ "${REPO_BRANCH#*-}" = "23.05" ]; then
   sed -i "s/DISTRIB_DESCRIPTION=.*/DISTRIB_DESCRIPTION=\"OpenWrt R$(TZ=UTC-8 date +'%y.%-m.%-d') (By @Jejz build $(TZ=UTC-8 date '+%Y-%m-%d %H:%M'))\"/g"  package/base-files/files/etc/openwrt_release
   echo -e "\e[41m当前写入的编译时间:\e[0m \e[33m$(grep 'DISTRIB_DESCRIPTION' package/base-files/files/etc/openwrt_release)\e[0m"
else
   sed -i "s/DISTRIB_DESCRIPTION=.*/DISTRIB_DESCRIPTION=\"OpenWrt By @Jejz\"/g"  package/base-files/files/etc/openwrt_release
   sed -i "s/OPENWRT_RELEASE=.*/OPENWRT_RELEASE=\"OpenWrt R$(TZ=UTC-8 date +'%y.%-m.%-d') (By @Jejz build $(TZ=UTC-8 date '+%Y-%m-%d %H:%M'))\"/g"  package/base-files/files/usr/lib/os-release
   echo -e "\e[41m当前写入的编译时间:\e[0m \e[33m$(grep 'OPENWRT_RELEASE' package/base-files/files/usr/lib/os-release)\e[0m"
fi

# 修改欢迎banner
cp -f $GITHUB_WORKSPACE/personal/banner-op package/base-files/files/etc/banner
# wget -O ./package/base-files/files/etc/banner https://raw.githubusercontent.com/Jejz168/OpenWrt/main/personal/banner

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
primary_dir="feeds/luci/applications"
fallback_dir="$destination_dir"
apps=(
    "luci-app-p910nd:services/nas"
    "luci-app-aria2:services/nas"
    "luci-app-samba4:services/nas"
    "luci-app-hd-idle:services/nas"
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
