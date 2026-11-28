## 🛡️ False-Positive Rules

> See the [Usage Example](#-usage-example) for the actual contents of "SET"s

| | SET | Reason | Status | Notes |
| :--- | :--- | :--- | :--- | :--- |
| `+.dataflow.biliapi.com` | `R` | A PCDN domain of bilibili. Blocking it breaks the "Cache Video" feature in the mobile client. | ❌ Not handled | The mobile client will use other domains after some tries. |

## 🔞 Usage Example

```yaml
# mihomo v1.19.34+
.:
  upts: &upts {interval: 28800}
  update: &update {proxy: GLOBAL, <<: [*upts]}

proxy-groups:
  - {name: GLOBAL, proxies: [PROXY], type: select, hidden: true}
  - {name: PROXY, proxies: [NAH], <<: [*fallback], hidden: true}
  #
  - {name: DLsite, proxies: [NAH], <<: [*fallback], hidden: true}
  - {name: 18comic, proxies: [NAH], <<: [*fallback], hidden: true}
  - {name: Gemini, proxies: [NAH], <<: [*fallback], hidden: true}

proxies:
  - {name: TS, type: tailscale, auth-key: xxxxNAHHHHHHHHHHHHHH}
  - {name: PbQ, type: rematch, target-sub-rule: "PROXYblockQUIC"}

rules:
  - IP-CIDR,100.64.0.0/10,TS,no-resolve
  - OR,((RULE-SET,R),(RULE-SET,r)),REJECT
  - RULE-SET,d,DIRECT
  - RULE-SET,p,PbQ
  - RULE-SET,D,DIRECT
  - RULE-SET,I,DIRECT,no-resolve
  - MATCH,PbQ

sub-rules:
  PROXYblockQUIC:
    - AND,((NETWORK,UDP),(DST-PORT,443)),REJECT
    - RULE-SET,jp,DLsite
    - RULE-SET,no_jp,18comic
    - RULE-SET,ai,Gemini
    - MATCH,PROXY

rule-providers:
  R: {type: http, behavior: domain, format: yaml, url: "https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/refs/heads/master/anti-ad-clash.yaml", path: ./rule/R.yaml, <<: [*update]}
  r: {type: http, behavior: classical, format: text, url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/release/r.txt", path: ./rule/imgay/r.txt, <<: [*update]}
  d: {type: http, behavior: classical, format: text, url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/release/d.txt", path: ./rule/imgay/d.txt, <<: [*update]}
  p: {type: http, behavior: classical, format: text, url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/release/p.txt", path: ./rule/imgay/p.txt, <<: [*update]}
  D: {type: http, behavior: domain, format: yaml, url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/refs/heads/release/direct.txt", path: ./rule/imlesbian/D.yaml, <<: [*update]}
  I: {type: http, behavior: ipcidr, format: yaml, url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/refs/heads/release/cncidr.txt", path: ./rule/imlesbian/I.yaml, <<: [*update]}
  #
  jp: {type: http, behavior: classical, format: text, url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/release/jp.txt", path: ./rule/imgay/jp.txt, <<: [*update]}
  no_jp: {type: http, behavior: classical, format: text, url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/release/no_jp.txt", path: ./rule/imgay/no_jp.txt, <<: [*update]}
  ai: {type: http, behavior: classical, format: text, url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/release/ai.txt", path: ./rule/imgay/ai.txt, <<: [*update]}