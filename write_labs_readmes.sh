#!/usr/bin/env bash
set -euo pipefail

# Run from repo root: cybersecurity-grc-portfolio
# This script overwrites README.md files for the Technical-Labs folder and each lab.
# Creates a branch, writes files, commits, and pushes.

BRANCH="readme-refresh-$(date +%Y%m%d-%H%M)"
ROOT="Technical-Labs"

say(){ printf '[%s] %s\n' "$(date +'%H:%M:%S')" "$*"; }

ensure_repo_root(){
  [[ -d .git ]] || { echo "Run this from your repo root"; exit 1; }
}

# Write a file atomically
write_file(){ # write_file <path> <<'EOF' ... EOF
  local path="$1"
  mkdir -p "$(dirname "$path")"
  # use a temp to avoid partial writes
  local tmp; tmp="$(mktemp)"
  cat > "$tmp"
  mv "$tmp" "$path"
}

# ------------- High-level README for Technical-Labs -------------
write_techlabs_readme(){
  write_file "${ROOT}/README.md" <<'EOF'
# 🔒 Technical Labs — Control Validation, Risk Analysis & Security Automation

These labs demonstrate my ability to **identify risks**, **validate/enforce controls**, and **automate remediation** in alignment with GRC frameworks (NIST CSF, CIS Controls, ISO 27001). Each lab includes scripts, evidence, and concise documentation designed for quick recruiter review.

## How to Navigate
Each folder contains:
- `src/` – scripts, configs, or artifacts (pcap, bash, ps1, py)
- `evidence/` – redacted screenshots or outputs proving the result
- `docs/` – short write-ups or summaries connecting work to risk/control value

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

> All work performed in an isolated lab with test systems and accounts. Screenshots are redacted where appropriate.
EOF
}

# ------------- Mini READMEs for each lab -------------

readme_active_directory() {
  write_file "${ROOT}/Active-Directory-Enumeration/README.md" <<'EOF'
# Active Directory Enumeration

**One-Line Summary:**  
Implements access discovery to identify privilege exposure and support IAM risk reduction.

---

## ✅ Objective
Enumerate domain **computers, users, groups, and user details** to spotlight potential privilege escalation paths and identity risks.

## ✅ Tools & Methods
- PowerShell (`Get-ADUsers.ps1`, `Get-ADGroups.ps1`, `GetADComps.ps1`, `GetADUsersDetails.ps1`)
- Domain-aware queries; CSV/export for audit evidence

## ✅ What Was Done
- Queried AD to inventory principals and memberships
- Isolated high-risk groups and sensitive accounts
- Prepared artifacts for access review / least-privilege remediation

## ✅ Findings / Risk / Outcome
- Clear map of identities and group relationships
- Identified candidates for **least-privilege** adjustments and monitoring

## ✅ Remediation / Control Value
- Reduce standing privileges; require JIT/JEA
- Implement periodic **access reviews** and alerting on new privileged grants

## ✅ Evidence & Files
- `src/` – PowerShell enumeration scripts  
- `evidence/` – screenshots of group/user/computer listings  
- `docs/` – short summary or CSV extracts
EOF
}

readme_dns_blocking() {
  write_file "${ROOT}/DNS-Blocking-Automation/README.md" <<'EOF'
# DNS Blocking Automation

**One-Line Summary:**  
Automates malicious domain resolution blocking to prevent callbacks and reduce threat exposure.

---

## ✅ Objective
Convert threat intel into resolver-level controls (sinkhole/hosts updates) to stop known-bad domains at the point of resolution.

## ✅ Tools & Methods
- Bash, Python (requests/Scrapy for feeds)
- `/etc/hosts` or DNS sinkhole; scheduled updates (cron)

## ✅ What Was Done
- Pulled IOCs/domains from feed(s)
- Updated resolver to block resolution
- Verified blocks and logged hits for reporting

## ✅ Findings / Risk / Outcome
- **Callback attempts denied** at DNS layer
- Reduced exposure to phishing/C2 infrastructure

## ✅ Remediation / Control Value
- Enforce **deny-list** at DNS
- Integrate with SIEM for alerting on attempted lookups

## ✅ Evidence & Files
- `src/` – `AutoDNS.py`, `block-DNS.sh`  
- `evidence/` – screenshots of blocked lookups / resolver output  
- `docs/` – brief summary + IOC sources
EOF
}

