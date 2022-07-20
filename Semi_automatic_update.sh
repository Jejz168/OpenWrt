#!/bin/bash
#此文件修改好后放到openwrt的root目录中
#运行方法 cd /root && chmod +x Semi_automatic_update.sh && ./Semi_automatic_update.sh
#手动填写
#对应更新时间（主要年月日）必须要写对
update_time=20220719
#内核简写（不换内核可以不用改）
kernel=515
#对应内核具体版本
kernel_version=5.15.55
#固件地址
OPENWRT_URL=https://github.com/Jejz168/OpenWrt/releases/download/${update_time}-x86_64_${kernel}/openwrt_x86-64_${kernel_version}_bios.img.gz
OPENWRT_UEFI_URL=https://github.com/Jejz168/OpenWrt/releases/download/${update_time}-x86_64_${kernel}/openwrt_x86-64_${kernel_version}_uefi.img.gz
#MD5地址
openwrt_md5=https://github.com/Jejz168/OpenWrt/releases/download/${update_time}-x86_64_${kernel}/openwrt_bios.md5
openwrt_md5_uefi=https://github.com/Jejz168/OpenWrt/releases/download/${update_time}-x86_64_${kernel}/openwrt_uefi.md5
#防止内存不足tmp扩容到2g，升级重启后恢复
mount -t tmpfs -o remount,size=2G tmpfs /tmp
#判断系统
if [ ! -d /sys/firmware/efi ];then
    wget -P /tmp "$OPENWRT_URL" -O /tmp/openwrt_x86-64_${kernel_version}_bios.img.gz
	wget -P /tmp "$openwrt_md5" -O /tmp/openwrt_bios.md5
	cd /tmp && md5sum -c openwrt_bios.md5
	Boot_type=logic
else
    wget -P /tmp "$OPENWRT_UEFI_URL" -O /tmp/openwrt_x86-64_${kernel_version}_uefi.img.gz
	wget -P /tmp "$openwrt_md5_uefi" -O /tmp/openwrt_uefi.md5
	cd /tmp && md5sum -c openwrt_uefi.md5
    Boot_type=efi
fi
#升级选择
open_up()
{
echo
clear
read -n 1 -p  " 您是否要保留配置升级，保留选择Y,否则选N:" num1
echo
case $num1 in
	Y|y)
	echo
  echo -e "\033[32m >>>正在准备保留配置升级，请稍后，等待系统重启…-> \033[0m"
	echo
	sleep 3
	if [ ! -d /sys/firmware/efi ];then
		gzip -d openwrt_x86-64_${kernel_version}_bios.img.gz
		sysupgrade /tmp/openwrt_x86-64_${kernel_version}_bios.img
	else
		gzip -d openwrt_x86-64_${kernel_version}_uefi.img.gz
		sysupgrade /tmp/openwrt_x86-64_${kernel_version}_uefi.img
	fi
    ;;
    n|N)
    echo
    echo -e "\033[32m >>>正在准备不保留配置升级，请稍后，等待系统重启…-> \033[0m"
    echo
    sleep 3
	if [ ! -d /sys/firmware/efi ];then
		gzip -d openwrt_x86-64-${new_version}_dev_Lenyu.img.gz
		sysupgrade -n  /tmp/openwrt_x86-64-${new_version}_dev_Lenyu.img
	else
		gzip -d openwrt_x86-64-${new_version}_uefi-gpt_dev_Lenyu.img.gz
		sysupgrade -n  /tmp/openwrt_x86-64-${new_version}_uefi-gpt_dev_Lenyu.img
	fi
    ;;
    *)
	  echo
    echo -e "\033[31m err：只能选择Y/N\033[0m"
	  echo
    read -n 1 -p  "请回车继续…"
	  echo
	  open_up
esac
}
open_op()
{
echo
read -n 1 -p  " 您确定要升级吗，升级选择Y,否则选N:" num1
echo
case $num1 in
	Y|y)
	  open_up
    ;;
  n|N)
    echo
    echo -e "\033[31m >>>您已选择退出固件升级，已经终止脚本…-> \033[0m"
    echo
    exit 1
    ;;
  *)
    echo
    echo -e "\033[31m err：只能选择Y/N\033[0m"
    echo
    read -n 1 -p  "请回车继续…"
    echo
    open_op
esac
}
open_op
exit 0