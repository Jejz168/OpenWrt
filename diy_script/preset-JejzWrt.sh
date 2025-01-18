#!/bin/bash

# 创建文件夹结构
[ -d files/bin ] || mkdir -p files/bin

# 创建脚本文件
cat << 'EOF' > files/bin/JejzWrt
#!/bin/bash

# 获取内核版本
kernel_version=$(uname -r)

# 获取平台架构
platform=$(uname -m)

# 获取 CPU 型号
cpu_model=$(awk -F ': ' '/model name/ {print $2}' /proc/cpuinfo | uniq)

# 获取系统的运行时间（包括秒），并去掉小数
uptime_seconds=$(cat /proc/uptime | awk '{print int($1)}')

# 计算天、小时、分钟和秒（去掉小数）
days=$((uptime_seconds / 86400))
hours=$(( (uptime_seconds % 86400) / 3600 ))
minutes=$(( (uptime_seconds % 3600) / 60 ))
seconds=$((uptime_seconds % 60))

# 获取内存使用情况
mem_usage=$(free | awk '/Mem/ {printf "%d%% of %dM\n", $3/$2*100, int($2/1024)}')

# 获取 IP 地址
ip_addresses=$(ip -4 addr show dev br-lan | awk '/inet / {gsub(/\/.*/, "", $2); print $2}')

# 获取 CPU 温度（需要安装 kmod-thermal 模块）
cpu_temp=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null | awk '{printf "%.0f°C", $1/1000}')

# 获取磁盘使用情况
disk_usage=$(df -h / | awk '/\// {printf "%s of %s", $5, $2}')

# 判断系统是通过 BIOS 还是 UEFI 启动
if [ -d /sys/firmware/efi ]; then
    boot_mode="UEFI"
else
    boot_mode="BIOS"
fi

# 彩色输出函数
color_output() {
    echo -e "$1"
}

# 打印脚本头部，增加美观
print_header() {
    clear
    color_output "\e[31m~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\e[0m"
    color_output "\e[36m\       _      _   __          __   _        / \e[0m"
    color_output "\e[36m\      | |    (_)  \ \        / /  | |       / \e[0m"
    color_output "\e[36m\      | | ___ _ ___\ \  /\  / / __| |_      / \e[0m"
    color_output "\e[36m\  _   | |/ _ \ |_  /\ \/  \/ / '__| __|     / \e[0m"
    color_output "\e[33m\ | |__| |  __/ |/ /  \  /\  /| |  | |_      / \e[0m"
    color_output "\e[33m\  \____/ \___| /___|  \/  \/ |_|   \__|     / \e[0m"
    color_output "\e[33m\            _/ |                            / \e[0m"
    color_output "\e[33m\           |__/                             / \e[0m"
    color_output "\e[35m\          J e j z W r t   By   J e j z      / \e[0m"
    color_output "\e[31m~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\e[0m"
    echo -e "\e[96mCPU Model:       $cpu_model \e[0m"
    echo -e "Run Time:        $days 天 $hours 小时 $minutes 分钟 $seconds 秒 "
    echo -e "Memory Usage:    $mem_usage "
    echo -e "Kernel Ver:      $kernel_version $cpu_temp "
    echo -e "Overlay /TMP:    $disk_usage "
    echo -e "Target Info:     $platform - $boot_mode "
    echo -e "\e[31mIpv4 Address\e[0m:    \e[41m$ip_addresses\e[0m"
    echo " "
}

# 显示菜单
show_menu() {
    echo "=============================================="
    echo -e "\e[41mJejzWrt\e[0m \e[35m快捷命令菜单（Shortcut Command Menu）\e[0m         "
    echo "=============================================="
    echo -e "\e[33m1. 更改 LAN 口 IP 地址（Change LAN port IP address）\e[0m"
    echo -e "\e[33m2. 更改管理员密码（Change administrator password）\e[0m"
    echo -e "\e[33m3. 重置网络和切换默认主题（Reset network and Switch default theme）\e[0m"
    echo -e "\e[33m4. 重启系统（Reboot）\e[0m"
    echo -e "\e[33m5. 关闭系统（Shutdown）\e[0m"
    echo -e "\e[33m6. 释放内存（Release memory）\e[0m"
    echo -e "\e[33m7. 恢复出厂设置（Restore factory settings）\e[0m"
    echo "0/q. 退出本快捷菜单（Exit shortcut menu）"
    echo "=============================================="
    printf "请输入功能编号(Enter the function number): "
    read choice
    case "$choice" in
        1) change_ip ;;
        2) change_password ;;
        3) change_theme ;;
        4) reboot_system ;;
        5) shutdown_system ;;
        6) echo "正在清理内存缓存..."; sync && echo 3 > /proc/sys/vm/drop_caches; echo "内存缓存已清理"; show_menu ;;
        7) reset_config ;;
        0|q|Q) exit 0 ;;
        *) echo "无效选项，请重新输入"; show_menu ;;
    esac
}