readme_firewall() {
  write_file "${ROOT}/Firewall-Rule-Automation/README.md" <<'EOF'
# Firewall Rule Automation

**One-Line Summary:**  
Transforms threat intelligence into enforced network controls to harden perimeter defenses.

---

## ✅ Objective
Ingest IP/CIDR threat feeds and automatically enforce **DROP** rules with deduplication and scheduling.

## ✅ Tools & Methods
- Bash + `iptables` (or platform equivalent), cron
- De-dup + idempotent updates

## ✅ What Was Done
- Pulled hostile ranges from feeds
- Added/updated firewall rules; removed duplicates
- Scheduled refresh to keep rules current

## ✅ Findings / Risk / Outcome
- Measurable reduction in unwanted inbound/outbound connectivity
- Repeatable **control enforcement** with audit trail

## ✅ Remediation / Control Value
- Integrate with **change management**
- Tune allowlists for business traffic; ship counters to SIEM

## ✅ Evidence & Files
- `src/` – `ip_block.sh`  
- `evidence/` – rule application, de-dup verification, scheduled job proof  
- `docs/` – quick runbook
EOF
}

readme_malware() {
  write_file "${ROOT}/Malware-Removal-Automation/README.md" <<'EOF'
# Malware Removal Automation

**One-Line Summary:**  
Uses automated detection and cleanup to limit malware persistence and reduce dwell time.

---

## ✅ Objective
Automate **hash-based detection** and removal of known malware, with scheduled scans and logging.

## ✅ Tools & Methods
- Bash scripting, cron, hash feeds (SHA256)
- Defensive removal + verification logs

## ✅ What Was Done
- Matched files against IOC hash list
- Removed verified matches; logged actions
- Scheduled periodic scans

## ✅ Findings / Risk / Outcome
- Reduced dwell time for known threats
- Repeatable remediation with evidence artifacts

## ✅ Remediation / Control Value
- Integrate with EDR + ticketing for case tracking
- Add quarantine workflow and restore safeguards

## ✅ Evidence & Files
- `src/` – `remove-malware.sh`  
- `evidence/` – detections and cleanup confirmations  
- `docs/` – short procedure + rollback notes
EOF
}

readme_nmap() {
  write_file "${ROOT}/Nmap-Recon/README.md" <<'EOF'
# Nmap Recon & Bash Automation

**One-Line Summary:**  
Performs automated asset and service discovery to surface unmanaged risk and misconfigurations.

---

## ✅ Objective
Automate recon to produce consistent service/port baselines and catch drift or unexpected exposures.

## ✅ Tools & Methods
- Bash + Nmap (`NmapAnalysis.sh`)
- Prompted inputs; error handling; dual-port logic

## ✅ What Was Done
- Scanned targets; handled fast/full modes
- Normalized outputs; fixed `-F` conflict
- Collected screenshots of results & fixes

## ✅ Findings / Risk / Outcome
- Identified exposed services and anomalies
- Improved repeatability for **assessment baselines**

## ✅ Remediation / Control Value
- Feed exposures to vulnerability management
- Track changes over time for compliance evidence

## ✅ Evidence & Files
- `src/` – `NmapAnalysis.sh`  
- `evidence/` – outputs, error/fix screenshots, final runs  
- `docs/` – brief SOP
EOF
}

readme_wireshark() {
  write_file "${ROOT}/Wireshark-Sniffing-Network-Traffic/README.md" <<'EOF'
# Network Traffic Analysis (Wireshark / tcpdump)

**One-Line Summary:**  
Validates data-in-transit risks by identifying insecure protocols and exposed credentials.

---

## ✅ Objective
Capture and analyze traffic to confirm encryption posture and detect plaintext credentials or sensitive data in transit.

## ✅ Tools & Methods
- `tcpdump`, Wireshark (filters for HTTP/FTP/ICMP, TLS handshakes)
- PCAP review; redacted screenshots

## ✅ What Was Done
- Captured protocol-specific traffic
- Verified **plaintext POST creds** on legacy endpoints
- Documented filters and findings

## ✅ Findings / Risk / Outcome
- Confirmed insecure services and credential exposure
- Input to hardening plan and control verification

## ✅ Remediation / Control Value
- Enforce TLS/HSTS; deprecate legacy protocols
- Add IDS/NSM rules for credential leakage

## ✅ Evidence & Files
- `evidence/` – captures, filter examples, findings  
- `docs/` – short summary or PCAP notes
EOF
}

