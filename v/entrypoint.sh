#!/bin/bash

# default
SCRIPT_UPDATE_URL="${SCRIPT_UPDATE_URL:-https://raw.githubusercontent.com/eepsjo/0/main/v/entrypoint.sh}"
LISTEN_PORT="${LISTEN_PORT:-2799}"

# self
if [ -n "$SCRIPT_UPDATE_URL" ]; then
    echo "--------------------------------------------------"
    echo "检查脚本更新..."
    TEMP_SCRIPT="/tmp/entrypoint_new.sh"
    if curl -sL "$SCRIPT_UPDATE_URL" -o "$TEMP_SCRIPT"; then
        if ! cmp -s "$TEMP_SCRIPT" "/app/entrypoint.sh"; then
            echo "发现脚本新版本，正在更新并重新执行..."
            mv "$TEMP_SCRIPT" "/app/entrypoint.sh"
            chmod +x /app/entrypoint.sh
            exec "/app/entrypoint.sh" "$@"
        else
            echo "脚本已是最新版本"
        fi
    else
        echo "无法从 $SCRIPT_UPDATE_URL 下载脚本更新"
    fi
    rm -f "$TEMP_SCRIPT"
    echo "--------------------------------------------------"
fi

# check
echo "服务启动中..."
command -v /app/sing-box >/dev/null 2>&1 || { echo "错误：未找到 sing-box"; exit 1; }
command -v /app/cloudflared >/dev/null 2>&1 || { echo "错误：未找到 cloudflared"; exit 1; }

# UUID
EFFECTIVE_UUID=""
if [ -n "$uuid" ]; then
    EFFECTIVE_UUID="$uuid"
    echo "使用提供的 UUID: $EFFECTIVE_UUID"
else
    EFFECTIVE_UUID=$(/app/sing-box generate uuid)
    echo "未提供 UUID，自动生成: $EFFECTIVE_UUID"
fi

# sing-box
cat > 0.json <<EOF
{
  "log": { "disabled": false, "level": "info", "timestamp": true },
  "inbounds": [
    { "type": "vless", "tag": "proxy", "listen": "::", "listen_port": ${LISTEN_PORT},
      "users": [ { "uuid": "${EFFECTIVE_UUID}", "flow": "" } ],
      "transport": { "type": "ws", "path": "/${EFFECTIVE_UUID}", "max_early_data": 2048, "early_data_header_name": "Sec-WebSocket-Protocol" }
    }
  ],
  "outbounds": [ { "type": "direct", "tag": "direct" } ]
}
EOF
echo "sing-box 配置已部署，监听端口: ${LISTEN_PORT}"
nohup /app/sing-box run -c 0.json > /dev/null 2>&1 &
SINGBOX_PID=$!
sleep 2
ps | grep "sing-box" | grep -v 'grep'
echo "sing-box 已启动"
echo "--------------------------------------------------"

# Cloudflare Tunnel
TUNNEL_MODE=""
FINAL_DOMAIN=""
TUNNEL_CONNECTED=false
if [ -n "$token" ] && [ -n "$domain" ]; then
    TUNNEL_MODE="固定隧道"
    FINAL_DOMAIN="$domain"
    echo "检测到 token 和 domain 已配置，使用【固定隧道】模式"
    echo "隧道域名: $FINAL_DOMAIN"
    nohup /app/cloudflared tunnel --no-autoupdate run --token "${token}" > ./log.log 2>&1 &
    CLOUDFLARED_PID=$!
    echo "等待隧道连接..."
    for attempt in $(seq 1 15); do
        sleep 2
        echo -n "."
        if grep -q -E "Registered tunnel connection|Connected to .*, an Argo Tunnel an edge" ./log.log; then
            TUNNEL_CONNECTED=true
            break
        fi
    done
    echo ""