# 更改 LAN 口 IP 地址
# 判断IP地址是否合法
is_valid_ip() {
    local ip="$1"
    # 使用正则表达式检查 IP 地址格式
    if [[ "$ip" =~ ^([1-9]{1}[0-9]{0,2}|0){1}\.([1-9]{1}[0-9]{0,2}|0){1}\.([1-9]{1}[0-9]{0,2}|0){1}\.([1-9]{1}[0-9]{0,2}|0){1}$ ]]; then
        # 检查每个段的数字是否在 0 到 255 之间
        IFS='.' read -r -a octets <<< "$ip"
        for octet in "${octets[@]}"; do
            if [[ "$octet" -lt 1 || "$octet" -gt 255 ]]; then
                return 1  # 不合法
            fi
        done
        return 0  # 合法
    else
        return 1  # 格式不正确
    fi
}

change_ip() {
    # 提示用户是否确认更改 IP 地址
    echo -n "是否确定要更改 LAN 口 IP 地址？(y/n): "
    read confirm_ip

    if [[ "$confirm_ip" == "y" || "$confirm_ip" == "Y" ]]; then
        # 用户确认后提示输入新的 LAN 口 IP 地址
        printf "请输入新的 LAN 口 IP 地址（如 192.168.1.2），按 Enter 返回菜单："
        read new_ip

        # 如果用户没有输入新 IP，取消操作
        if [[ -z "$new_ip" ]]; then
            echo "操作已取消，返回菜单。"
            show_menu
            return
        fi

        # 如果输入的 IP 地址格式无效
        if ! is_valid_ip "$new_ip"; then
            echo "无效的 IP 地址格式，操作取消。"
            show_menu
            return
        fi

        # 使用 UCI 更改 IP 地址
        uci set network.lan.ipaddr="$new_ip"
        uci commit network
        /etc/init.d/network restart
        echo "LAN 口 IP 已成功更改为 $new_ip"
    else
        # 如果用户取消操作
        echo "IP 地址更改已取消。"
    fi

    # 返回菜单
    printf "按 Enter 键返回菜单..."
    read
    show_menu
}

# 更改管理员密码
change_password() {
    # 提示用户是否确认更改管理员密码
    echo -n "是否确定要更改管理员密码？(y/n): "
    read confirm_password

    if [[ "$confirm_password" == "y" || "$confirm_password" == "Y" ]]; then
        # 用户确认后提示输入新密码
        printf "请输入新的管理员密码，按 Enter 返回菜单："
        read new_password

        # 如果用户未输入密码，则取消操作
        if [[ -z "$new_password" ]]; then
            echo "操作已取消，返回菜单。"
            show_menu
            return
        fi

        # 使用 OpenWrt 的 `passwd` 工具更新密码
        echo -e "$new_password\n$new_password" | passwd root
        echo "管理员密码已成功更改。"
    else
        # 如果用户取消操作
        echo "密码更改已取消。"
    fi

    # 返回菜单
    printf "按 Enter 键返回菜单..."
    read
    show_menu
}

# 重置网络和切换默认主题
change_theme() {
    # 提示用户是否更改 luci 配置
    echo -n "是否要更改主题配置为默认主题？(y/n): "
    read confirm_theme

    if [[ "$confirm_theme" == "y" || "$confirm_theme" == "Y" ]]; then
        # 使用 UCI 更改 luci 配置
        uci set luci.main.mediaurlbase='/luci-static/bootstrap'
        uci commit luci
        echo "主题已成功切换为默认主题。"
    else
        echo "主题更改已取消。"
    fi
 
    # 提示是否重启网络
    echo -n "是否要重启网络服务？(y/n): "
    read reset_choice
    if [[ "$reset_choice" == "y" || "$reset_choice" == "Y" ]]; then
        echo "正在重启网络..."
        /etc/init.d/network restart
        echo "网络已重启。"
    else
        echo "网络设置未更改。"
    fi

    # 返回菜单
    printf "按 Enter 键返回菜单..."
    read
    show_menu
}

# 一键重启
reboot_system() {
    printf "确定要重启系统吗？(y/n): "
    read confirm_reboot

    if [[ "$confirm_reboot" == "y" || "$confirm_reboot" == "Y" ]]; then
        echo "正在重启系统..."
        reboot
    else
        echo "系统重启操作已取消。"
    fi

    # 返回菜单
    printf "按 Enter 键返回菜单..."
    read
    show_menu
}

# 一键关闭系统
shutdown_system() {
    printf "确定要关闭系统吗？(y/n): "
    read confirm_shutdown

    if [[ "$confirm_shutdown" == "y" || "$confirm_shutdown" == "Y" ]]; then
        echo "正在关闭系统..."
        poweroff
    else
        echo "系统关闭操作已取消。"
    fi

    # 返回菜单
    printf "按 Enter 键返回菜单..."
    read
    show_menu
}

# 一键重置配置
reset_config() {
    # 提示用户是否确认恢复出厂设置
    echo -n "是否确定要恢复出厂设置？此操作将清除所有配置！(y/n): "
    read confirm_reset

    if [[ "$confirm_reset" == "y" || "$confirm_reset" == "Y" ]]; then
        # 执行恢复出厂设置
        echo "恢复出厂设置中..."
        firstboot -y
        
        # 提示用户设备重启
        echo "设备将在 5 秒钟后重启..."
        sleep 5
        reboot
    else
        echo "恢复出厂设置已取消。"
    fi

    # 返回菜单
    printf "按 Enter 键返回菜单..."
    read
    show_menu
}

# 启动菜单
print_header
show_menu
EOF

# 设置脚本权限
chmod +x files/bin/JejzWrt

# 重定向 menu -> JejzWrt
ln -s /bin/JejzWrt files/bin/menu
