#!/bin/bash

[ -d files/usr/bin/AdGuardHome ] || mkdir -p files/usr/bin/AdGuardHome

AGH_CORE=$(curl -sL https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | grep "browser_download_url.*AdGuardHome_linux_${1}" | awk -F '"' '{print $4}')

if [ -z "$AGH_CORE" ]; then
  echo "⚠️ 未找到适用于 ${1} 的 AdGuardHome 下载链接！"
  LATEST_TAG=$(curl -sL https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | grep '"tag_name"' | awk -F '"' '{print $4}')
  if [ -z "$LATEST_TAG" ]; then
    LATEST_TAG="v0.107.70"
    echo "⚠️ 无法获取最新版本号，使用备用版本: ${LATEST_TAG}"
  else
    echo "📌 最新版本号: ${LATEST_TAG}"
  fi
  AGH_CORE="https://github.com/AdguardTeam/AdGuardHome/releases/download/${LATEST_TAG}/AdGuardHome_linux_${1}.tar.gz"
  echo "✅ 已启用备用下载地址"
fi

echo "📥 下载地址: $AGH_CORE"

wget -qO- $AGH_CORE | tar xOvz > files/usr/bin/AdGuardHome/AdGuardHome

chmod +x files/usr/bin/AdGuardHome/AdGuardHome