#!/bin/bash
# OpenWrt Rockchip/ARMv8 Python 3.11 一键环境修复脚本
# 作者：ChatGPT

set -e

echo "1️⃣ 更新软件源..."
opkg update

echo "2️⃣ 安装或升级系统 Python..."
# 安装官方可用的最高版本 Python
opkg install python3 python3-light python3-base python3-setuptools libcares || true

# 检查 Python 版本
PYTHON_VER=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
echo "当前 Python 版本: $PYTHON_VER"
if [[ $(echo "$PYTHON_VER < 3.10" | bc) -eq 1 ]]; then
    echo "⚠️ 当前 Python 版本低于 3.10，需要使用 SDK 编译 Python 3.11 或更高版本"
    exit 1
fi

echo "3️⃣ 安装 pip（如果没有）..."
if ! command -v pip >/dev/null 2>&1; then
    wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
    python3 /tmp/get-pip.py
fi

echo "4️⃣ 升级 pip、setuptools、wheel..."
pip install --upgrade pip setuptools wheel --root-user-action=ignore

echo "5️⃣ 安装常用库（自动解决依赖）..."
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

echo "🎉 Python 环境升级与库安装完成！"