readme_sqlmap() {
  write_file "${ROOT}/SQLMap-Enumeration/README.md" <<'EOF'
# SQLMap Enumeration & Database Exposure Assessment

**One-Line Summary:**  
Assesses database exposure through SQLi to validate application security gaps and remediation needs.

---

## ✅ Objective
Demonstrate impact of SQL injection by discovering DBMS, listing tables/columns, and confirming data access.

## ✅ Tools & Methods
- SQLMap with safe switches in lab context
- Targeted enumeration for proof-of-impact

## ✅ What Was Done
- Detected DBMS and enumerated schema
- Captured screenshots of tables/columns
- Mapped results to affected data types

## ✅ Findings / Risk / Outcome
- Verified data exposure depth (beyond banner grabs)
- Concrete evidence for remediation prioritization

## ✅ Remediation / Control Value
- Parameterized queries; WAF rules; least privilege on DB accounts
- SDLC controls (code review, SAST/DAST gates)

## ✅ Evidence & Files
- `evidence/` – DB name, tables, columns  
- `docs/` – short write-up for ticketing
EOF
}

readme_dir_traversal() {
  write_file "${ROOT}/Directory-Traversal/README.md" <<'EOF'
# Directory Traversal Vulnerability Assessment

**One-Line Summary:**  
Demonstrates unauthorized file access to expose input handling and access control failures.

---

## ✅ Objective
Prove path traversal via crafted URLs, accessing files outside intended directories (e.g., `/etc/passwd`).

## ✅ Tools & Methods
- Browser/Burp for request manipulation
- Evidence capture showing traversal and disclosure

## ✅ What Was Done
- Crafted traversal payloads (`../`)
- Accessed restricted files; documented proof
- Assessed business data exposure

## ✅ Findings / Risk / Outcome
- Confirmed improper path handling and insufficient validation
- Evidence supports risk acceptance or mitigation tracking

## ✅ Remediation / Control Value
- Normalize/validate paths; restrict filesystem reads
- Add WAF patterns; strengthen authorization checks

## ✅ Evidence & Files
- `evidence/` – traversal steps, sensitive file reads  
- `docs/` – summary for defect ticket
EOF
}

readme_scrapy() {
  write_file "${ROOT}/Web-Recon-with-Scrapy/README.md" <<'EOF'
# Web Recon with Python Scrapy

**One-Line Summary:**  
Automates external surface discovery to support threat modeling and asset inventory accuracy.

---

## ✅ Objective
Collect structured data from target web properties to inform testing scope and exposure profiles.

## ✅ Tools & Methods
- Python Scrapy; selective parsing of metadata and endpoints
- Exported results for analysis

## ✅ What Was Done
- Gathered endpoints/metadata
- Organized results for downstream testing
- Captured evidence of runs and outputs

## ✅ Findings / Risk / Outcome
- Improved visibility of exposed surface
- Input for risk ranking and scoping

## ✅ Remediation / Control Value
- Update asset inventory; monitor new exposure over time
- Feed discoveries into appsec backlog

## ✅ Evidence & Files
- `src/` – `ScrapyRecon.py`  
- `evidence/` – run outputs / screenshots  
- `docs/` – short usage notes
EOF
}

# ------------- Main -------------
ensure_repo_root
say "Creating branch and writing READMEs…"
git fetch --all --prune
git checkout main >/dev/null 2>&1 || git checkout -B main
git checkout -b "$BRANCH"

# Ensure folders exist (won't fail if they already do)
mkdir -p "${ROOT}/Active-Directory-Enumeration" \
         "${ROOT}/DNS-Blocking-Automation" \
         "${ROOT}/Directory-Traversal" \
         "${ROOT}/Firewall-Rule-Automation" \
         "${ROOT}/Malware-Removal-Automation" \
         "${ROOT}/Nmap-Recon" \
         "${ROOT}/SQLMap-Enumeration" \
         "${ROOT}/Web-Recon-with-Scrapy" \
         "${ROOT}/Wireshark-Sniffing-Network-Traffic"

# Write files
write_techlabs_readme
readme_active_directory
readme_dns_blocking
readme_firewall
readme_malware
readme_nmap
readme_wireshark
readme_sqlmap
readme_dir_traversal
readme_scrapy

# Commit & push
git add "${ROOT}/README.md" \
        "${ROOT}/Active-Directory-Enumeration/README.md" \
        "${ROOT}/DNS-Blocking-Automation/README.md" \
        "${ROOT}/Directory-Traversal/README.md" \
        "${ROOT}/Firewall-Rule-Automation/README.md" \
        "${ROOT}/Malware-Removal-Automation/README.md" \
        "${ROOT}/Nmap-Recon/README.md" \
        "${ROOT}/SQLMap-Enumeration/README.md" \
        "${ROOT}/Web-Recon-with-Scrapy/README.md" \
        "${ROOT}/Wireshark-Sniffing-Network-Traffic/README.md"

git commit -m "README refresh: recruiter-friendly GRC + SecEng summaries for Technical-Labs and all lab folders"
git push -u origin "$BRANCH"

say "✅ Done. Open a PR from $BRANCH → main."