else
    TUNNEL_MODE="临时隧道"
    echo "检测到 token 或 domain 未配置，使用【临时隧道】模式"
    nohup /app/cloudflared tunnel --url http://localhost:${LISTEN_PORT} --edge-ip-version auto --no-autoupdate --protocol http2 > ./log.log 2>&1 &
    CLOUDFLARED_PID=$!
    echo "等待临时隧道分配..."
    for attempt in $(seq 1 15); do
        sleep 2
        echo -n "."
        TEMP_TUNNEL_URL=$(grep -o 'https://[a-zA-Z0-9-]*\.trycloudflare.com' ./log.log | head -n 1)
        if [ -n "$TEMP_TUNNEL_URL" ]; then
            FINAL_DOMAIN=$(echo "$TEMP_TUNNEL_URL" | awk -F'//' '{print $2}')
            TUNNEL_CONNECTED=true
            break
        fi
    done
    echo ""
fi
echo "--------------------------------------------------"

# output
if [ "$TUNNEL_CONNECTED" = "true" ]; then
    echo "$TUNNEL_MODE 已成功连接！"
    echo "公共访问域名: $FINAL_DOMAIN"
    echo "--------------------------------------------------"
    LINKS_FILE="links.txt"
    name="vless"
    path_encoded="%2F${EFFECTIVE_UUID}%3Fed%3D2048"
    echo "vless://${EFFECTIVE_UUID}@www.visa.com.tw:443?encryption=none&security=tls&sni=${FINAL_DOMAIN}&host=${FINAL_DOMAIN}&fp=chrome&type=ws&path=${path_encoded}#${name}_visa_tw_443" > "$LINKS_FILE"
    echo "vless://${EFFECTIVE_UUID}@www.visa.com.hk:2053?encryption=none&security=tls&sni=${FINAL_DOMAIN}&host=${FINAL_DOMAIN}&fp=chrome&type=ws&path=${path_encoded}#${name}_visa_hk_2053" >> "$LINKS_FILE"
    echo "vless://${EFFECTIVE_UUID}@www.visa.com.br:8443?encryption=none&security=tls&sni=${FINAL_DOMAIN}&host=${FINAL_DOMAIN}&fp=chrome&type=ws&path=${path_encoded}#${name}_visa_br_8443" >> "$LINKS_FILE"
    echo "vless://${EFFECTIVE_UUID}@www.visaeurope.ch:443?encryption=none&security=tls&sni=${FINAL_DOMAIN}&host=${FINAL_DOMAIN}&fp=chrome&type=ws&path=${path_encoded}#${name}_visa_ch_443" >> "$LINKS_FILE"
    echo "vless://${EFFECTIVE_UUID}@usa.visa.com:2053?encryption=none&security=tls&sni=${FINAL_DOMAIN}&host=${FINAL_DOMAIN}&fp=chrome&type=ws&path=${path_encoded}#${name}_visa_us_2053" >> "$LINKS_FILE"
    echo "vless://${EFFECTIVE_UUID}@icook.hk:8443?encryption=none&security=tls&sni=${FINAL_DOMAIN}&host=${FINAL_DOMAIN}&fp=chrome&type=ws&path=${path_encoded}#${name}_icook_hk_8443" >> "$LINKS_FILE"
    echo "vless://${EFFECTIVE_UUID}@icook.tw:443?encryption=none&security=tls&sni=${FINAL_DOMAIN}&host=${FINAL_DOMAIN}&fp=chrome&type=ws&path=${path_encoded}#${name}_icook_tw_443" >> "$LINKS_FILE"
    cat "$LINKS_FILE"
    echo "--------------------------------------------------"
    tail -f ./log.log &
    TAIL_PID=$!
else
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "Cloudflare $TUNNEL_MODE 连接失败"
    echo "请检查日志，并确认配置正确"
    if [ "$TUNNEL_MODE" = "固定隧道" ]; then
        echo "确保 token 和 domain 配置正确，并在 Cloudflare Dashboard 正确配置"
    fi
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    cat ./log.log
    exit 1
fi

