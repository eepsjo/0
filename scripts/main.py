import re
import yaml
import requests
from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo

# 外部来源映射，手动引用（包含 oth 的远程地址）
SOURCES_MAP = {
    "d": [
        {"name": "game @", "url": "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/oth/d/game"},
        {"name": "tool @", "url": "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/oth/d/tool"},
        {"name": "LANCIDR @ Loyalsoldier/clash-rules", "url": "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/refs/heads/release/lancidr.txt"},
        {"name": "PRIVATE @ Loyalsoldier/clash-rules", "url": "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/refs/heads/release/private.txt"},
    ],
    "p": [
        {"name": "game @", "url": "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/oth/p/game"},
        {"name": "nsfw @", "url": "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/oth/p/nsfw"},
        {"name": "tool @", "url": "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/oth/p/tool"},
        {"name": "PROTONMAIL @ MetaCubeX/meta-rules-dat", "url": "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/refs/heads/meta/geo/geosite/protonmail.list"},
        {"name": "TELEGRAMCIDR @ Loyalsoldier/clash-rules", "url": "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/refs/heads/release/telegramcidr.txt"},
    ],
    "r": [
        {"name": "ad @", "url": "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/oth/r/ad"},
        {"name": "fuck @", "url": "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/oth/r/fuck"},
        {"name": "gdid @", "url": "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/oth/r/gdid"},
        {"name": "pcdn @", "url": "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/oth/r/pcdn"},
        {"name": "stun @", "url": "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/oth/r/stun"},
        {"name": "wo @", "url": "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/oth/r/wo"},
        {"name": "PCDN @ privacy-protection-tools/anti-AD", "url": "https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/refs/heads/master/discretion/pcdn.txt"},
        {"name": "DNS @ privacy-protection-tools/anti-AD", "url": "https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/refs/heads/master/discretion/dns.txt"},
    ],
    "jp": [
        #
    ],
    "no_jp": [
        #
    ],
    "ai": [
        {"name": "GEMINI @ MetaCubeX/meta-rules-dat", "url": "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/refs/heads/meta/geo/geosite/google-gemini.list"},
        {"name": "OPENAI @ MetaCubeX/meta-rules-dat", "url": "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/refs/heads/meta/geo/geosite/openai.list"},
    ],
}

def extract_count_from_base(text):
    """从 base 文件中提取 BASE START 后紧跟的数量，如 # 1"""
    match = re.search(r'#\s*===\s*BASE START\s*===\s*\n\s*#\s*(\d+)', text)
    if match:
        return int(match.group(1))
    # fallback: 全文第一个 # 数字
    match = re.search(r'^#\s*(\d+)', text, re.MULTILINE)
    return int(match.group(1)) if match else 0

def extract_count_from_oth(text):
    """从 oth 文件首行提取数量，如 # 5 - game @"""
    first_line = text.splitlines()[0] if text.splitlines() else ""
    match = re.search(r'#\s*(\d+)', first_line)
    return int(match.group(1)) if match else 0

def parse_and_normalize(content):
    """解析第三方源（非 @ 结尾），尝试解析 YAML，失败则按行处理"""
    rules = []
    raw_lines = []
    try:
        yaml_data = yaml.safe_load(content)
        if isinstance(yaml_data, dict) and "payload" in yaml_data:
            for item in yaml_data["payload"]:
                raw_lines.append(str(item))
        else:
            raw_lines = content.splitlines()
    except Exception:
        raw_lines = content.splitlines()

    for line in raw_lines:
        line = line.strip().strip("'").strip('"')
        if not line or line.startswith(('#', '//', '!', 'payload:')):
            continue
        if ',' in line:
            upper = line.upper()
            if upper.startswith("IP-CIDR"):
                fixed = line.replace("IP-CIDR6", "IP-CIDR").replace("ip-cidr6", "IP-CIDR").replace("ip-cidr", "IP-CIDR")
                if "NO-RESOLVE" not in upper:
                    fixed += ",no-resolve"
                rules.append(fixed)
            else:
                rules.append(line)
        else:
            if '/' in line:
                rules.append(f"IP-CIDR,{line},no-resolve")
            elif '*' in line:
                rules.append(f"DOMAIN-WILDCARD,{line}")
            elif line.startswith(('.', '+')):
                rules.append(f"DOMAIN-SUFFIX,{line.lstrip('.+')}")
            else:
                rules.append(f"DOMAIN,{line}")
    return rules

def process_task(target_name, base_path):
    print(f"Processing {target_name}.txt...")

    # 1. 原样读取 base 文件（已去掉首尾空白）
    with open(base_path, 'r', encoding='utf-8') as f:
        base_content = f.read().strip()

    base_count = extract_count_from_base(base_content)

    external_blocks = []
    total_external_count = 0

    # 2. 处理外部源
    for src in SOURCES_MAP.get(target_name, []):
        print(f"  - Fetching {src['name']}...")
        resp = requests.get(src['url'], timeout=15)
        resp.raise_for_status()
        raw_text = resp.text.strip()

        if src['name'].strip().endswith('@'):
            # oth 文件：原样输出，从首行提取数量
            count = extract_count_from_oth(raw_text)
            total_external_count += count
            external_blocks.append(raw_text)
        else:
            # 第三方源：解析并规范化
            rules = parse_and_normalize(raw_text)
            count = len(rules)
            total_external_count += count
            if count > 0:
                external_blocks.append(f"# {count} - {src['name']}\n" + "\n".join(rules))

    # 3. 拼装最终输出
    final_count = base_count + total_external_count
    taipei_now = datetime.now(ZoneInfo("Asia/Taipei")).strftime("%y%m%d")

    parts = [f"# {final_count} - Taipei_{taipei_now}", base_content]
    parts.extend(external_blocks)

    final_output = "\n\n".join(parts) + "\n"

    # 4. 写入 output 目录
    output_path = Path(f"output/{target_name}.txt")
    output_path.parent.mkdir(exist_ok=True)
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(final_output)

    print(f"Done {target_name}. Total: {final_count} (Base: {base_count} + External: {total_external_count})")

def main():
    base_dir = Path("base")
    if not base_dir.exists():
        print("base directory not found!")
        return

    # 自适应遍历 base 目录下的所有文件
    for file_path in base_dir.iterdir():
        if file_path.is_file():
            process_task(file_path.name, file_path)

if __name__ == "__main__":
    main()