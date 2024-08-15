<div align="center">
<img width="768" src="https://cdn.jsdelivr.net/gh/Jejz168/Picture/OpenWrt-logo.png"/>
<h1>OpenWrt — Actions</h1>
</div>

-  [**群组**](https://t.me/Jejz_168)
-  🛑******最好全新刷机******
-  ♨️【x86】Docker版（Kernel=32M，rootfs=5120M）和普通（Kernel=32M，rootfs=968M）不通刷
-  本库x86为squashfs格式(Kernel=32M，rootfs=968M)
-  ext4 与squashfs 格式的区别： ext4 格式的rootfs 可以扩展磁盘空间大小，而squashfs 不能。 squashfs 格式的rootfs 可以使用重置功能（恢复出厂设置），而ext4 不能。
-  *必须要是本库最新才能使用。不然就会死翘翘。
-  升级方法：下载好对应的版本（.img.gz），然后（openwrt-系统-备份/升级） *直接选择，不用解压
# ==============================
## 项目说明 [![](https://img.shields.io/badge/-项目基本介绍-FFFFFF.svg)](#项目说明-)
- 固件来源：[![Lean](https://img.shields.io/badge/Lede-Lean-red.svg?style=flat&logo=appveyor)](https://github.com/coolsnowwolf/lede) 
- 项目使用 Github Actions 拉取 [Lean](https://github.com/coolsnowwolf/lede) 的 `Openwrt` 源码仓库进行云编译
- ♨️【x86】Docker版（Kernel=32M，rootfs=5120M）和普通（Kernel=32M，rootfs=968M）不通刷
- 🔴arm 固件默认 IP 地址：`192.168.8.8` 默认密码：`password`
- 🔴x86 固件默认 IP 地址：`192.168.8.3` 默认密码：`无密码`
- 🔴x86[Docker] 固件默认 IP 地址：`192.168.8.3` 默认密码：`无密码`
- 🔴x86[个人版] 固件默认 IP 地址：`192.168.8.5` 默认密码：`无密码`
- 仓库编译的固件插件均为最新版本，最新版意味着可能有 BUG，如果之前使用稳定，则无需追新

## 插件预览 [![](https://img.shields.io/badge/-固件插件及功能预览-FFFFFF.svg)](#插件预览-)
- ******标记arm的，只有arm有******
<details>
<summary><b>&nbsp; 插件预览</b></summary>
<br/>
<details>
<summary><b>├── 状态</b></summary>
　├── 概况<br/>
　├── 防火墙<br/>
　├── 路由表<br/>
　├── 系统日志<br/>
　├── 内核日志<br/>
　├── 系统进程<br/>
　├── 实时信息<br/>
　├── 实时监控<br/>
　├── WireGuard状态<br/>
　├── 负载均衡<br/>
　└── 释放内存
</details>
<details>
<summary><b>├── 系统</b></summary>
　├── 系统<br/>
　├── Web管理<br/>
　├── 管理权<br/>
　├── 软件包<br/>
　├── TTYD 终端<br/>
　├── 启动项<br/>
　├── 计划任务<br/>
　├── 挂载点<br/>
　├── 磁盘管理<br/>
　├── 备份/升级<br/>
　├── 定时设置<br/>
　├── 文件传输<br/>
　├── Argon 主题设置<br/>
　├── Design 主题设置<br/>
　├── 重启<br/>
　└── 关机
</details>
<details>
<summary><b>├── 服务</b></summary>
　├── PassWall<br/>
　├── PassWall2  (arm)<br/>
　├── Hello World<br/>
　├── AdGuard Home<br/>
　├── ShadowSocksR Plus+<br/>
　├── DDNSTO 远程控制<br/>
　├── 应用过滤<br/>
　├── 网站域名黑白名单配置<br/>
　├── 全能推送<br/>
　├── 上网时间控制<br/>
　├── OpenClash<br/>
　├── Lucky<br/>
　├── 动态 DNS<br/>
　├── SmartDNS<br/>
　├── MosDNS<br/>
　├── 网络唤醒<br/>
　├── Frps<br/>
　├── UPnP<br/>
　├── Frp 内网穿透<br/>
　├── KMS 服务器<br/>
　└── Nps 内网穿透
</details>
<details>
<summary><b>├── Docker  (arm)</b></summary>
　├── 概览<br/>
　├── 容器<br/>
　├── 镜像<br/>
　├── 网络<br/>
　├── 存储卷<br/>
　├── 事件<br/>
　└── 设置
</details>
<details>
<summary><b>├── 网络存储</b></summary>
　├── 文件浏览器<br/>
　├── NFS 管理<br/>
　├── Alist 文件列表<br/>
　├── USB 打印服务器<br/>
　├── 硬盘休眠<br/>
　├── 打印服务器<br/>
　├── 网络共享<br/>
　├── Aria2 配置<br/>
　└── FTP 服务器
</details>
<details>
<summary><b>├── VPN</b></summary>
　├── V2ray 服务器<br/>
　├── N2N VPN<br/>
　├── SoftEther VPN 服务器<br/>
　├── OpenVPN 服务器<br/>
　├── IPSec VPN 服务器<br/>
　├── PPTP VPN 服务器<br/>
　└── ZeroTier
</details>
<details>
<summary><b>├── 网络</b></summary>
　├── 接口<br/>
　├── DHCP/DNS<br/>
　├── 主机名<br/>
　├── IP/MAC 绑定<br/>
　├── 静态路由<br/>
　├── 防火墙<br/>
　├── 诊断<br/>
　├── IP限速<br/>
　├── Socat<br/>
　├── Turbo ACC 网络加速<br/>
　├── 多线多拨<br/>
　└── 负载均衡
</details>
<details>
<summary><b>├── 带宽监控</b></summary>
　├── 显示<br/>
　├── 配置<br/>
　├── 备份<br/>
　└── 实时流量监测
</details>
　└── <b>退出</b>
</details>

## 固件下载
**点击跳转到该设备固件下载页面**
- ♨️【x86】Docker版（Kernel=32M，rootfs=5120M）和普通（Kernel=32M，rootfs=968M）不通刷
- [**X86下载地址**](https://github.com/Jejz168/OpenWrt/releases)
- [**Arm下载地址**](https://github.com/Jejz168/OpenWrt/releases/tag/ARMv8)

## 鸣谢 [![](https://img.shields.io/badge/-跪谢各大佬-FFFFFF.svg)](#鸣谢-)
| [ImmortalWrt](https://github.com/immortalwrt) | [coolsnowwolf](https://github.com/coolsnowwolf) | [P3TERX](https://github.com/P3TERX) | [Flippy](https://github.com/unifreq) | [haiibo](https://github.com/haiibo) | [Lenyu2020](https://github.com/Lenyu2020) |
| :-------------: | :-------------: | :-------------: | :-------------: | :-------------: | :-------------: |
| <img width="100" src="https://avatars.githubusercontent.com/u/53193414"/> | <img width="100" src="https://avatars.githubusercontent.com/u/31687149"/> | <img width="100" src="https://avatars.githubusercontent.com/u/25927179"/> | <img width="100" src="https://avatars.githubusercontent.com/u/39355261"/> | <img width="100" src="https://avatars.githubusercontent.com/u/85640068"/> | <img width="100" src="https://avatars.githubusercontent.com/u/59961153"/> |
| [Ophub](https://github.com/ophub) | [Jerrykuku](https://github.com/jerrykuku) | [QiuSimons](https://github.com/QiuSimons) | [IvanSolis1989](https://github.com/IvanSolis1989) | [DHDAXCW](https://github.com/DHDAXCW) | [breakings](https://github.com/breakings) |
| <img width="100" src="https://avatars.githubusercontent.com/u/68696949"/> | <img width="100" src="https://avatars.githubusercontent.com/u/9485680"/> | <img width="100" src="https://avatars.githubusercontent.com/u/45143996"/> | <img width="100" src="https://avatars.githubusercontent.com/u/44228691"/> | <img width="100" src="https://avatars.githubusercontent.com/u/74764072"/> | <img width="100" src="https://avatars.githubusercontent.com/u/25475074"/> |


# 访问量

![](http://profile-counter.glitch.me/Jejz168-OpenWrt/count.svg)
# ==============================
# 🏖Special thanks（特别感谢）
- [GitHub Actions](https://github.com/features/actions)🎉🎉Thank you very much.🎉🎉



<a href="#readme">
<img src="https://img.shields.io/badge/-返回顶部-FFFFFF.svg" title="返回顶部" align="right"/>
</a>
