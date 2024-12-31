#!/bin/sh

# 定义变量
PORT=
SECRET=
APP_COMMAND="/usr/local/bin/aria2c --enable-rpc --rpc-secret $SECRET --rpc-listen-port=$PORT --rpc-allow-origin-all &> aria2c.log"

# 检测 IPv4 和 IPv6 是否有端口被占用
echo "检查 IPv4 和 IPv6 上的端口 $PORT 是否被占用..."

# 检查 IPv4 端口占用
IPv4_PID=$(sockstat -4 -l | grep ":$PORT" | awk '{print $3}')
# 检查 IPv6 端口占用
IPv6_PID=$(sockstat -6 -l | grep ":$PORT" | awk '{print $3}')

# 处理 IPv4 端口占用
if [ -n "$IPv4_PID" ]; then
    echo "检测到 IPv4 端口 $PORT 被进程 ID $IPv4_PID 占用，正在尝试终止..."
    kill -9 $IPv4_PID
    if [ $? -eq 0 ]; then
        echo "成功终止 IPv4 端口占用进程 $IPv4_PID。"
    else
        echo "无法终止 IPv4 端口占用进程 $IPv4_PID，请检查权限。"
        exit 1
    fi
fi

# 处理 IPv6 端口占用
if [ -n "$IPv6_PID" ]; then
    echo "检测到 IPv6 端口 $PORT 被进程 ID $IPv6_PID 占用，正在尝试终止..."
    kill -9 $IPv6_PID
    if [ $? -eq 0 ]; then
        echo "成功终止 IPv6 端口占用进程 $IPv6_PID。"
    else
        echo "无法终止 IPv6 端口占用进程 $IPv6_PID，请检查权限。"
        exit 1
    fi
fi

# 启动应用
echo "正在启动 aria2c 服务..."
eval $APP_COMMAND
if [ $? -eq 0 ]; then
    echo "应用已成功启动，并将日志输出到 aria2c.log。"
else
    echo "应用启动失败，请检查配置。"
    exit 1
fi

exit 0
