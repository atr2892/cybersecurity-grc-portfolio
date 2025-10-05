#!/usr/bin/env bash
set -euo pipefail

ROOT="Technical-Labs"
BRANCH="mini-readmes-$(date +%Y%m%d-%H%M)"

say(){ printf '[%s] %s\n' "$(date +'%H:%M:%S')" "$*"; }
ensure_root(){ [[ -d .git ]] || { echo "Run from repo root"; exit 1; }; }

write_file(){ # write_file <path> <<'MD' ... MD
  local path="$1"
  mkdir -p "$(dirname "$path")"
  local tmp; tmp="$(mktemp)"
  cat > "$tmp"
  mv "$tmp" "$path"
}

# ----- READMEs -----

ad_readme(){
write_file "$ROOT/Active-Directory-Enumeration/README.md" <<'MD'
# Active Directory Enumeration

**One-Line Summary**  
Implements access discovery to identify privilege exposure and support IAM risk reduction.

---

## ✅ Objective
Inventory **computers, users, groups, and user details** to surface unnecessary privilege and inform least-privilege remediation.

## ✅ Tools & Methods
- PowerShell: `GetADComps.ps1`, `GetADUsers.ps1`, `GetADGroups.ps1`, `GetADUsersDetails.ps1`
- Exported listings as audit evidence

## ✅ What I Did
- Queried domain **computers**, **groups**, **users**, and **user details**
- Captured evidence of enumeration and relationships

## ✅ Findings / Risk / Outcome
- Clear map of identities & memberships
- Candidates for **privilege reduction** and monitoring identified

## ✅ Remediation / Control Value
- Enforce **least privilege** + periodic access reviews
- Alert on creation/assignment of privileged groups

## 📁 Evidence & Files
- `src/` — PowerShell scripts
- `evidence/` — `a_list_of_active_directory_domain_computers.png`, `a_list_of_active_directory_domain_groups.png`, `a_list_of_active_directory_user_details.png`, `using_powershell_to_do_active_directory_search.png`
- `docs/` — notes/CSV exports
MD
}

