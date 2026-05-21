FROM alpine:latest

# 必须加上此标签，使生成的打包镜像与你的 GitHub 仓库自动绑定关联
LABEL org.opencontainers.image.source=https://github.com/zzzhhh1/my-SnapDeploy

# 安装网络工具与多进程守护组件
RUN apk add --no-cache curl unzip bash supervisor

# 下载并解压 2026 最新官方内核 sing-box
RUN curl -L -s https://github.com/SagerNet/sing-box/releases/download/v1.11.0/sing-box-1.11.0-linux-amd64.tar.gz | tar -xz && \
    mv sing-box-*-linux-amd64/sing-box /usr/local/bin/ && \
    rm -rf sing-box-*-linux-amd64

# 下载并解压官方 Cloudflare 隧道客户端
RUN curl -L -s https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

WORKDIR /app
COPY config.json /app/config.json
COPY supervisord.conf /etc/supervisord.conf

# 显式暴露 8080，完美骗过 Koyeb / SnapDeploy 面板的健康检查
EXPOSE 8080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
