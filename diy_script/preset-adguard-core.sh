#!/bin/bash

[ -d files/usr/bin/AdGuardHome ] || mkdir -p files/usr/bin/AdGuardHome

AGH_CORE=$(curl -sL https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | grep "browser_download_url" | grep "AdGuardHome_linux_${1}.tar.gz" | cut -d '"' -f 4 | head -n1)

wget -O /tmp/AdGuardHome.tar.gz "$AGH_CORE"

tar -xzvf /tmp/AdGuardHome.tar.gz -C files/usr/bin/AdGuardHome --strip-components=1

chmod +x files/usr/bin/AdGuardHome/AdGuardHome