# update
update_binaries() {
    echo "--------------------------------------------------"
    echo "开始检查二进制文件更新..."
    CURRENT_SB_VERSION=$("/app/sing-box" version | head -n 1 | awk '{print $2}')
    if [ -z "$CURRENT_SB_VERSION" ]; then
        echo "无法获取当前 sing-box 版本"
        CURRENT_SB_VERSION="0.0.0"
    fi
    echo "当前 sing-box 版本: $CURRENT_SB_VERSION"
    LATEST_SB_RELEASE=$(curl -sL "https://api.github.com/repos/SagerNet/sing-box/releases/latest")
    LATEST_SB_VERSION=$(echo "$LATEST_SB_RELEASE" | grep -oP '"tag_name": "v\K[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
    LATEST_SB_DOWNLOAD_URL=$(echo "$LATEST_SB_RELEASE" | grep -oP '"browser_download_url": "\K[^"]*sing-box-[0-9]+\.[0-9]+\.[0-9]+-linux-amd64\.tar\.gz' | head -n 1)
    if [ -z "$LATEST_SB_VERSION" ] || [ -z "$LATEST_SB_DOWNLOAD_URL" ]; then
        echo "无法获取最新 sing-box 版本或下载链接"
    else
        echo "最新 sing-box 版本: $LATEST_SB_VERSION"
        if [[ "$(printf '%s\n' "$CURRENT_SB_VERSION" "$LATEST_SB_VERSION" | sort -V | head -n 1)" != "$LATEST_SB_VERSION" ]]; then
            echo "发现 sing-box 新版本，正在更新..."
            kill "$SINGBOX_PID"
            curl -sL "$LATEST_SB_DOWNLOAD_URL" | tar -xz -C /app --strip-components=1 sing-box-"$LATEST_SB_VERSION"-linux-amd64/sing-box
            chmod +x /app/sing-box
            nohup /app/sing-box run -c 0.json > /dev/null 2>&1 &
            SINGBOX_PID=$!
            echo "sing-box 更新并重启成功"
        else
            echo "sing-box 已是最新版本"
        fi
    fi
    echo "--------------------------------------------------"
    CURRENT_CF_VERSION=$("/app/cloudflared" --version | grep -oP 'cloudflared version \K[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
    if [ -z "$CURRENT_CF_VERSION" ]; then
        echo "无法获取当前 cloudflared 版本"
        CURRENT_CF_VERSION="0.0.0"
    fi
    echo "当前 cloudflared 版本: $CURRENT_CF_VERSION"
    LATEST_CF_RELEASE=$(curl -sL "https://api.github.com/repos/cloudflare/cloudflared/releases/latest")
    LATEST_CF_VERSION=$(echo "$LATEST_CF_RELEASE" | grep -oP '"tag_name": "v\K[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
    LATEST_CF_DOWNLOAD_URL=$(echo "$LATEST_CF_RELEASE" | grep -oP '"browser_download_url": "\K[^"]*cloudflared-linux-amd64' | head -n 1)
    if [ -z "$LATEST_CF_VERSION" ] || [ -z "$LATEST_CF_DOWNLOAD_URL" ]; then
        echo "无法获取最新 cloudflared 版本或下载链接"
    else
        echo "最新 cloudflared 版本: $LATEST_CF_VERSION"
        if [[ "$(printf '%s\n' "$CURRENT_CF_VERSION" "$LATEST_CF_VERSION" | sort -V | head -n 1)" != "$LATEST_CF_VERSION" ]]; then
            echo "发现 cloudflared 新版本，正在更新..."
            kill "$CLOUDFLARED_PID"
            curl -sL "$LATEST_CF_DOWNLOAD_URL" -o /app/cloudflared_new && \
            mv /app/cloudflared_new /app/cloudflared
            chmod +x /app/cloudflared
            if [ -n "$token" ] && [ -n "$domain" ]; then
                nohup /app/cloudflared tunnel --no-autoupdate run --token "${token}" > ./log.log 2>&1 &
            else
                nohup /app/cloudflared tunnel --url http://localhost:${LISTEN_PORT} --edge-ip-version auto --no-autoupdate --protocol http2 > ./log.log 2>&1 &
            fi
            CLOUDFLARED_PID=$!
            echo "cloudflared 更新并重启成功"
        else
            echo "cloudflared 已是最新版本"
        fi
    fi
    echo "--------------------------------------------------"
    echo "更新检查完成"
}

# update_saver
(
    while true; do
        sleep 86400
        update_binaries
    done
) &

# saver
wait "$TAIL_PID" 
