import requests
import yaml
import os
import re
import sys

# 如果设置为 True，任何外部规则下载失败都将导致脚本中止
STRICT_SOURCE_CHECK = True 
# 获取脚本所在的目录，作为所有相对路径的基准
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
# 根目录
REPO_ROOT = os.path.abspath(os.path.join(SCRIPT_DIR, '..'))

CONFIG = [
# target: 生成的目标文件 (位于根目录)
# base: 手动维护的基础文件 (位于 base/ 目录)
# sources: 外部规则
    {
        "target": "r",
        "base": os.path.join(REPO_ROOT, "base", "r"),
        "sources": [
            {
                "name": "PCDN @ privacy-protection-tools/anti-AD",
                "url": "https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/refs/heads/master/discretion/pcdn.txt",
                "type": "text",
            },
            {
                "name": "DNS in GFW @ privacy-protection-tools/anti-AD",
                "url": "https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/refs/heads/master/discretion/dns.txt",
                "type": "text",
            },
        ]
    },
    {
        "target": "d",
        "base": os.path.join(REPO_ROOT, "base", "d"),
        "sources": [
            {
                "name": "Private Domains @ Loyalsoldier/clash-rules",
                "url": "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/refs/heads/release/private.txt",
                "type": "yaml",
            },
            {
                "name": "Reserved IPs @ Loyalsoldier/clash-rules",
                "url": "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/refs/heads/release/lancidr.txt",
                "type": "yaml",
            },
        ]
    },
    {
        "target": "p",
        "base": os.path.join(REPO_ROOT, "base", "p"),
        "sources": [
            # {
            #     "name": "Telegram IPs @ Loyalsoldier/clash-rules",
            #     "url": "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/refs/heads/release/telegramcidr.txt",
            #     "type": "yaml",
            # },
            # {
            #     "name": "GFW List @ Loyalsoldier/clash-rules",
            #     "url": "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/refs/heads/release/gfw.txt",
            #     "type": "yaml",
            # },
        ]
    }
]

def get_content(url):
    # 如果开启严格模式，下载失败则抛出异常
    try:
        resp = requests.get(url, timeout=10)
        resp.raise_for_status() # 检查 HTTP 状态码
        return resp.text
    except Exception as e:
        error_message = f"Error downloading {url}: {e}"
        print(f"!!! {error_message} !!!")
        
        if STRICT_SOURCE_CHECK:
            # 在严格模式下，下载失败直接触发 CI/CD 失败
            print("Strict check failed. Aborting workflow.")
            sys.exit(1)
        else:
            # 非严格模式下，继续运行，返回 None
            return None

def determine_text_prefix(line: str) -> str:
    # 根据裸规则内容自动判断最合适的前缀类型
    line = line.strip()
    
    if not line: return ""

    # 1. IP-CIDR 判定（包含 '/'）
    if '/' in line:
        return "IP-CIDR"
    
    # 2. DOMAIN-WILDCARD 判定（包含 '*'）
    elif '*' in line:
        return "DOMAIN-WILDCARD"

    # 3. DOMAIN-SUFFIX 判定（以 '.' 开头）
    elif line.startswith('.'):
        return "DOMAIN-SUFFIX"
    
    # 4. 其余均为 DOMAIN
    else:
        return "DOMAIN"

def parse_yaml_payload(content):
    # 解析 YAML payload 并转换为裸规则
    rules = []
    try:
        data = yaml.safe_load(content)
        if 'payload' in data:
            for item in data['payload']:
                if not isinstance(item, str): continue
                item = item.strip("'\"")

                final_rule = None
                
                # 1. DOMAIN-SUFFIX 判定（以 '+.' 开头）
                if item.startswith("+."):
                    # 去除开头的 '+.'
                    final_rule = f"DOMAIN-SUFFIX,{item[2:]}" 
                
                # 2. IP-CIDR 判定（包含 '/'）
                elif '/' in item:
                    final_rule = f"IP-CIDR,{item}"
                
                # 3. DOMAIN-WILDCARD 判定（包含 '*'）
                else:
                    if '*' in item:
                        final_rule = f"DOMAIN-WILDCARD,{item}"
                    # 4. 其余均为 DOMAIN
                    else:
                        final_rule = f"DOMAIN,{item}"

                if final_rule is not None:
                    # IP-CIDR 规则需要进行 ',no-resolve' 的检查和追加
                    if final_rule.startswith('IP-CIDR'):
                        # 检查是否已经有 ',no-resolve'，避免重复
                        if not final_rule.endswith(',no-resolve'):
                            rules.append(f"{final_rule},no-resolve")
                        else:
                            rules.append(final_rule)
                    else:
                        rules.append(final_rule)

    except Exception as e:
        # 如果 YAML 文件格式错误导致解析失败，也视为严重错误
        print(f"!!! YAML parsing error: {e} !!!")
        if STRICT_SOURCE_CHECK:
            print("Strict check failed due to YAML format error. Aborting workflow.")
            sys.exit(1)
            
    return rules

