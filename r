# 64

# 0.5 - QUIC mihomo
AND,((NETWORK,UDP),(DST-PORT,443))
# 0.5 - QUIC Shadowrocket
AND,((PROTOCOL,UDP),(DST-PORT,443))

# 25 - STUN
DOMAIN-WILDCARD,stun.*
DOMAIN-WILDCARD,stun*.l.google.com
DOMAIN,relay.webwormhole.io
DOMAIN,iphone-stun.strato-iphone.de
DOMAIN,hw-v2-web-player-tracker.biliapi.net
DOMAIN-SUFFIX,freestun.net
DOMAIN-SUFFIX,stun.twilio.com
DOMAIN-SUFFIX,mcdn.bilivideo.cn
DOMAIN-SUFFIX,stunserver.stunprotocol.org
IP-CIDR,2001:4060:1:1005::10:32/128,no-resolve
IP-CIDR,2001:41d0:2:12b9::1/128,no-resolve
IP-CIDR,2001:678:b28::118/128,no-resolve
IP-CIDR,2404:6800:4003:c03::7f/128,no-resolve
IP-CIDR,2404:6800:4008:c04::7f/128,no-resolve
IP-CIDR,2404:6800:400a:1002::7f/128,no-resolve
IP-CIDR,2404:6800:400b:c005::7f/128,no-resolve
IP-CIDR,2a00:1450:4010:c06::7f/128,no-resolve
IP-CIDR,2a01:4f8:120:1497::148/128,no-resolve
IP-CIDR,2a01:4f8:13b:39ce::2/128,no-resolve
IP-CIDR,2a01:4f8:242:56ca::2/128,no-resolve
IP-CIDR,2a01:4f8:c17:8f74::1/128,no-resolve
IP-CIDR,2a01:4f9:4b:4c8f::2/128,no-resolve
IP-CIDR,2a02:f98:0:50:2ff:23ff:fe42:1b23/128,no-resolve
IP-CIDR,2a03:2880:f084:1:face:b00c:0:24d9/128,no-resolve
IP-CIDR,2a03:b0c0:0:1010::a2:a001/128,no-resolve

# 0

# 3 - Deepseek
DOMAIN-SUFFIX,gator.volces.com
DOMAIN-SUFFIX,apmplus.volces.com
DOMAIN-SUFFIX,guh50jw4-ios.mobile-messenger.intercom.com

# 5 - ToolzAD
DOMAIN-SUFFIX,metrics.icloud.com
DOMAIN-SUFFIX,browser.sentry-cdn.com
DOMAIN-SUFFIX,app.getsentry.com
DOMAIN-SUFFIX,appmetrica.yandex.ru
DOMAIN-SUFFIX,adfstat.yandex.ru

# 30 - PCDN @ privacy-protection-tools/anti-AD
DOMAIN-SUFFIX,bsccdn.net
DOMAIN-SUFFIX,dyp2p-ali.douyucdn.cn
DOMAIN-SUFFIX,dyp2p-hw.douyucdn.cn
DOMAIN-SUFFIX,ietheivaicai.com
DOMAIN-SUFFIX,kuiniuca.com
DOMAIN-SUFFIX,nexusedgeio.com
DOMAIN-SUFFIX,onethingpcs.com
DOMAIN-SUFFIX,p2p-ali.douyucdn.cn
DOMAIN-SUFFIX,p2p.huya.com
DOMAIN-SUFFIX,p2p.qq.com
DOMAIN-SUFFIX,p2pchunk-hw.douyucdn.cn
DOMAIN-SUFFIX,p2pchunk-table.douyucdn.cn
DOMAIN-SUFFIX,p2pchunk-ws.douyucdn.cn
DOMAIN-SUFFIX,p2perrorlog.douyucdn.cn
DOMAIN-SUFFIX,p2plive-ali.douyucdn.cn
DOMAIN-SUFFIX,p2plive-ws.douyucdn.cn
DOMAIN-SUFFIX,p2plog.douyucdn.cn
DOMAIN-SUFFIX,p2ptun.qq.com
DOMAIN-SUFFIX,p2pupdate.gamedl.qq.com
DOMAIN-SUFFIX,p2pupgrade.gamedl.qq.com
DOMAIN-SUFFIX,p2pvod-ws.douyucdn.cn
DOMAIN-SUFFIX,pcdn.yximgs.com
DOMAIN-SUFFIX,pkoplink.com
DOMAIN-SUFFIX,saxysec.com
DOMAIN-SUFFIX,stun.douyucdn.cn
DOMAIN-SUFFIX,stun.hitv.com
DOMAIN-SUFFIX,stun1.douyucdn.cn
DOMAIN-SUFFIX,szbdyd.com
DOMAIN-SUFFIX,uhabo.com
DOMAIN-SUFFIX,xycdn.com
