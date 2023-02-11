#tmp扩容到1g，升级重启后恢复
mount -t tmpfs -o remount,size=1G tmpfs /tmp

##下载解压的文件放openwrt的/tmp/目录
例如：openwrt_x86-64_5.15.55_uefi.img
##再运行下面二选一
#保留配置升级
sysupgrade /tmp/openwrt_x86-64_5.15.55_uefi.img

#不保留配置升级
sysupgrade -n /tmp/openwrt_x86-64_5.15.55_uefi.img
