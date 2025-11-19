# 130

# 0.5 - QUIC Shadowrocket
AND,((PROTOCOL,UDP),(DST-PORT,443))
# 0.5 - QUIC mihomo
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
DOMAIN,bsccdn.net
DOMAIN,dyp2p-ali.douyucdn.cn
DOMAIN,dyp2p-hw.douyucdn.cn
DOMAIN,ietheivaicai.com
DOMAIN,kuiniuca.com
DOMAIN,nexusedgeio.com
DOMAIN,onethingpcs.com
DOMAIN,p2p-ali.douyucdn.cn
DOMAIN,p2p.huya.com
DOMAIN,p2p.qq.com
DOMAIN,p2pchunk-hw.douyucdn.cn
DOMAIN,p2pchunk-table.douyucdn.cn
DOMAIN,p2pchunk-ws.douyucdn.cn
DOMAIN,p2perrorlog.douyucdn.cn
DOMAIN,p2plive-ali.douyucdn.cn
DOMAIN,p2plive-ws.douyucdn.cn
DOMAIN,p2plog.douyucdn.cn
DOMAIN,p2ptun.qq.com
DOMAIN,p2pupdate.gamedl.qq.com
DOMAIN,p2pupgrade.gamedl.qq.com
DOMAIN,p2pvod-ws.douyucdn.cn
DOMAIN,pcdn.yximgs.com
DOMAIN,pkoplink.com
DOMAIN,saxysec.com
DOMAIN,stun.douyucdn.cn
DOMAIN,stun.hitv.com
DOMAIN,stun1.douyucdn.cn
DOMAIN,szbdyd.com
DOMAIN,uhabo.com
DOMAIN,xycdn.com

# 66 - Encrypted DNS servers @ privacy-protection-tools/anti-AD
DOMAIN,api.yuedu.dns.iqiyi.com
DOMAIN,apidns.kwd.inkuai.com
DOMAIN,bj.vip.waf.dns.iqiyi.com
DOMAIN,data.video.dns.iqiyi.com
DOMAIN,dns.alidns.com
DOMAIN,dns.iqiyi.com
DOMAIN,dns.jd.com
DOMAIN,dns.jd.com.gslb.qianxun.com
DOMAIN,dns.qiyipic.iqiyi.com
DOMAIN,dns.qq.com
DOMAIN,dns.weibo.cn
DOMAIN,dns.weixin.qq.com
DOMAIN,dns.weixin.qq.com.cn
DOMAIN,doh.dns.apple.com
DOMAIN,doh.iqiyi.com
DOMAIN,doh.ptqy.gitv.tv
DOMAIN,dotserver.douyucdn.cn
DOMAIN,hdns.ksyun.com
DOMAIN,httpdns-api.aliyuncs.com
DOMAIN,httpdns-browser.platform.dbankcloud.cn
DOMAIN,httpdns-platform-dbankcloud-com-drcn.wec.dbankedge.cn
DOMAIN,httpdns-sc.aliyuncs.com
DOMAIN,httpdns-sdk.n.netease.com
DOMAIN,httpdns.alicdn.com
DOMAIN,httpdns.baidu.com
DOMAIN,httpdns.baidubce.com
DOMAIN,httpdns.bcelive.com
DOMAIN,httpdns.bilivideo.com
DOMAIN,httpdns.browser.miui.com
DOMAIN,httpdns.c.cdnhwc2.com
DOMAIN,httpdns.calorietech.com
DOMAIN,httpdns.cctv.com
DOMAIN,httpdns.danuoyi.tbcache.com
DOMAIN,httpdns.gslb.yy.com
DOMAIN,httpdns.huaweicloud.com
DOMAIN,httpdns.kg.qq.com
DOMAIN,httpdns.kwd.inkuai.com
DOMAIN,httpdns.meituan.com
DOMAIN,httpdns.music.163.com
DOMAIN,httpdns.music.ntes53.netease.com
DOMAIN,httpdns.n.netease.com
DOMAIN,httpdns.n.shifen.com
DOMAIN,httpdns.ocloud.heytapmobi.com
DOMAIN,httpdns.ocloud.oppomobile.com
DOMAIN,httpdns.platform.dbankcloud.cn
DOMAIN,httpdns.platform.dbankcloud.com
DOMAIN,httpdns.pro
DOMAIN,httpdns.push.heytapmobi.com
DOMAIN,httpdns.push.oppomobile.com
DOMAIN,httpdns.tantanapp.com
DOMAIN,httpdns.volcengineapi.com
DOMAIN,httpdns.yunxindns.com
DOMAIN,httpdns.zhihu.com
DOMAIN,httpdns.zybang.com
DOMAIN,httpdns1.cc.cdnhwc5.com
DOMAIN,httpsdns.baidu.com
DOMAIN,iface2.dns.iqiyi.com
DOMAIN,ipv6-static.dns.iqiyi.com
DOMAIN,lofter.httpdns.c.163.com
DOMAIN,music.httpdns.c.163.com
DOMAIN,ocloud-httpdns-cn.heytapmobi.com
DOMAIN,passport.dns.iqiyi.com
DOMAIN,resolver.mi.xiaomi.com
DOMAIN,resolver.msg.xiaomi.net
DOMAIN,static.dns.qiyipic.iqiyi.com
DOMAIN,v6-data.video.dns.iqiyi.com
