#!/bin/bash

[ -d files/usr/bin/AdGuardHome ] || mkdir -p files/usr/bin/AdGuardHome

AGH_CORE=$(curl -sL https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | grep "browser_download_url.*AdGuardHome_linux_${1}" | awk -F '"' '{print $4}')

if [ -z "$AGH_CORE" ]; then
  echo "❌ 未找到适用于 ${1} 的 AdGuardHome 下载链接！"
  exit 1
fi

echo "✅ 下载地址: $AGH_CORE"

wget -qO- $AGH_CORE | tar xOvz > files/usr/bin/AdGuardHome/AdGuardHome

chmod +x files/usr/bin/AdGuardHome/AdGuardHome
