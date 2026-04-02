#!/bin/bash

# ==========================================================
# 脚本名称: uninstall.sh (IP-Sentinel 一键卸载脚本 V2.0)
# 核心功能: 清除所有世代的守护进程、清理系统定时任务、删除程序文件
# ==========================================================

INSTALL_DIR="/opt/ip_sentinel"

echo "========================================================"
echo "      🗑️ 准备卸载 IP-Sentinel (VPS IP 自动养护哨兵)"
echo "========================================================"

# 1. 停止运行中的守护进程与主控模块 (涵盖 V1.0 至 V2.0 架构全量进程)
echo "[1/3] 正在终止后台守护进程与所有养护任务..."

# 击杀旧版 (V1.x) 遗留进程
pgrep -f tg_daemon.sh | xargs -r kill -9 >/dev/null 2>&1

# 击杀新版 (V2.x) 神经末梢守护进程
pgrep -f agent_daemon.sh | xargs -r kill -9 >/dev/null 2>&1
pgrep -f webhook.py | xargs -r kill -9 >/dev/null 2>&1

# 击杀调度引擎与更新/战报模块
pgrep -f runner.sh | xargs -r kill -9 >/dev/null 2>&1
pgrep -f updater.sh | xargs -r kill -9 >/dev/null 2>&1
pgrep -f tg_report.sh | xargs -r kill -9 >/dev/null 2>&1

# 击杀所有具体的业务执行模块
pgrep -f mod_google.sh | xargs -r kill -9 >/dev/null 2>&1
pgrep -f mod_trust.sh | xargs -r kill -9 >/dev/null 2>&1

# 2. 清除系统定时任务 (Cron)
echo "[2/3] 正在清理系统定时任务 (Cron)..."
crontab -l 2>/dev/null | grep -v "ip_sentinel" > /tmp/cron_backup
crontab /tmp/cron_backup
rm -f /tmp/cron_backup

# 3. 删除所有文件与日志
echo "[3/3] 正在抹除核心程序、配置文件与系统日志..."
if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
fi

echo "========================================================"
echo "✅ 卸载彻底完成！IP-Sentinel 已从您的系统中无痕移除。"
echo "👋 感谢您的使用，期待未来再次为您守护 IP！"
echo "========================================================"