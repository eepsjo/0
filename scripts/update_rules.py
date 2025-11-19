import requests
import yaml
import os
import re

# ================= 配置区域 =================
# 在这里添加/删除规则来源
# target: 生成的目标文件
# base: 手动维护的基础文件
# sources: 外部规则来源
CONFIG = [
    {
        "target": "0/r",
        "base": "0/base/r",
        "sources": [
            {
                "name": "Anti-AD PCDN",
                "url": "https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/refs/heads/master/discretion/pcdn.txt",
                "type": "text"
            },
            # {
            #    "name": "Example YAML Source",
            #    "url": "https://example.com/rule.yaml",
            #    "type": "yaml"
            # },
        ]
    },
    {
        "target": "0/d",
        "base": "0/base/d",
        "sources": [
        ]
    },
    {
        "target": "0/p",
        "base": "0/base/p",
        "sources": [
        ]
    }
]
# ===========================================

def get_content(url):
    try:
        resp = requests.get(url, timeout=10)
        resp.raise_for_status()
        return resp.text
    except Exception as e:
        print(f"Error downloading {url}: {e}")
        return None

def parse_yaml_payload(content):
    """解析 YAML payload 并转换为 text 格式 (DOMAIN-SUFFIX)"""
    rules = []
    try:
        data = yaml.safe_load(content)
        if 'payload' in data:
            for item in data['payload']:
                item = item.strip("'\"") # 去除引号
                # 转换逻辑：+.abc.com -> DOMAIN-SUFFIX,abc.com
                if item.startswith("+."):
                    rules.append(f"DOMAIN-SUFFIX,{item[2:]}")
                else:
                    # 其他情况默认按原样或视作 DOMAIN
                    rules.append(f"DOMAIN,{item}")
    except Exception as e:
        print(f"YAML parsing error: {e}")
    return rules

def process_files():
    for task in CONFIG:
        target_file = task['target']
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
        
        # 提取第一行的数字
        if base_lines and base_lines[0].startswith("#"):
            match = re.search(r'#\s*(\d+)', base_lines[0])
            if match:
                base_count = int(match.group(1))
                base_content_no_header = base_lines[1:] # 保留除第一行外的内容
            else:
                base_content_no_header = base_lines
        else:
            base_content_no_header = base_lines

        # 处理外部来源
        external_rules_content = []
        total_new_rules = 0

        for source in task['sources']:
            print(f"  - Fetching {source['name']}...")
            raw_text = get_content(source['url'])
            if not raw_text:
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
                        valid_rules.append(line)

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
                f.write("\n\n") # 与手写规则隔开一点距离
                f.write("\n".join(external_rules_content))
                f.write("\n")

        print(f"Done. Total: {final_count} (Base: {base_count} + New: {total_new_rules})")

if __name__ == "__main__":
    process_files()