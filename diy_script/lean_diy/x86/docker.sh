#!/bin/bash
#===============================================
# File name: docker.sh
# Lisence: MIT
# By: Jejz
#===============================================

echo "加入docker套件……"
echo "========================="

## docker套件
sed -i 's/CONFIG_TARGET_ROOTFS_PARTSIZE.*/CONFIG_TARGET_ROOTFS_PARTSIZE=5120/g' .config
sed -i 's/# CONFIG_PACKAGE_luci-app-dockerman is not set/CONFIG_PACKAGE_luci-app-dockerman=y/g' .config
sed -i 's/# CONFIG_PACKAGE_docker is not set/CONFIG_PACKAGE_docker=y/g' .config
sed -i 's/# CONFIG_PACKAGE_dockerd is not set/CONFIG_PACKAGE_dockerd=y/g' .config
sed -i 's/# CONFIG_PACKAGE_docker-compose is not set/CONFIG_PACKAGE_docker-compose=y/g' .config
sed -i 's/# CONFIG_PACKAGE_containerd is not set/CONFIG_PACKAGE_containerd=y/g' .config
sed -i 's/# CONFIG_PACKAGE_runc is not set/CONFIG_PACKAGE_runc=y/g' .config
#sed -i 's/# CONFIG_PACKAGE_libnetwork is not set/CONFIG_PACKAGE_libnetwork=y/g' .config
sed -i 's/# CONFIG_PACKAGE_tini is not set/CONFIG_PACKAGE_tini=y/g' .config
sed -i '/# CONFIG_PACKAGE_digitemp-usb is not set/a\CONFIG_DOCKER_CGROUP_OPTIONS=y' .config
sed -i '/# CONFIG_PACKAGE_luci-i18n-ddnsto-zh_Hans is not set/a\CONFIG_PACKAGE_luci-i18n-dockerman-zh-cn=y'  .config
sed -i '/CONFIG_PACKAGE_luci-i18n-dockerman-zh-cn=y/a\# CONFIG_PACKAGE_luci-i18n-dockerman-zh_Hans is not set'  .config
