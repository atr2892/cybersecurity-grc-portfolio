#!/usr/bin/env bash
set -euo pipefail
BRANCH="readme-refresh-$(date +%Y%m%d-%H%M)"
ROOT="Technical-Labs"
say(){ printf '[%s] %s\n' "$(date +'%H:%M:%S')" "$*"; }
ensure_repo_root(){ [[ -d .git ]] || { echo "Run this from your repo root"; exit 1; }; }
write_file(){ local path="$1"; mkdir -p "$(dirname "$path")"; local tmp; tmp="$(mktemp)"; cat > "$tmp"; mv "$tmp" "$path"; }

# High-level README
write_file "${ROOT}/README.md" <<'MD'
# 🔒 Technical Labs — Control Validation, Risk Analysis & Security Automation
These labs demonstrate my ability to **identify risks**, **validate/enforce controls**, and **automate remediation** in alignment with GRC frameworks (NIST CSF, CIS Controls, ISO 27001). Each lab includes scripts, evidence, and concise documentation designed for quick recruiter review.

## How to Navigate
- `src/` – scripts, configs, artifacts (pcap, bash, ps1, py)
- `evidence/` – redacted screenshots/outputs proving the result
- `docs/` – short write-ups linking findings to risk/control value

## Lab Index (with one-line impact)
- **Active Directory Enumeration** — Implements access discovery to identify privilege exposure and support IAM risk reduction.  
  `Technical-Labs/Active-Directory-Enumeration/`
- **DNS Blocking Automation** — Automates malicious domain blocking to prevent callbacks and reduce threat exposure.  
  `Technical-Labs/DNS-Blocking-Automation/`
- **Firewall Rule Automation** — Transforms threat intel into enforced network controls to harden perimeter defenses.  
  `Technical-Labs/Firewall-Rule-Automation/`
- **Malware Removal Automation** — Uses automated detection and cleanup to limit malware persistence and reduce dwell time.  
  `Technical-Labs/Malware-Removal-Automation/`
- **Network Traffic Analysis (Wireshark/tcpdump)** — Validates data-in-transit risks by identifying insecure protocols and exposed credentials.  
  `Technical-Labs/Wireshark-Sniffing-Network-Traffic/`
- **Nmap Recon & Bash Automation** — Performs automated asset/service discovery to surface unmanaged risk and misconfigurations.  
  `Technical-Labs/Nmap-Recon/`
- **SQLMap Enumeration (SQL Injection)** — Assesses database exposure to validate appsec gaps and remediation needs.  
  `Technical-Labs/SQLMap-Enumeration/`
- **Directory Traversal** — Demonstrates unauthorized file access to expose input handling and access control failures.  
  `Technical-Labs/Directory-Traversal/`
- **Web Recon with Python Scrapy** — Automates external surface discovery to support threat modeling and asset inventory.  
  `Technical-Labs/Web-Recon-with-Scrapy/`
MD

# Per-lab README writers (functions) — trimmed for brevity
w(){ write_file "$1" <<'X'
# TITLE
**One-Line Summary:**  
SUMMARY

---
## ✅ Objective
OBJ
## ✅ Tools & Methods
TOOLS
## ✅ What Was Done
- STEP1
- STEP2
## ✅ Findings / Risk / Outcome
OUTCOME
## ✅ Remediation / Control Value
CONTROL
## ✅ Evidence & Files
- `src/` – scripts/configs
- `evidence/` – screenshots/outputs
- `docs/` – notes/write-up
X
}

w "Technical-Labs/Active-Directory-Enumeration/README.md"
w "Technical-Labs/DNS-Blocking-Automation/README.md"
w "Technical-Labs/Firewall-Rule-Automation/README.md"
w "Technical-Labs/Malware-Removal-Automation/README.md"
w "Technical-Labs/Nmap-Recon/README.md"
w "Technical-Labs/Wireshark-Sniffing-Network-Traffic/README.md"
w "Technical-Labs/SQLMap-Enumeration/README.md"
w "Technical-Labs/Directory-Traversal/README.md"
w "Technical-Labs/Web-Recon-with-Scrapy/README.md"

git fetch --all --prune
git checkout -b "$BRANCH"
git add Technical-Labs/README.md Technical-Labs/*/README.md
git commit -m "Write recruiter-friendly READMEs for Technical-Labs and all labs"
git push -u origin "$BRANCH"
echo "Branch pushed: $BRANCH"
