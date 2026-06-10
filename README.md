> 此等規則僅獻給配得上的人。

## 📝 使用例

### mihomo

```yaml
.:
  update: &update {interval: 28800, proxy: PROXY}

rule-providers:
  R: {type: http, behavior: domain, format: yaml, url: "https://anti-ad.net/clash.yaml", path: ./rule/R.yaml, <<: [*update]}
  r: {type: http, behavior: classical, format: text, url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/r", path: ./rule/r.txt, <<: [*update]}
  # 兜底代理
  d: {type: http, behavior: classical, format: text, url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/d", path: ./rule/d.txt, <<: [*update]}
  p: {type: http, behavior: classical, format: text, url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/p", path: ./rule/p.txt, <<: [*update]}
  D: {type: http, behavior: domain, format: yaml, url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/refs/heads/release/direct.txt", path: ./rule/p/D.yaml, <<: [*update]}
  I: {type: http, behavior: ipcidr, format: yaml, url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/refs/heads/release/cncidr.txt", path: ./rule/p/I.yaml, <<: [*update]}
  # 兜底直連
  # p: {type: http, behavior: classical, format: text, url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/p", path: ./rule/p.txt, <<: [*update]}
  # d: {type: http, behavior: classical, format: text, url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/d", path: ./rule/d.txt, <<: [*update]}
  # T: {type: http, behavior: domain, format: yaml, url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/refs/heads/release/tld-not-cn.txt", path: ./rule/d/T.yaml, <<: [*update]}
  # G: {type: http, behavior: domain, format: yaml, url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/refs/heads/release/gfw.txt", path: ./rule/d/G.yaml, <<: [*update]}

rules:
  - RULE-SET,R,REJECT
  - RULE-SET,r,REJECT
  # 兜底代理
  - RULE-SET,d,DIRECT
  - SUB-RULE,(RULE-SET,p),PROXYblockQUIC
  - RULE-SET,D,DIRECT
  - RULE-SET,I,DIRECT,no-resolve
  - AND,((NETWORK,UDP),(DST-PORT,443)),REJECT
  - MATCH,PROXY
  # 兜底直連
  # - SUB-RULE,(RULE-SET,p),PROXYblockQUIC
  # - RULE-SET,d,DIRECT
  # - SUB-RULE,(RULE-SET,T),PROXYblockQUIC
  # - SUB-RULE,(RULE-SET,G),PROXYblockQUIC
  # - MATCH,DIRECT

sub-rules:
  PROXYblockQUIC: ['AND,((NETWORK,UDP),(DST-PORT,443)),REJECT', 'MATCH,PROXY']
```

## 🛡️ “誤殺”的規則

| | 集 | 收錄原因 | 狀態 | 備註 |
| :--- | :--- | :--- | :--- | :--- |
| `+.dataflow.biliapi.com` | `R` | bilibili 的一个 PCDN 域名。攔截后手機客戶端“緩存視頻”功能失效 | ❌不處理 | 手機客戶端會使用其他域名來“緩存視頻” |