# Windows 設定

此部分提供 Windows 系統的一些實用設定與問題解決方案。

## 隱藏「本機」中的磁碟機代號

隱藏「本機」中特定磁碟機代號的設定。

* 開啟登錄編輯程式：_Win+R_ 輸入 `regedit`
* 導航至：`電腦\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer`
* 建立或修改一個 **DWORD (32 位元) 值**
* 將其**賦值為十進位 `04`**。這表示隱藏 `D:\`、`F:\` 和 `G:\` 磁碟機。
    <details>
    <summary><b>磁碟機代號與二進位對應說明</b></summary>
    <p>每個磁碟機代號對應一個二進位位元：</p>
    <ul>
        <li>A: 1 (2^0)</li>
        <li>B: 2 (2^1)</li>
        <li>C: 4 (2^2)</li>
        <li>D: 8 (2^3)</li>
        <li>E: 16 (2^4)</li>
        <li>F: 32 (2^5)</li>
        <li>G: 64 (2^6)</li>
        <li>...以此類推。</li>
    </ul>
    <p>若要隱藏多個磁碟機，請將其對應的二進位數字相加。例如，隱藏 D:\ (8) + F:\ (32) + G:\ (64) = 104。</p>
    </details>

## 停用工作管理員

停用 Windows 工作管理員的設定。

* 開啟登錄編輯程式：_Win+R_ 輸入 `regedit`
* 導航至：`電腦\HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies`
* 建立或修改一個 **DWORD (32 位元) 值**
* 將 `DisableTaskMgr` 設定為 `1`

## Windows 11 「小工具」解除安裝/重新安裝

如何解除安裝或重新安裝 Windows 11 的「小工具」功能。

* 解除安裝：
    ```bash
    winget uninstall MicrosoftWindows.Client.WebExperience_cw5n1h2txyewy
    ```
* 重新安裝：
    ```bash
    winget install 9MSSGKG348SP
    ```

## 已安裝應用程式

快速開啟已安裝應用程式資料夾。

* 開啟執行視窗：_Win+R_
* 輸入：`shell:AppsFolder`

## Windows 10 工作列透明化

讓 Windows 10 工作列變得透明。

* 開啟登錄編輯程式：_Win+R_ 輸入 `regedit`
* 導航至：`電腦\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced`
* 建立或修改一個 **DWORD (32 位元) 值**
* 將 `TaskbarAcrylicOpacity` 設定為 `0`
    * _如果沒有此項，請手動新增。建議搭配深色工作列使用。_

## 移除「檔案總管」中的 3D 物件資料夾

從檔案總管側邊欄移除 3D 物件資料夾。

* 開啟登錄編輯程式：_Win+R_ 輸入 `regedit`
* 導航至：`電腦\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace`
* **刪除資料夾**：`{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}`
* 重新啟動「檔案總管」後生效。

## 解決盜版 Adobe Premiere Pro 2019 啟動時崩潰問題

針對盜版 Adobe Premiere Pro 2019 啟動時崩潰的解決方案。

* 替換檔案：`*\Adobe\Adobe Premiere Pro CC 2019\ZXPSignLib-minimal.dll`
* 檔案下載連結：[https://www.ijinshan.com/filerepair/ZXPSignLib-minimal.dll.shtml](https://www.ijinshan.com/filerepair/ZXPSignLib-minimal.dll.shtml)

## Windows 工作列搜尋移除推廣內容 (廣告)

移除 Windows 工作列搜尋中的推廣內容。

* 開啟登錄編輯程式：_Win+R_ 輸入 `regedit`
* 導航至：`電腦\HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\explorer`
* 建立或修改一個 **DWORD (32 位元) 值**
* 將 `DisableSearchBoxSuggestions` 設定為 `1`
* 重新啟動「檔案總管」後生效。

## 電池使用報告

生成詳細的電池使用報告。

* 開啟命令提示字元或 PowerShell
* 執行命令：
    ```bash
    powercfg /batteryreport /output "<檔案路徑>\<檔案名稱>.html"
    ```

## 進階電源選項 USB 選擇性暫停

啟用 USB 選擇性暫停功能的高級電源選項。

* 開啟登錄編輯程式：_Win+R_ 輸入 `regedit`
* 導航至：`電腦\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\48e6b7a6-50f5-4782-a5d4-53bb8f07e226`
* 建立或修改一個 **DWORD (32 位元) 值**
* 將 `Attributes` 設定為 `2`

## Windows 離開模式

啟用或停用 Windows 離開模式。

* 開啟登錄編輯程式：_Win+R_ 輸入 `regedit`
* 導航至：`電腦\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power`
* 建立或修改一個 **DWORD (32 位元) 值**
* 將 `AwayModeEnabled` 設定為 `0`

---

# Linux 設定

此部分說明如何在 Linux 系統中配置語言與區域格式，以及日期選單的格式化。

## 語言與區域設定

### `~/.pam_environment`

語言 (最低優先順序)
LANG=zh_TW.UTF-8

應用程式語言 (優先順序由左至右)
LANGUAGE=zh_TW:zh_CN:en_US

區域格式：簡中 (覆蓋 LANG)
LC_TIME=zh_CN.UTF-8
LC_NUMERIC=zh_CN.UTF-8
LC_MONETARY=zh_CN.UTF-8
LC_PAPER=zh_CN.UTF-8
LC_MEASUREMENT=zh_CN.UTF-8

其他設定：繁中
LC_COLLATE=zh_TW.UTF-8
LC_NAME=zh_TW.UTF-8
LC_ADDRESS=zh_TW.UTF-8
LC_TELEPHONE=zh_TW.UTF-8
LC_IDENTIFICATION=zh_TW.UTF-8
LC_MESSAGES=zh_TW.UTF-8


### `/etc/default/locale`

LC_CTYPE=en_US.UTF-8


## 日期選單格式化

MM / dd  EEE  HH : mm


---

# Minecraft

## Java 虛擬機 (JVM) 參數

以下是 Minecraft 啟動器中常用的 JVM 參數，用於最佳化遊戲效能。

-XX:+UseG1GC -XX:-UseAdaptiveSizePolicy -XX:-OmitStackTraceInFastThrow -Dfml.ignoreInvalidMinecraftCertificates=True -Dfml.ignorePatchDiscrepancies=True -Dlog4j2.formatMsgNoLookups=true
