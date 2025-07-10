FROM ubuntu:22.04

WORKDIR /app

RUN apt update && \
    apt install -y \
    coreutils \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /app/entrypoint.sh
COPY sing-box /app/sing-box
COPY cloudflared /app/cloudflared

RUN chmod +x /app/entrypoint.sh /app/sing-box /app/cloudflared

EXPOSE 2777

CMD ["/app/entrypoint.sh"]
