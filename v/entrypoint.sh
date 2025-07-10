#!/bin/bash

location="${location:-0}"

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
  "log": { "disabled": false, "level": "warn", "timestamp": true },
  "inbounds": [
    { "type": "vless", "tag": "proxy", "listen": "::", "listen_port": 2777,
      "users": [ { "uuid": "${EFFECTIVE_UUID}", "flow": "" } ],
      "transport": { "type": "ws", "path": "/${EFFECTIVE_UUID}", "max_early_data": 2048, "early_data_header_name": "Sec-WebSocket-Protocol" }
    }
  ],
  "outbounds": [ { "type": "direct", "tag": "direct" } ]
}
EOF
echo "sing-box 配置已部署，监听端口: 2777"
nohup /app/sing-box run -c 0.json > /dev/null 2>&1 &
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
    echo "等待隧道连接..."
    for attempt in $(seq 1 15); do
        sleep 2
        if grep -q -E "Registered tunnel connection|Connected to .*, an Argo Tunnel an edge" ./log.log; then
            TUNNEL_CONNECTED=true
            break
        fi
        echo -n "."
    done
    echo ""
else
    TUNNEL_MODE="临时隧道"
    echo "检测到 token 或 domain 未配置，使用【临时隧道】模式"
    nohup /app/cloudflared tunnel --url http://localhost:2777 --edge-ip-version auto --no-autoupdate --protocol http2 > ./log.log 2>&1 &
    echo "等待临时隧道分配..."
    for attempt in $(seq 1 15); do
        sleep 2
        TEMP_TUNNEL_URL=$(grep -o 'https://[a-zA-Z0-9-]*\.trycloudflare.com' ./log.log | head -n 1)
        if [ -n "$TEMP_TUNNEL_URL" ]; then
            FINAL_DOMAIN=$(echo $TEMP_TUNNEL_URL | awk -F'//' '{print $2}')
            TUNNEL_CONNECTED=true
            break
        fi
        echo -n "."
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
    name="simple-vless_${location}"
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
    tail -f ./log.log
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
