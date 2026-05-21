#!/bin/sh

# 1. 检查 Koyeb 环境变量中是否配置了 UUID
if [ -n "$UUID" ]; then
    echo "[INFO] 检测到环境变量 UUID，正在执行安全注入..."
    # 使用 sed 强行把 config.json 里的占位符替换为真实的 UUID
    sed -i "s/UUID_PLACEHOLDER/$UUID/g" /etc/sing-box/config.json
    echo "[INFO] UUID 安全注入完成！"
else
    echo "[WARN] 未检测到环境变量 UUID，将使用默认占位符（可能导致节点无法连接）"
fi

# 2. 检查并动态对齐隧道端口（Koyeb 平台灵活性保障）
if [ -n "$PORT" ]; then
    echo "[INFO] 正在对齐内部监听端口为: $PORT"
    sed -i "s/8080/$PORT/g" /etc/sing-box/config.json
fi

# 3. 顺畅唤醒你的双进程保活管理器（supervisord 或直接运行进程）
echo "[INFO] 正在拉起 cloudflared 隧道与 sing-box 服务..."
exec supervisord -c /etc/supervisor/conf.d/supervisord.conf