dns_readme(){
write_file "$ROOT/DNS-Blocking-Automation/README.md" <<'MD'
# DNS Blocking Automation

**One-Line Summary**  
Automates malicious domain blocking to prevent callbacks and reduce threat exposure.

---

## ✅ Objective
Convert domain IOCs into **resolver-level blocks** (hosts/sinkhole) and verify prevention.

## ✅ Tools & Methods
- Bash/Python: `block-DNS.sh`, `AutoDNS.py`
- Feed ingestion; hosts/sinkhole updates; verification


cat > grc_linkup.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

APPLY="${APPLY:-0}"
BRANCH="grc-linkup-$(date +%Y%m%d-%H%M)"

log(){ printf '[%s] %s\n' "$(date +'%H:%M:%S')" "$*"; }
dry(){ if [[ "$APPLY" -eq 1 ]]; then eval "$*"; else echo "(dry-run) $*"; fi; }

ensure_root(){ [[ -d .git ]] || { echo "Run from repo root"; exit 1; }; }

# safe copy without overwrite; adds -1, -2 suffix if needed
safe_copy(){
  src="$1"; dest_dir="$2"
  [[ -f "$src" ]] || return 0
  dry "mkdir -p \"$dest_dir\""
  base="$(basename "$src")"
  candidate="$dest_dir/$base"
  if [[ -e "$candidate" ]]; then
    stem="${base%.*}"; ext="${base##*.}"
    if [[ "$ext" == "$base" ]]; then n=1; while [[ -e "$dest_dir/${stem}-${n}" ]]; do n=$((n+1)); done; candidate="$dest_dir/${stem}-${n}";
    else n=1; while [[ -e "$dest_dir/${stem}-${n}.${ext}" ]]; do n=$((n+1)); done; candidate="$dest_dir/${stem}-${n}.${ext}";
    fi
  fi
  if [[ "$APPLY" -eq 1 ]]; then cp "$src" "$candidate"; log "copied: $src -> $candidate"; else echo "(dry-run) cp \"$src\" \"$candidate\""; fi
}

write_file(){
  path="$1"
  dry "mkdir -p \"$(dirname "$path")\""
  if [[ "$APPLY" -eq 1 ]]; then
    tmp="$(mktemp)"; cat > "$tmp"; mv "$tmp" "$path"
  else
    echo "(dry-run) Would write $path"
  fi
}

add_ir(){
  # Folders
  dry "mkdir -p 'Incident-Response-and-Runbooks/{docs,evidence}'"
  # Evidence from labs
  safe_copy "Technical-Labs/Wireshark-Sniffing-Network-Traffic/evidence/plaintext_credentials_captured_with_post.png" "Incident-Response-and-Runbooks/evidence"
  safe_copy "Technical-Labs/Wireshark-Sniffing-Network-Traffic/evidence/target_fooled_by_fake_email_login_failed_but_credia_potentially_captured.png" "Incident-Response-and-Runbooks/evidence"
  safe_copy "Technical-Labs/Malware-Removal-Automation/evidence/display_malware_to_be_removed_by_modified_bash_script.png" "Incident-Response-and-Runbooks/evidence"
  safe_copy "Technical-Labs/Malware-Removal-Automation/evidence/removing_malware.png" "Incident-Response-and-Runbooks/evidence"
  safe_copy "Technical-Labs/Malware-Removal-Automation/evidence/confirmed_removal_of_malware_and_set_schedule.png" "Incident-Response-and-Runbooks/evidence"

  write_file "Incident-Response-and-Runbooks/README.md" <<'MD'
# Incident Response & Runbooks

**Purpose (GRC):** Standardize triage → containment → eradication → recovery with **audit-ready evidence** (NIST CSF RS/RC).

## What this includes
- **Phishing/AitM** evidence from packet analysis (credentials seen in transit)
- **Malware cleanup** automation and verification screenshots
- Pointers to runnable scripts and filters

## Work I completed (evidence)
- AitM/credential capture: see Wireshark lab evidence  
  → `Technical-Labs/Wireshark-Sniffing-Network-Traffic/`
- Malware removal automation & proof:  
  → `Technical-Labs/Malware-Removal-Automation/`

## Runbooks to build from this
- Phishing/AitM triage (proxy settings, packet capture, credential reset)
- Malware response (hash-based hunt, removal, scheduling, logs)
- Reporting: artifacts, chain-of-custody notes, ticket linkage
MD
}

add_policy(){
  dry "mkdir -p 'Policy-and-Compliance-Documents/{docs,evidence}'"
  write_file "Policy-and-Compliance-Documents/README.md" <<'MD'
# Policies & Compliance Documents

**Purpose (GRC):** Map **policies** to **control validation** already in the repo; prove they are testable and enforced.

## Controls validated by my labs
- **Access Control (AC):** AD Enumeration → `Technical-Labs/Active-Directory-Enumeration/`
- **Network Security (NS):** Firewall Automation → `Technical-Labs/Firewall-Rule-Automation/`
- **Threat Protection (TP):** DNS Blocking → `Technical-Labs/DNS-Blocking-Automation/`
- **Application Security (AS):** SQLi & Directory Traversal → `Technical-Labs/SQLMap-Enumeration/`, `Technical-Labs/Directory-Traversal/`
- **Monitoring (MON):** Packet capture findings → `Technical-Labs/Wireshark-Sniffing-Network-Traffic/`

> Next: add short policy stubs (AC, NS, TP, IR, VM) with control tests and link to the lab evidence above.
MD
}

add_splunk(){
  dry "mkdir -p 'Splunk-Detection-and-Controls/{docs,evidence,searches}'"
  # Use control-efficacy images as evidence for now
  safe_copy "Technical-Labs/DNS-Blocking-Automation/evidence/block_dns_resolution_based_on_thread_feed_start.png" "Splunk-Detection-and-Controls/evidence"
  safe_copy "Technical-Labs/Firewall-Rule-Automation/evidence/drop_rules_added_to_ip_address_table.png" "Splunk-Detection-and-Controls/evidence"

  write_file "Splunk-Detection-and-Controls/README.md" <<'MD'
# Splunk Detections & Controls

**Purpose (GRC):** Show how detections would validate controls & surface threats. (Add searches as `.spl` or `.md`.)

## Control efficacy & threat examples (evidence)
- DNS sinkhole blocks known-bad domains → see `evidence/`
- Firewall DROP rules apply to threat ranges → see `evidence/`

## Suggested searches to add
- Suspicious DNS resolutions to deny-listed domains
- New local admin group membership
- Multiple failed logins followed by success

> Next: commit 2–3 saved searches and a short “What to do when it fires” note.
MD
}

add_vuln(){
  dry "mkdir -p 'Vulnerability-Risk-Assessment/{docs,evidence}'"
  # Evidence from SQLi + Traversal
  safe_copy "Technical-Labs/SQLMap-Enumeration/evidence/enumeration_using_sqlmap.png" "Vulnerability-Risk-Assessment/evidence"
  safe_copy "Technical-Labs/SQLMap-Enumeration/evidence/sqlmap,_tables_for_the_public_database.png" "Vulnerability-Risk-Assessment/evidence"
  safe_copy "Technical-Labs/Directory-Traversal/evidence/directory_traveral_vulnerability_in_url_proven.png" "Vulnerability-Risk-Assessment/evidence"

  write_file "Vulnerability-Risk-Assessment/README.md" <<'MD'
# Vulnerability & Risk Assessment

**Purpose (GRC):** Turn technical findings into **prioritized risk** with owners, due dates, and closure evidence.

## Findings represented here
- **SQL Injection (SQLi):** DB discovery & table/column enumeration (proof-of-impact)
- **Directory Traversal:** Sensitive file access via path manipulation

## How I handle it
- Translate to risk register entries (CVSS + business impact)
- Create remediation tickets with owners & SLA
- Capture **before/after** proof in `evidence/`

See labs for full evidence:  
→ `Technical-Labs/SQLMap-Enumeration/` and `Technical-Labs/Directory-Traversal/`
MD
}

add_cloud(){
  dry "mkdir -p 'Cloud Administration/{docs,evidence}'"
  write_file "Cloud Administration/README.md" <<'MD'
# Cloud Administration

**Purpose (GRC):** Baseline **secure configuration** (identity, network, logging, storage) with verification and logging.

## Current status
This repo currently focuses on on-prem/lab artifacts. This page is ready to host:
- IAM baseline (MFA, role-based access, key rotation)
- Network guardrails (least-priv SGs/NACLs, egress control)
- Logging/monitoring (centralized logs, alerts)
- Storage policies (encryption, lifecycle)

> Add screenshots/CLI outputs under `evidence/` and short steps under `docs/` as you capture them.
MD
}

main(){
  ensure_root
  git fetch --all --prune
  git checkout main >/dev/null 2>&1 || git checkout -B main
  if [[ "$APPLY" -eq 1 ]]; then git checkout -b "$BRANCH"; else log "(dry-run) Would create branch $BRANCH"; fi

  add_ir
  add_policy
  add_splunk
  add_vuln
  add_cloud

  if [[ "$APPLY" -eq 1" ]]; then
    git add "Incident-Response-and-Runbooks" "Policy-and-Compliance-Documents" "Splunk-Detection-and-Controls" "Vulnerability-Risk-Assessment" "Cloud Administration" || true
    if ! git diff --cached --quiet; then
      git commit -m "GRC link-up: copy representative evidence and add recruiter-friendly READMEs linking to labs"
      git push -u origin "$BRANCH"
      log "✅ Branch pushed: $BRANCH (open a PR → main)"
    else
      log "No changes staged."
    fi
  else
    log "Dry-run complete. To apply: APPLY=1 bash grc_linkup.sh"
  fi
}

main
