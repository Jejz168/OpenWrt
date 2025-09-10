#!/bin/bash

[ -d files/etc/openclash/core ] || mkdir -p files/etc/openclash/core

if [ "$1" = "amd64" ]; then
  CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-$1-v1.tar.gz"
else
  CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-$1.tar.gz"
fi
GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
ASN_MMDB_URL="https://github.com/Jejz168/GeoLite.mmdb/raw/download/GeoLite2-ASN.mmdb"
Model_bin_URL="https://github.com/vernesong/mihomo/releases/download/LightGBM-Model/Model.bin"

wget -qO- $CLASH_META_URL | tar xOvz > files/etc/openclash/core/clash_meta
wget -qO- $GEOIP_URL > files/etc/openclash/GeoIP.dat
wget -qO- $GEOSITE_URL > files/etc/openclash/GeoSite.dat
wget -qO- $ASN_MMDB_URL > files/etc/openclash/ASN.mmdb
wget -qO- $Model_bin_URL > files/etc/openclash/Model.bin

chmod +x files/etc/openclash/core/clash*
