# Taipei_251223-162256_118

# 0

# 0.5 - QUIC Shadowrocket
AND,((PROTOCOL,UDP),(DST-PORT,443))
# 0.5 - QUIC mihomo
AND,((NETWORK,UDP),(DST-PORT,443))

# 3 - anti-AD
DOMAIN-SUFFIX,shouji.sogou.com
DOMAIN-SUFFIX,activity.windows.com
DOMAIN-SUFFIX,mmstat.com

# 5 - ToolzAD
DOMAIN-SUFFIX,metrics.icloud.com
DOMAIN-SUFFIX,browser.sentry-cdn.com
DOMAIN-SUFFIX,app.getsentry.com
DOMAIN-SUFFIX,appmetrica.yandex.ru
DOMAIN-SUFFIX,adfstat.yandex.ru

# 7 - STUN @ HERE
DOMAIN-WILDCARD,stun.*
DOMAIN-WILDCARD,stun*.l.google.com
DOMAIN,hw-v2-web-player-tracker.biliapi.net
DOMAIN-SUFFIX,freestun.net
DOMAIN-SUFFIX,stun.twilio.com
DOMAIN-SUFFIX,mcdn.bilivideo.cn
DOMAIN-SUFFIX,stunserver.stunprotocol.org

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

# 72 - DNS in GFW @ privacy-protection-tools/anti-AD
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
DOMAIN,httpdns.aliyuncs.com
DOMAIN,httpdns.baidu.com
DOMAIN,httpdns.baidubce.com
DOMAIN,httpdns.bcelive.com
DOMAIN,httpdns.bilivideo.com
DOMAIN,httpdns.browser.miui.com
DOMAIN,httpdns.c.163.com
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
DOMAIN,httpdns.yunxinfw.com
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
DOMAIN,resolver.gslb.mi-idc.com
DOMAIN,resolver.mi.xiaomi.com
DOMAIN,resolver.msg.global.xiaomi.net
DOMAIN,resolver.msg.xiaomi.net
DOMAIN,static.dns.qiyipic.iqiyi.com
DOMAIN,v6-data.video.dns.iqiyi.com
DOMAIN,union-httpdns.gslb.yy.com
