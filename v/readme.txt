entrypoint.sh 是我的 Docker 镜像 simple_vless 的核心脚本。

该镜像用于快速部署一个基于 sing-box 的 vless + ws 代理服务，并通过 Cloudflare Tunnel 将其安全地暴露到公网。镜像有两种运行方式：固定隧道模式和临时隧道模式。前者需要在 Cloudflare Zero Trust Dashboard 中预先创建一个 Tunnel、获取该隧道的 Token、为该 Tunnel 配置一个 Public Hostname、将其服务指向 http://localhost:[port]⁠（这是容器内 sing-box 监听的端口）、确保相关的 DNS CNAME 记录已正确配置并生效、准备一个你想要固定使用的 UUID。 后者提供的临时隧道不保证长期稳定，重启后地址会改变。

脚本通过读取环境变量来获取配置信息。这意味着用户可以在运行容器时，通过设置这些环境变量来定制服务，而无需修改镜像本身

uuid
作用： 设置 Vless 协议的用户 UUID。这是客户端连接代理时需要使用的唯一标识
类型： 字符串
（没有设置变量的情况下，脚本会自动调用 sing-box generate uuid 来生成一个随机的 UUID）

LISTEN_PORT
作用： 设置 sing-box 在容器内部监听的端口。cloudflared 也会将流量转发到这个端口
类型： 整数
默认值： 2799（可以替换为希望的任何端口，但请确保该端口在 VPS 和Cloudflared 上开放且未被占用）

token
作用： 用于连接到 Cloudflare 固定隧道的认证令牌。当你在 Cloudflare Dashboard 创建一个持久的 Cloudflare Tunnel 时，会获得一个这样的 Token
类型： 字符串
（如果 token 未设置，脚本将启动一个临时隧道）

domain
作用： 与 Cloudflare 固定隧道关联的自定义域名。这个域名需要在你的 Cloudflare 账户中配置并指向你的隧道
类型： 字符串
（如果 domain 未设置，脚本也会进入临时隧道模式）

SCRIPT_UPDATE_URL
作用： 指定 entrypoint.sh 脚本自身进行更新的源 URL。脚本会定期从这个 URL 下载最新版本并进行比较
类型： 字符串
默认值： https://raw.githubusercontent.com/eepsjo/0/main/v/entrypoint.sh

Dockerfile 是创建这个镜像的指令。build 前请准备好 sing-box 和 cloudflared 的可执行文件

如果宿主机使用了 tun 代理，build 时 docker 无法使用代理，可以在终端先声明代理
export http_proxy="http://127.0.0.1:port"
export HTTP_PROXY="http://127.0.0.1:port"
export https_proxy="http://127.0.0.1:port"
export HTTPS_PROXY="http://127.0.0.1:port"
然后用参数 --network host 来调用宿主机网络环境
docker build -t simple_vless:latest --network host .
