entrypoint.sh 是我的 Docker 镜像 eepsjo/simple-vless 的核心脚本

  脚本通过读取环境变量来获取配置信息。这意味着用户可以在运行容器时，通过设置这些环境变量来定制服务，而无需修改镜像本身。以下是脚本用到的环境变量：
    uuid
      作用： 设置 Vless 协议的用户 UUID。这是客户端连接代理时需要使用的唯一标识
      类型： 字符串
      （没有设置变量的情况下，脚本会自动调用 sing-box generate uuid 来生成一个随机的 UUID）
    location
      作用： 代理节点名称前缀，可以填写你的 vps 落地 IP 或自定信息，方便订阅客户端管理
      类型： 字符串
      默认值： 0
    token
      作用： 用于连接到 Cloudflare 固定隧道的认证令牌。当你在 Cloudflare Dashboard 创建一个持久的 Cloudflare Tunnel 时，会获得一个这样的 Token
      类型： 字符串
      （如果 token 未设置，脚本将启动一个临时隧道）
    domain
      作用： 与 Cloudflare 固定隧道关联的自定义域名。这个域名需要在你的 Cloudflare 账户中配置并指向你的隧道
      类型： 字符串
      （如果 domain 未设置，脚本也会进入临时隧道模式）

Dockerfile 是创建这个镜像的指令。build 前请准备好 sing-box 和 cloudflared 的可执行文件

  如果宿主机使用了 tun 代理，build 时 docker 无法使用代理，可以在终端先声明代理
    export http_proxy="http://127.0.0.1:port"
    export HTTP_PROXY="http://127.0.0.1:port"
    export https_proxy="http://127.0.0.1:port"
    export HTTPS_PROXY="http://127.0.0.1:port"
  然后用参数 --network host 来调用宿主机网络环境
    docker build -t simple_vless:tag --network host .
