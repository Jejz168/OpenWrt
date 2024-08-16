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
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package/custom
  cd .. && rm -rf $repodir
}
rm -rf package/custom; mkdir package/custom

# 修改默认IP
sed -i 's/192.168.1.1/192.168.8.3/g' package/base-files/files/bin/config_generate

# 设置ttyd免帐号登录
sed -i 's/\/bin\/login/\/bin\/login -f root/' feeds/packages/utils/ttyd/files/ttyd.config

# 默认 shell 为 bash
sed -i 's/\/bin\/ash/\/bin\/bash/g' package/base-files/files/etc/passwd

# samba解除root限制
sed -i 's/invalid users = root/#&/g' feeds/packages/net/samba4/files/smb.conf.template

# 修改 argon 为默认主题
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i 's/Bootstrap theme/Argon theme/g' feeds/luci/collections/luci/Makefile
sed -i 's/Bootstrap theme/Argon theme/g' feeds/luci/collections/luci-nginx/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-nginx/Makefile

# 报错修复
sed -i 's/+libpcre/+libpcre2/g' package/feeds/telephony/freeswitch/Makefile

# git_sparse_clone 复制 仓库下的文件夹 git clone 复制整个仓库
# vssr adguardhome turboacc去dns
rm -rf package/feeds/packages/adguardhome
git_sparse_clone master https://github.com/xiangfeidexiaohuo/extra-ipk luci-app-adguardhome

# ddns-go 动态域名
# git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go.git package/ddns-go

# chatgpt
git clone --depth=1 https://github.com/sirpdboy/luci-app-chatgpt-web package/luci-app-chatgpt

# lucky 大吉
git clone --depth=1 https://github.com/gdy666/luci-app-lucky.git package/lucky

# ddnsto
git_sparse_clone main https://github.com/linkease/nas-packages-luci luci/luci-app-ddnsto
git_sparse_clone master https://github.com/linkease/nas-packages network/services/ddnsto

# OpenAppFilter 应用过滤
rm -rf feeds/packages/net/open-app-filter
git clone --depth=1 https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter

# autotimeset 定时
# git clone --depth=1 https://github.com/sirpdboy/luci-app-autotimeset package/luci-app-autotimeset

# dockerman
# rm -rf feeds/luci/applications/luci-app-dockerman
# git clone --depth=1 https://github.com/lisaac/luci-app-dockerman.git package/luci-app-dockerman

# eqos 限速
# git_sparse_clone master https://github.com/kenzok8/openwrt-packages luci-app-eqos

# poweroff
git clone https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff

# unblockneteasemusic
# git clone --depth=1 https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/luci-app-unblockneteasemusic

# filebrowser 文件浏览器
rm -rf feeds/luci/applications/luci-app-filebrowser
git_sparse_clone main https://github.com/Lienol/openwrt-package luci-app-filebrowser

# smartdns
rm -rf feeds/packages/net/smartdns
rm -rf feeds/luci/applications/luci-app-smartdns
git clone --depth=1 -b lede https://github.com/pymumu/luci-app-smartdns.git package/luci-app-smartdns
git clone --depth=1 https://github.com/pymumu/openwrt-smartdns package/smartdns

# mosdns
rm -rf feeds/packages/net/mosdns
rm -rf feeds/luci/applications/luci-app-mosdns
git clone --depth=1 https://github.com/sbwml/luci-app-mosdns package/luci-app-mosdns

# alist
rm -rf feeds/packages/lang/golang
rm -rf feeds/packages/net/alist
rm -rf feeds/luci/applications/luci-app-alist
git clone --depth=1 https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang
git clone --depth=1 https://github.com/sbwml/luci-app-alist package/alist

# passwall
rm -rf feeds/luci/applications/luci-app-passwall
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall luci-app-passwall

# passwall2
# git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall2 luci-app-passwall2

# mihomo
git clone --depth=1 https://github.com/morytyann/OpenWrt-mihomo package/luci-app-mihomo

# openclash
rm -rf feeds/luci/applications/luci-app-openclash
git_sparse_clone master https://github.com/vernesong/OpenClash luci-app-openclash
# svn co https://github.com/vernesong/OpenClash/branches/dev/luci-app-openclash package/luci-app-openclash
# 编译 po2lmo (如果有po2lmo可跳过)
pushd package/custom/luci-app-openclash/tools/po2lmo
make && sudo make install
popd

# argon 主题
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-design
rm -rf feeds/luci/applications/luci-app-argon-config
rm -rf feeds/luci/applications/luci-app-design-config
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
git clone --depth=1 https://github.com/gngpp/luci-theme-design.git package/luci-theme-design
git clone --depth=1 https://github.com/gngpp/luci-app-design-config.git package/luci-app-design-config

# 更改argon主题背景
cp -f $GITHUB_WORKSPACE/personal/bg1.jpg package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# 修改主题多余版本信息
sed -i 's|<a class="luci-link" href="https://github.com/openwrt/luci"|<a|g' package/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i 's|<a href="https://github.com/jerrykuku/luci-theme-argon" target="_blank">|<a>|g' package/luci-theme-argon/luasrc/view/themes/argon/footer.htm

# 修改欢迎banner
# cp -f $GITHUB_WORKSPACE/personal/banner package/base-files/files/etc/banner
# wget -O ./package/base-files/files/etc/banner https://raw.githubusercontent.com/Jejz168/OpenWrt/main/personal/banner

# 修改makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/luci\.mk/include \$(TOPDIR)\/feeds\/luci\/luci\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/lang\/golang\/golang\-package\.mk/include \$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang\-package\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHREPO/PKG_SOURCE_URL:=https:\/\/github\.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload\.github\.com/g' {}

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

./scripts/feeds update -a
./scripts/feeds install -a

echo "========================="
echo " DIY2 配置完成……"
