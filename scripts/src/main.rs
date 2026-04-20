use reqwest::blocking::Client;
use serde_yaml::Value;
use std::fs;
use std::path::Path;
use chrono::Utc;
use chrono_tz::Asia::Taipei;

const STRICT_SOURCE_CHECK: bool = true;

struct Source {
    name: &'static str,
    url: &'static str,
}

struct Task {
    target: &'static str,
    base: &'static str,
    sources: Vec<Source>,
}

fn main() {
    let client = Client::builder()
        .timeout(std::time::Duration::from_secs(15))
        .build()
        .expect("Failed to build client");

    let tasks = vec![
        Task {
            target: "r",
            base: "base/r",
            sources: vec![
                Source { name: "STUN @", url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/oth/r/stun" },
                Source { name: "FU @", url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/oth/r/fu" },
                Source { name: "AD @", url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/oth/r/ad" },
                Source { name: "pcdn @ privacy-protection-tools/anti-AD", url: "https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/refs/heads/master/discretion/pcdn.txt" },
                Source { name: "dns @ privacy-protection-tools/anti-AD", url: "https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/refs/heads/master/discretion/dns.txt" },
            ],
        },
        Task {
            target: "d",
            base: "base/d",
            sources: vec![
                Source { name: "SYST @", url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/oth/d/syst" },
                Source { name: "GAME @", url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/oth/d/game" },
                Source { name: "lancidr @ Loyalsoldier/clash-rules", url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/refs/heads/release/lancidr.txt" },
                Source { name: "private @ Loyalsoldier/clash-rules", url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/refs/heads/release/private.txt" },
            ],
        },
        Task {
            target: "p",
            base: "base/p",
            sources: vec![
                Source { name: "MASQ @", url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/oth/p/masq" },
                Source { name: "TOOL @", url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/oth/p/tool" },
                Source { name: "NSFW @", url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/oth/p/nsfw" },
                Source { name: "GAME @", url: "https://raw.githubusercontent.com/eepsjo/0/refs/heads/0/oth/p/game" },
                Source { name: "telegramcidr @ Loyalsoldier/clash-rules", url: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/refs/heads/release/telegramcidr.txt" },
            ],
        },
    ];

    for task in tasks {
        if let Err(e) = process_task(&client, &task) {
            eprintln!("!!! Task {} failed: {} !!!", task.target, e);
            if STRICT_SOURCE_CHECK { std::process::exit(1); }
        }
    }
}

fn process_task(client: &Client, task: &Task) -> Result<(), Box<dyn std::error::Error>> {
    println!("Processing {}...", task.target);
    
    if !Path::new(task.base).exists() {
        println!("Base file {} not found, skipping...", task.base);
        return Ok(());
    }
    
    let base_full_content = fs::read_to_string(task.base)?;
    let base_count = extract_first_line_count(&base_full_content);
    
    let mut external_rules_text = String::new();
    let mut total_external_count = 0;

    for source in &task.sources {
        println!("  - Fetching {}...", source.name);
        let resp = client.get(source.url).send()?;
        if !resp.status().is_success() {
            return Err(format!("Download failed for {}: {}", source.name, resp.status()).into());
        }
        let raw_text = resp.text()?;

        if source.name.trim().ends_with('@') {
            let count = extract_first_line_count(&raw_text);
            total_external_count += count;
            external_rules_text.push_str("\n\n");
            external_rules_text.push_str(raw_text.trim());
        } else {
            let processed_rules = parse_and_normalize(&raw_text);
            let count = processed_rules.len();
            total_external_count += count as u32;

            if count > 0 {
                external_rules_text.push_str(&format!("\n\n# {} - {}\n", count, source.name));
                external_rules_text.push_str(&processed_rules.join("\n"));
            }
        }
    }

    let final_count = base_count + total_external_count;
    let taipei_now = Utc::now().with_timezone(&Taipei);
    
    let mut output = format!("# {} - Taipei_{}\n", final_count, taipei_now.format("%y%m%d"));

    let base_body = base_full_content
        .lines()
        .skip(1)
        .collect::<Vec<&str>>()
        .join("\n");

    output.push_str(&base_body);
    
    let final_output = output.trim_end().to_string() + &external_rules_text + "\n";
    
    fs::write(task.target, final_output)?;
    println!("Done. Total: {} (Base: {} + External: {})", final_count, base_count, total_external_count);
    Ok(())
}

fn extract_first_line_count(content: &str) -> u32 {
    content.lines().next()
        .and_then(|line| {
            line.split(|c: char| !c.is_numeric())
                .find(|s| !s.is_empty())
                .and_then(|s| s.parse::<u32>().ok())
        })
        .unwrap_or(0)
}

fn parse_and_normalize(content: &str) -> Vec<String> {
    let mut rules = Vec::new();
    
    let raw_lines: Vec<String> = if let Ok(yaml) = serde_yaml::from_str::<Value>(content) {
        if let Some(payload) = yaml.get("payload").and_then(|v| v.as_sequence()) {
            payload.iter().filter_map(|v| v.as_str().map(|s| s.to_string())).collect()
        } else {
            content.lines().map(|s| s.to_string()).collect()
        }
    } else {
        content.lines().map(|s| s.to_string()).collect()
    };

    for line in raw_lines {
        let line = line.trim().trim_matches(|c| c == '\'' || c == '\"');
        if line.is_empty() || line.starts_with('#') || line.starts_with("//") || line.starts_with('!') || line == "payload:" {
            continue;
        }

        if line.contains(',') {
            let upper = line.to_uppercase();
            if upper.starts_with("IP-CIDR") {
                let mut fixed = line.replace("IP-CIDR6", "IP-CIDR")
                                   .replace("ip-cidr6", "IP-CIDR")
                                   .replace("ip-cidr", "IP-CIDR");
                if !upper.contains("NO-RESOLVE") {
                    fixed.push_str(",no-resolve");
                }
                rules.push(fixed);
            } else {
                rules.push(line.to_string());
            }
        } else {
            if line.contains('/') {
                rules.push(format!("IP-CIDR,{},no-resolve", line));
            } else if line.contains('*') {
                rules.push(format!("DOMAIN-WILDCARD,{}", line));
            } else if line.starts_with('.') || line.starts_with('+') {
                rules.push(format!("DOMAIN-SUFFIX,{}", line.trim_start_matches(|c| c == '.' || c == '+')));
            } else {
                rules.push(format!("DOMAIN,{}", line));
            }
        }
    }
    rules
}
