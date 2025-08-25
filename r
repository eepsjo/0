# 40

# 1 - QUIC443 (shadowrocket/mihomo)
AND,((PROTOCOL,UDP),(DST-PORT,443))
AND,((NETWORK,UDP),(DST-PORT,443))

# 26 - STUN
DOMAIN-WILDCARD,stun.*
DOMAIN-WILDCARD,stun.*.*
DOMAIN-WILDCARD,stun.*.*.*
DOMAIN,iphone-stun.strato-iphone.de
DOMAIN,relay.webwormhole.io
DOMAIN,hw-v2-web-player-tracker.biliapi.net
DOMAIN-SUFFIX,mcdn.bilivideo.cn
DOMAIN-SUFFIX,stunserver.stunprotocol.org
DOMAIN-SUFFIX,freestun.net
DOMAIN-WILDCARD,stun*.l.google.com
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

# 5 - WPS
PROCESS-NAME,wps
PROCESS-NAME,wpp
PROCESS-NAME,et
PROCESS-NAME,wpsoffice
PROCESS-NAME,wpsocloudsvr

# 3 - Deepseek Anti-track
DOMAIN-SUFFIX,apmplus.volces.com
DOMAIN-SUFFIX,gator.volces.com
DOMAIN-SUFFIX,guh50jw4-ios.mobile-messenger.intercom.com

# 5 - Toolz
DOMAIN-SUFFIX,browser.sentry-cdn.com
DOMAIN-SUFFIX,app.getsentry.com
DOMAIN-SUFFIX,appmetrica.yandex.ru
DOMAIN-SUFFIX,adfstat.yandex.ru
DOMAIN-SUFFIX,metrics.icloud.com
