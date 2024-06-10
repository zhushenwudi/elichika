#!/bin/bash

# 设置环境变量
export GO_VERSION=1.20.6
export GIT_SSL_NO_VERIFY=true
export GOPROXY=https://goproxy.cn

# 更新并安装依赖
apt-get update && apt-get install -y --no-install-recommends \
    g++ \
    gcc \
    libc6-dev \
    make \
    pkg-config \
    git \
    wget \
    ca-certificates

# 清理安装包
rm -rf /var/lib/apt/lists/*

# 下载并安装Go
wget --no-check-certificate -O go$GO_VERSION.linux-amd64.tar.gz "https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz"
tar -xzf "go$GO_VERSION.linux-amd64.tar.gz" -C /usr/local
export PATH="/usr/local/go/bin:${PATH}"

# 运行Go程序
go run main.go
