## 🛡️ "False-Positive" Rules

> See the [Usage Example](#-usage-example) for the actual contents of "Set".

| | Set | Reason for inclusion | Status | Notes |
| :--- | :--- | :--- | :--- | :--- |
| `+.dataflow.biliapi.com` | `R` | A PCDN domain for bilibili. Blocking it breaks the "cache video" feature in the mobile client. | ❌ Not handled | The mobile client will use other domains to "cache video" after some tries. |

## 📝 Usage Example

```yaml
# mihomo v1.19.28+
.:
  update: &update {interval: 28799, proxy: PROXY}

rule-providers:
  R: {type: http, behavior: domain, format: yaml, url: "https://anti-ad.net/clash.yaml", path: ./rule/R.yaml, <<: [*update]}
  r: {type: http, behavior: classical, format: text, url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/r", path: ./rule/r.txt, <<: [*update]}
  # === START ===
  # FINAL PROXY
  d: {type: http, behavior: classical, format: text, url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/d", path: ./rule/d.txt, <<: [*update]}
  p: {type: http, behavior: classical, format: text, url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/p", path: ./rule/p.txt, <<: [*update]}
  D: {type: http, behavior: domain, format: yaml, url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/refs/heads/release/direct.txt", path: ./rule/p/D.yaml, <<: [*update]}
  I: {type: http, behavior: ipcidr, format: yaml, url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/refs/heads/release/cncidr.txt", path: ./rule/p/I.yaml, <<: [*update]}
  # ===  END  ===
  #
  # === START ===
  # FINAL DIRECT
  # p: {type: http, behavior: classical, format: text, url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/p", path: ./rule/p.txt, <<: [*update]}
  # d: {type: http, behavior: classical, format: text, url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/d", path: ./rule/d.txt, <<: [*update]}
  # T: {type: http, behavior: domain, format: yaml, url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/refs/heads/release/tld-not-cn.txt", path: ./rule/d/T.yaml, <<: [*update]}
  # G: {type: http, behavior: domain, format: yaml, url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/refs/heads/release/gfw.txt", path: ./rule/d/G.yaml, <<: [*update]}
  # ===  END  ===

rules:
  - RULE-SET,R,REJECT
  - RULE-SET,r,REJECT
  # FINAL PROXY
  - RULE-SET,d,DIRECT
  - RULE-SET,p,PbQ
  - RULE-SET,D,DIRECT
  - RULE-SET,I,DIRECT,no-resolve
  - MATCH,PbQ
  # FINAL DIRECT
  # - RULE-SET,p,PbQ
  # - RULE-SET,d,DIRECT
  # - RULE-SET,T,PbQ
  # - RULE-SET,G,PbQ
  # - MATCH,DIRECT

sub-rules:
  PROXYblockQUIC: ['AND,((NETWORK,UDP),(DST-PORT,443)),REJECT', 'MATCH,PROXY']

proxies:
  - {name: PbQ, type: rematch, target-sub-rule: "PROXYblockQUIC"}