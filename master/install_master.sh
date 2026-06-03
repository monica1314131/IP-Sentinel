#!/bin/bash
# ==========================================================
# 脚本名称: install_master.sh (v4.3.0 Bootstrapper)
# 核心功能: Master 中枢极简引导入口。创建沙盒、拉取模块并启动编排器
# ==========================================================

if [ "$EUID" -ne 0 ]; then
  echo -e "\033[31m❌ 权限被拒绝: 部署 IP-Sentinel 需要最高系统权限。\033[0m"
  echo -e "💡 请切换到 root 用户 (执行 su root 或 sudo -i) 后重新运行指令。"
  exit 1
fi

SECURE_TMP=$(mktemp -d /tmp/ips_master_install.XXXXXX)
trap 'rm -rf "$SECURE_TMP"' EXIT HUP INT QUIT TERM

REPO_RAW_URL="https://raw.githubusercontent.com/hotyue/IP-Sentinel/feature/v4.3.0-modular"

echo -e "\n⏳ 正在拉取 IP-Sentinel Master v4.3.0 安装引擎..."

curl -fsSL --connect-timeout 10 --retry 3 "${REPO_RAW_URL}/install/build_master.sh" -o "${SECURE_TMP}/build_master.sh"

if [ ! -s "${SECURE_TMP}/build_master.sh" ]; then
    echo -e "\033[31m❌ 致命错误：中枢安装引擎拉取失败！\033[0m"
    exit 1
fi

export SECURE_TMP
export REPO_RAW_URL

chmod +x "${SECURE_TMP}/build_master.sh"
source "${SECURE_TMP}/build_master.sh"

exit 0
