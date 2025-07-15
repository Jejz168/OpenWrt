#!/bin/bash

[ -d files/etc/nikki/run/ui ] || mkdir -p files/etc/nikki/run/ui

GEOIP_URL="https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.dat"
GEOSITE_URL="https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat"
GEOIP_METADB_URL="https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip-lite.metadb"
ASN_MMDB_URL="https://github.com/Jejz168/GeoLite.mmdb/raw/download/GeoLite2-ASN.mmdb"

wget -qO- $GEOIP_URL > files/etc/nikki/run/GeoIP.dat
wget -qO- $GEOSITE_URL > files/etc/nikki/run/GeoSite.dat
wget -qO- $GEOIP_METADB_URL > files/etc/nikki/run/geoip.metadb
wget -qO- $ASN_MMDB_URL > files/etc/nikki/run/ASN.mmdb

pushd files/etc/nikki/run/ui/
curl -sSL https://codeload.github.com/haishanh/yacd/zip/refs/heads/gh-pages -o yacd-dist-cdn-fonts.zip
curl -sSL https://github.com/MetaCubeX/metacubexd/releases/latest/download/compressed-dist.tgz -o compressed-dist.tgz
curl -sSL https://github.com/Zephyruso/zashboard/releases/latest/download/dist-cdn-fonts.zip -o dist-cdn-fonts.zip
mkdir -p metacubexd && tar zxf compressed-dist.tgz -C metacubexd
unzip -q dist-cdn-fonts.zip && unzip -q yacd-dist-cdn-fonts.zip
mv dist zashboard && mv yacd-gh-pages yacd
rm -rf yacd-dist-cdn-fonts.zip dist-cdn-fonts.zip compressed-dist.tgz
popd