def process_files():
    for task in CONFIG:
        # target 文件位于 REPO_ROOT
        target_file = os.path.join(REPO_ROOT, task['target']) 
        base_file = task['base']
        
        if not os.path.exists(base_file):
            print(f"Base file not found: {base_file}, skipping...")
            continue

        print(f"Processing {target_file}...")

        # 读取 Base 文件内容和头部计数
        with open(base_file, 'r', encoding='utf-8') as f:
            base_lines = f.readlines()
        
        base_count = 0
        base_content_no_header = []
        
        # 提取头部计数
        if base_lines and base_lines[0].startswith("#"):
            match = re.search(r'#\s*(\d+)', base_lines[0])
            if match:
                base_count = int(match.group(1))
                base_content_no_header = base_lines[1:]
            else:
                base_content_no_header = base_lines
        else:
            base_content_no_header = base_lines

        # 处理外部来源
        external_rules_content = []
        total_new_rules = 0

        for source in task['sources']:
            print(f"  - Fetching {source['name']}...")
            raw_text = get_content(source['url'])
            
            if raw_text is None:
                continue

            valid_rules = []
            
            # 处理 YAML 格式
            if source.get('type') == 'yaml':
                valid_rules = parse_yaml_payload(raw_text)
            
            # 处理 text 格式
            else:
                lines = raw_text.splitlines()
                for line in lines:
                    line = line.strip()
                    # 忽略空行和注释
                    if line and not line.startswith("#"):
                        
                        # 1. 检查规则是否已包含前缀
                        if re.match(r'^(DOMAIN|DOMAIN-SUFFIX|DOMAIN-KEYWORD|DOMAIN-WILDCARD|IP-CIDR|IP-CIDR6)', line, re.IGNORECASE):
                            
                            # 如果规则已包含 IP-CIDR 或 IP-CIDR6 前缀
                            if re.match(r'^(IP-CIDR|IP-CIDR6)', line, re.IGNORECASE):
                                # 1. 将 IP-CIDR6 规范化为 IP-CIDR
                                normalized_line = re.sub(r'^IP-CIDR6', 'IP-CIDR', line, 1, re.IGNORECASE)
                                
                                # 2. 确保添加 ',no-resolve' 
                                if not normalized_line.endswith(',no-resolve'):
                                    valid_rules.append(f"{normalized_line},no-resolve")
                                else:
                                    valid_rules.append(normalized_line)
                            else:
                                # 如果是 DOMAIN 等非 IP 前缀，原样保留
                                valid_rules.append(line)
                            
                            # 2. 规则是裸域名/IP (不含前缀) -> 依赖 determine_text_prefix
                        else:
                            auto_prefix = determine_text_prefix(line)

                            # 规则内容，默认为原始行
                            final_content = line
                            
                            # 根据 DOMAIN-SUFFIX 逻辑处理内容（移除开头的 '.'）
                            if auto_prefix == "DOMAIN-SUFFIX" and line.startswith('.'):
                                final_content = line[1:]

                            if auto_prefix == "IP-CIDR":
                                # 如果是 IP-CIDR，追加 ,no-resolve
                                valid_rules.append(f"IP-CIDR,{line},no-resolve")
                            elif auto_prefix:
                                # 否则，使用自动判定的前缀和处理后的内容 (final_content)
                                valid_rules.append(f"{auto_prefix},{final_content}")

            count = len(valid_rules)
            total_new_rules += count
            
            # 格式化输出这个来源的块
            external_rules_content.append(f"\n# {count} - {source['name']}")
            external_rules_content.extend(valid_rules)

        # 计算总数并生成文件
        final_count = base_count + total_new_rules
        
        with open(target_file, 'w', encoding='utf-8') as f:
            # 写入新的头部总数
            f.write(f"# {final_count}\n")
            # 写入 Base 文件原有内容（保留原有换行）
            f.writelines(base_content_no_header)
            # 写入外部规则
            if external_rules_content:
                f.write("\n")
                f.write("\n".join(external_rules_content))
                f.write("\n")

        print(f"Done. Total: {final_count} (Base: {base_count} + New: {total_new_rules})")

if __name__ == "__main__":
    process_files()