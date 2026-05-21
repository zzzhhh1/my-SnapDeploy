FROM alpine:latest

# 安装必备基础组件
RUN apk add --no-cache curl unzip bash supervisor

# 安装 2026 最新版 sing-box
RUN curl -L -s https://github.com/SagerNet/sing-box/releases/download/v1.11.0/sing-box-1.11.0-linux-amd64.tar.gz | tar -xz && \
    mv sing-box-*-linux-amd64/sing-box /usr/local/bin/ && \
    rm -rf sing-box-*-linux-amd64

# 安装最新版 cloudflared 隧道程序
RUN curl -L -s https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

WORKDIR /app
COPY config.json /app/config.json
COPY supervisord.conf /etc/supervisord.conf

# 暴露出 SnapDeploy 要求的端口，用于维持容器存活
EXPOSE 8080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
