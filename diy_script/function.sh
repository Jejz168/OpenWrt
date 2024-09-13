#!/bin/bash

# 拉取仓库文件夹
merge_package() {
	# 参数1是分支名,参数2是库地址,参数3是所有文件下载到指定路径。
	# 同一个仓库下载多个文件夹直接在后面跟文件名或路径，空格分开。
	# 示例:
	# merge_package master https://github.com/WYC-2020/openwrt-packages package/openwrt-packages luci-app-eqos luci-app-openclash luci-app-ddnsto ddnsto 
	# merge_package master https://github.com/lisaac/luci-app-dockerman package/lean applications/luci-app-dockerman
	if [[ $# -lt 3 ]]; then
		echo "Syntax error: [$#] [$*]" >&2
		return 1
	fi
	trap 'rm -rf "$tmpdir"' EXIT
	branch="$1" curl="$2" target_dir="$3" && shift 3
	rootdir="$PWD"
	localdir="$target_dir"
	[ -d "$localdir" ] || mkdir -p "$localdir"
	tmpdir="$(mktemp -d)" || exit 1
        echo "开始下载：$(echo $curl | awk -F '/' '{print $(NF)}')"
	git clone -b "$branch" --depth 1 --filter=blob:none --sparse "$curl" "$tmpdir"
	cd "$tmpdir"
	git sparse-checkout init --cone
	git sparse-checkout set "$@"
	# 使用循环逐个移动文件夹
	for folder in "$@"; do
		mv -f "$folder" "$rootdir/$localdir"
	done
	cd "$rootdir"
}

drop_package(){
	find package/ -follow -name $1 -not -path "package/custom/*" | xargs -rt rm -rf
}

merge_feed(){
	./scripts/feeds update $1
	./scripts/feeds install -a -p $1
}

# 版本比较 sh
check_ver() {
	local version1="$1"
	local version2="$2"
	# 分割版本号字符串并设置默认值
	local i v1 v1_1 v1_2 v1_3 v2 v2_1 v2_2 v2_3
	IFS='.'; set -- $version1; v1_1=${1:-0}; v1_2=${2:-0}; v1_3=${3:-0}
	IFS='.'; set -- $version2; v2_1=${1:-0}; v2_2=${2:-0}; v2_3=${3:-0}
	IFS=
	# 逐个比较版本号段
	for i in 1 2 3; do
		eval v1=\$v1_$i
		eval v2=\$v2_$i
		if [ "$v1" -gt "$v2" ]; then
			# echo "版本 $version1 大于版本 $version2"
			echo 0
			return
		elif [ "$v1" -lt "$v2" ]; then
			# echo "版本 $version1 小于版本 $version2"
			echo 1
			return
		fi
	done
	# echo "版本 $version1 等于版本 $version2"
	echo 255
}

# 版本比较 bash
check_ver2() {
	local version1="$1"
	local version2="$2"
	local v1={}
	local v2={}
	# 将版本号字符串分割成数组
	IFS='.' read -ra v1 <<< "$version1"
	IFS='.' read -ra v2 <<< "$version2"
	# 逐个比较数组中的元素
	for i in "${!v1[@]}"; do
		if [ "${v1[i]}" -gt "${v2[i]}" ]; then
			# echo "版本 $version1 大于版本 $version2"
			echo 0
			return
		elif [ "${v1[i]}" -lt "${v2[i]}" ]; then
			# echo "版本 $version1 小于版本 $version2"
			echo 1
			return
		fi
	done
	# echo "版本 $version1 等于版本 $version2"
	echo 255
}
