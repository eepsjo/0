# 🛡️ 規則記錄表

本記錄旨在收集被**誤殺**或**配置錯誤**規則。

---

## 📝 錯誤記錄列表

| 類型 | 内容 | 行爲 | 集 | 收錄原因 | 狀態 | 備註 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `DOMAIN-SUFFIX` | `dataflow.biliapi.com` | `REJECT` | `R` | bilibili 的一个 PCDN 域名。同時是手機客戶端用來“緩存視頻”的域名 | ❌不处理 | 有時 bilibili 手機客戶端會使用其他域名來“緩存視頻” |
| `DOMAIN-SUFFIX` | `activity.windows.com` | `REJECT` | `r` | 微软域名，与数据收集跟踪有关。拦截后影响部分微软服务运行，已有 Microsoft Edge、Microsoft Authenticator 同步功能无法工作的报告 | ❌不处理 | 配置其子域名 edge.activity.windows.com 和 edge-enterprise.activity.windows.com 可避免上述服務不運行 |
| `DOMAIN-SUFFIX` | `mmstat.com` | `REJECT` | `r` | 阿里系域名，有明显的收集统计资料行为。~~拦截后可能出现：淘宝等 App 验证码无法显示；某些阿里系 App 登录异常~~ | ❌不处理 | 测试未出现前述情况 |