### Windows 設定

#### 磁碟機與檔案總管

  * **隱藏「本機」中的磁碟機代號**

      * **步驟：**

          * 開啟登錄編輯程式 (`Win+R` 輸入 `regedit`)。

          * 導航至：`電腦\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer`。

          * 建立或修改一個 **DWORD (32 位元) 值**，將其**賦值為十進位 `04`**，這表示隱藏 `D:\`、`F:\` 和 `G:\` 磁碟機。

      * **說明：**

          * 每個磁碟機代號對應一個二進位位元：A: `1 (2^0)`、B: `2 (2^1)`、C: `4 (2^2)`，以此類推。

          * 若要隱藏多個磁碟機，請將其對應的二進位數字相加。例如：隱藏 D:(`8`) + F:(`32`) + G:(`64`) = `104`。

  * **移除「檔案總管」中的 3D 物件資料夾**

      * **步驟：**

          * 開啟登錄編輯程式 (`Win+R` 輸入 `regedit`)。

          * 導航至：`電腦\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace`。

          * **刪除**資料夾：`{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}`。

          * 重新啟動檔案總管後生效。

  * **快速開啟已安裝應用程式資料夾**

      * **步驟：**

          * 開啟執行視窗 (`Win+R`)。

          * 輸入 `shell:AppsFolder`。

#### 電源管理與效能

  * **進階電源選項中的 USB 選擇性暫停**

      * **步驟：**

          * 開啟登錄編輯程式 (`Win+R` 輸入 `regedit`)。

          * 導航至：`電腦\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\48e6b7a6-50f5-4782-a5d4-53bb8f07e226`。

          * 建立或修改一個 **DWORD (32 位元) 值**，將 `Attributes` 設定為 `2`。

  * **Windows 離開模式**

      * **步驟：**

          * 開啟登錄編輯程式 (`Win+R` 輸入 `regedit`)。

          * 導航至：`電腦\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power`。

          * 建立或修改一個 **DWORD (32 位元) 值**，將 `AwayModeEnabled` 設定為 `0`。

  * **生成電池使用報告**

      * **步驟：**

          * 開啟命令提示字元或 PowerShell。

          * 執行以下命令：

        <!-- end list -->

        ```
        powercfg /batteryreport /output "<檔案路徑>\<檔案名稱>.html"

        ```

#### 介面與功能

  * **Windows 10 工作列透明化**

      * **步驟：**

          * 開啟登錄編輯程式 (`Win+R` 輸入 `regedit`)。

          * 導航至：`電腦\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced`。

          * 建立或修改一個 **DWORD (32 位元) 值**，將 `TaskbarAcrylicOpacity` 設定為 `0`。

          * **注意：** 如果沒有此項，請手動新增。建議搭配深色工作列使用。

  * **停用工作管理員**

      * **步驟：**

          * 開啟登錄編輯程式 (`Win+R` 輸入 `regedit`)。

          * 導航至：`電腦\HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies`。

          * 建立或修改一個 **DWORD (32 位元) 值**，將 `DisableTaskMgr` 設定為 `1`。

  * **移除 Windows 工作列搜尋中的推廣內容 (廣告)**

      * **步驟：**

          * 開啟登錄編輯程式 (`Win+R` 輸入 `regedit`)。

          * 導航至：`電腦\HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\explorer`。

          * 建立或修改一個 **DWORD (32 位元) 值**，將 `DisableSearchBoxSuggestions` 設定為 `1`。

          * 重新啟動檔案總管後生效。

  * **Windows 11 「小工具」解除安裝/重新安裝**

      * **解除安裝：**

        ```
        winget uninstall MicrosoftWindows.Client.WebExperience_cw5n1h2txyewy

        ```

      * **重新安裝：**

        ```
        winget install 9MSSGKG348SP

        ```

#### 軟體問題

  * **解決盜版 Adobe Premiere Pro 2019 啟動時崩潰問題**

      * **步驟：**

          * 將檔案替換至 `*\Adobe\Adobe Premiere Pro CC 2019\` 目錄。

          * 檔案：`ZXPSignLib-minimal.dll`

          * 下載連結：[https://www.ijinshan.com/filerepair/ZXPSignLib-minimal.dll.shtml](https://www.ijinshan.com/filerepair/ZXPSignLib-minimal.dll.shtml)

### Linux 設定

#### 語言與區域設定

  * **`~/.pam_environment`**

      * **語言 (最低優先順序)：**
        `LANG=zh_TW.UTF-8`

      * **應用程式語言 (優先順序由左至右)：**
        `LANGUAGE=zh_TW:zh_CN:en_US`

      * **區域格式：簡中 (覆蓋 LANG)：**
        `LC_TIME=zh_CN.UTF-8`
        `LC_NUMERIC=zh_CN.UTF-8`
        `LC_MONETARY=zh_CN.UTF-8`
        `LC_PAPER=zh_CN.UTF-8`
        `LC_MEASUREMENT=zh_CN.UTF-8`

      * **其他設定：繁中：**
        `LC_COLLATE=zh_TW.UTF-8`
        `LC_NAME=zh_TW.UTF-8`
        `LC_ADDRESS=zh_TW.UTF-8`
        `LC_TELEPHONE=zh_TW.UTF-8`
        `LC_IDENTIFICATION=zh_TW.UTF-8`
        `LC_MESSAGES=zh_TW.UTF-8`

  * **`/etc/default/locale`**

      * `LC_CTYPE=en_US.UTF-8`

#### 日期格式

  * **日期選單格式化：**
    `MM / dd EEE HH : mm`

### Minecraft

  * **Java 虛擬機 (JVM) 參數：**

      * `-XX:+UseG1GC`

      * `-XX:-UseAdaptiveSizePolicy`

      * `-XX:-OmitStackTraceInFastThrow`

      * `-Dfml.ignoreInvalidMinecraftCertificates=True`

      * `-Dfml.ignorePatchDiscrepancies=True`

      * `-Dlog4j2.formatMsgNoLookups=true`
