# 79

# 1 - HTTP/3
AND,((PROTOCOL,UDP),(DST-PORT,443))
AND,((NETWORK,UDP),(DST-PORT,443))

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

# 45
DOMAIN-SUFFIX,mihomo.party
PROCESS-NAME,et
PROCESS-NAME,wps
PROCESS-NAME,wpp
PROCESS-NAME,wpsoffice
PROCESS-NAME,wpscloudsvr
PROCESS-NAME,promecefpluginhost
DOMAIN-SUFFIX,gmw.cn
DOMAIN-SUFFIX,cri.cn
DOMAIN-SUFFIX,huanqiu.com
DOMAIN-SUFFIX,xinhuanet.com
DOMAIN-SUFFIX,chinanews.com
DOMAIN-SUFFIX,people.com.cn
DOMAIN-SUFFIX,chinadaily.com.cn
DOMAIN-KEYWORD,leftist
DOMAIN-KEYWORD,leftism
DOMAIN-KEYWORD,marxist
DOMAIN-KEYWORD,marxism
DOMAIN-KEYWORD,communist
DOMAIN-KEYWORD,communism
DOMAIN-KEYWORD,socialist
DOMAIN-KEYWORD,socialism
DOMAIN-KEYWORD,maoist
DOMAIN-KEYWORD,maoism
DOMAIN-KEYWORD,trotskyist
DOMAIN-KEYWORD,trotskyism
DOMAIN-KEYWORD,leninist
DOMAIN-KEYWORD,leninism
DOMAIN-KEYWORD,stalinist
DOMAIN-KEYWORD,stalinism
DOMAIN-KEYWORD,bolshevik
DOMAIN-KEYWORD,bolshevism
DOMAIN-KEYWORD,leftwing
DOMAIN-KEYWORD,left-wing
DOMAIN-SUFFIX,wsws.org
DOMAIN-SUFFIX,zyom.site
DOMAIN-SUFFIX,cpusa.org
DOMAIN-SUFFIX,libcom.org
DOMAIN-SUFFIX,revleft.com
DOMAIN-SUFFIX,solidnet.org
DOMAIN-SUFFIX,marxists.org
DOMAIN-SUFFIX,leftvoice.org
DOMAIN-SUFFIX,peoplesworld.org
DOMAIN-SUFFIX,socialistworld.net
DOMAIN-SUFFIX,internationalviewpoint.org

# 3 - Deepseek
DOMAIN-SUFFIX,gator.volces.com
DOMAIN-SUFFIX,apmplus.volces.com
DOMAIN-SUFFIX,guh50jw4-ios.mobile-messenger.intercom.com

# 5 - Toolz
DOMAIN-SUFFIX,metrics.icloud.com
DOMAIN-SUFFIX,browser.sentry-cdn.com
DOMAIN-SUFFIX,app.getsentry.com
DOMAIN-SUFFIX,appmetrica.yandex.ru
DOMAIN-SUFFIX,adfstat.yandex.ru
