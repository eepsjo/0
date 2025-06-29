shadowrocket(txt,RULE-SET) & clash(yaml,Classical)

reject(r)/direct(d)/proxy(p)

rules & config

someth
6/40



Windows
隐藏“此电脑”中盘符
<_Win+R-regedit>

计算机\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer
DWORD

赋值：十进制，04。意为：隐藏D:\、F:\和G:\

二进制数字相加

A,B,C,D,E,F,G....盘符对应1,2,4,8,16,32,64,...，即二进制位的低位到高位

禁用任务管理器
<_Win+R-regedit>

计算机\HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies
DisableTaskMgr=1
Windows 11 “小组件”卸载/重装


winget uninstall MicrosoftWindows.Client.WebExperience_cw5n1h2txyewy
winget install 9MSSGKG348SP
已安装应用
<_Win+R-shell:AppsFolder>

Windows 10 任务栏透明
<_Win+R-regedit>

计算机\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced
DWORD

TaskbarAcrylicOpacity=0
没有的手动添加一个。建议使用深色任务栏

删除“文件资源管理器”的 3D Object 文件夹
<_Win+R-regedit>

计算机\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
删除文件夹

{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}
重启“文件资源管理器”生效

解决盗版 Adobe Premiere Pro 2019 启动时 Crash 


替换 

*\Adobe\Adobe Premiere Pro CC 2019\ZXPSignLib-minimal.dll
文件在 https://www.ijinshan.com/filerepair/ZXPSignLib-minimal.dll.shtml 下载

Windows 任务栏搜索去除推广内容（广告）
<_Win+R-regedit>

计算机\HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\explorer
DWORD

DisableSearchBoxSuggestions=1
重启“文件资源管理器”生效

电池使用报告


powercfg /batteryreport /output "<文件路径>\<文件名称>.html"
高级电源选项 USB 选择性暂停
<_Win+R-regedit>

计算机\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\48e6b7a6-50f5-4782-a5d4-53bb8f07e226
DWORD

Attributes=2
Windows 离开模式
<_Win+R-regedit>

计算机\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power
DWORD

AwayModeEnabled=0




Linux
Date Menu Formatter


MM / dd  EEE  HH : mm




OTH
Minecraft


-XX:+UseG1GC -XX:-UseAdaptiveSizePolicy -XX:-OmitStackTraceInFastThrow -Dfml.ignoreInvalidMinecraftCertificates=True -Dfml.ignorePatchDiscrepancies=True -Dlog4j2.formatMsgNoLookups=true








已输入1830字
更多设置
