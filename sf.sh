#!/bin/bash
# OpenWrt Rockchip/ARMv8 Python 环境一键修复脚本
# 作者：ChatGPT
# 功能：升级 Python，安装 pip、wheel、setuptools，并安装常用 Python 库

set -e

echo "1️⃣ 更新软件源..."
opkg update

echo "2️⃣ 安装系统 Python（升级到官方最新 Python 3）..."
opkg install python3 python3-light python3-base python3-setuptools libcares || true

echo "3️⃣ 安装 pip（如果系统无 pip）..."
if ! command -v pip >/dev/null 2>&1; then
    wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
    python3 /tmp/get-pip.py
fi

echo "4️⃣ 升级 pip、setuptools、wheel..."
pip install --upgrade pip setuptools wheel --root-user-action=ignore

echo "5️⃣ 安装常用库（自动处理依赖）..."
pip install --upgrade --root-user-action=ignore \
    ulid-transform pycares aioesphomeapi requests

echo "6️⃣ 验证安装..."
python3 - <<'EOF'
import sys, uuid, requests
try:
    import pycares
    import ulid_transform
    import aioesphomeapi
    print("✅ Python Version:", sys.version)
    print("✅ uuid OK:", uuid.uuid4())
    print("✅ requests Version:", requests.__version__)
    print("✅ pycares Version:", pycares.__version__)
    print("✅ ulid-transform Version:", ulid_transform.__version__)
    print("✅ aioesphomeapi Version:", aioesphomeapi.__version__)
except Exception as e:
    print("❌ 检测到错误:", e)
EOF

echo "🎉 Python 环境修复完成！"
