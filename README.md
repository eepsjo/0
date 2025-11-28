# 🛡️ 規則記錄表

本記錄旨在收集被**誤殺**或**配置錯誤**規則。

---

## 📝 錯誤記錄列表

| 類型 | 内容 | 行爲 | 集 | 收錄原因 | 處理狀態 | 備註 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `DOMAIN-SUFFIX` | `dataflow.biliapi.com` | `REJECT` | `R` | bilibili 的 PCDN，但同時也是手機客戶端用來“緩存視頻”的域名。 | ❌ | 有時 bilibili 也會使用其他域名來“緩存視頻”。 |
| `DOMAIN-SUFFIX` | `activity.windows.com` | `REJECT` | `r` | 微软域名，与数据收集跟踪有关。拦截后影响部分微软服务运行，已有 Microsoft Edge、Microsoft Authenticator 同步功能无法工作的报告。 | ❌ | 配置其子域名 edge.activity.windows.com 和 edge-enterprise.activity.windows.com 可避免上述服務不運行。 |