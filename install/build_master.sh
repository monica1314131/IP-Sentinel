#!/bin/bash
# ==========================================================
# 模块名称: build_master.sh (v4.3.0 Orchestrator)
# 核心功能: Master 安装业务总指挥
# ==========================================================

MODULES=(
    "env_setup.sh"
    "master_setup.sh"
)

echo "⏳ 正在装载中枢底层设施依赖..."

for mod in "${MODULES[@]}"; do
    curl -fsSL --connect-timeout 10 --retry 3 "${REPO_RAW_URL}/install/${mod}" -o "${SECURE_TMP}/${mod}"
    if [ ! -s "${SECURE_TMP}/${mod}" ]; then
        echo -e "\033[31m❌ 致命错误：中枢依赖模块 [${mod}] 装载失败！\033[0m"
        exit 1
    fi
    source "${SECURE_TMP}/${mod}"
done

echo -e "\033[32m✅ 中枢模块装载完毕，正在进入部署流程...\033[0m"

# --- 核心业务编排流 ---

# [复用模块: env_setup.sh]
do_master_env_precheck   # 预检
do_fetch_master_version  # 抓取版本
do_master_handle_menu    # OTA 拦截与菜单选择
do_install_deps          # 安装 sqlite3 等依赖

# 如果选择卸载，模块内部会 exit

# [专属模块: master_setup.sh]
do_master_clean_env      # 验证环境与保护 DB
do_master_config         # 交互获取 Token 并生成 conf
do_master_init_db        # 初始化 SQLite 表结构
do_master_deploy_core    # 覆写内核并注入守护进程
do_master_summary        # 打印状态汇报与回执
