#!/usr/bin/env bash
set -euo pipefail

# Run from repo root: cybersecurity-grc-portfolio
# Dry-run by default. Set APPLY=1 to actually move & commit.
APPLY="${APPLY:-0}"

log(){ printf '[%s] %s\n' "$(date +'%H:%M:%S')" "$*"; }
dry(){ if [[ "$APPLY" -ne 1 ]]; then echo "(dry-run) $*"; else eval "$*"; fi; }

ensure_repo_root(){ [[ -d .git ]] || { echo "Run this from your repo root"; exit 1; }; }

safe_mv() {
  # safe_mv <src> <dest_dir>
  local src="$1"; local dest="$2"
  [[ -f "$src" ]] || return 0
  dry "mkdir -p \"$dest\""
  local base="$(basename "$src")"
  local candidate="$dest/$base"
  # add suffix if exists
  if [[ -e "$candidate" ]]; then
    local stem="${base%.*}"; local ext="${base##*.}"
    if [[ "$ext" == "$base" ]]; then
      local n=1; while [[ -e "$dest/${stem}-${n}" ]]; do n=$((n+1)); done
      candidate="$dest/${stem}-${n}"
    else
      local n=1; while [[ -e "$dest/${stem}-${n}.${ext}" ]]; do n=$((n+1)); done
      candidate="$dest/${stem}-${n}.${ext}"
    fi
  fi
  if [[ "$APPLY" -eq 1 ]]; then
    git mv "$src" "$candidate" 2>/dev/null || mv "$src" "$candidate"
    log "moved: $src -> $candidate"
  else
    echo "(dry-run) git mv \"$src\" \"$candidate\" || mv \"$src\" \"$candidate\""
  fi
}

lab_readme(){
  # lab_readme "Title"
  cat <<'EOF'
# {{TITLE}}

**Objective.** One sentence on what you set out to do and why it matters.

**Tools & Skills.** Wireshark • tcpdump • Nmap • SQLMap • PowerShell • Python • Bash • iptables • Automation

## What I Did (Brief)
- Step 1–2 highlights (what you executed)
- Key commands or scripts used (link to files in `src/`)
- What evidence is shown (screenshots in `evidence/`)

## Findings / Results
- Concrete outcomes (e.g., “captured plaintext POST creds,” “identified open 21/80 with misconfig”)
- Short impact statement (risk/business relevance)

## Remediation / Next Steps
- Specific fixes (e.g., enforce TLS, add WAF rule, harden AD group policies)
- How to monitor/prevent regression

## Repo Map
- `src/` – scripts/configs/artifacts (pcap, shell, py, ps1)
- `evidence/` – redacted screenshots supporting the finding
- `docs/` – optional PDF/markdown write-up

EOF
}

write_readme(){
  local dir="$1"; local title="$2"
  [[ -f "$dir/README.md" ]] && return 0
  dry "mkdir -p \"$dir\""
  if [[ "$APPLY" -eq 1 ]]; then
    lab_readme | sed "s/{{TITLE}}/$title/" > "$dir/README.md"
    git add "$dir/README.md"
  else
    echo "(dry-run) Would create $dir/README.md"
  fi
}

update_top_readme(){
  local bullet="$1"
  if [[ ! -f README.md ]]; then return; fi
  if grep -Fq "$bullet" README.md; then return; fi
  if grep -Eq '^##[[:space:]]*Technical Labs' README.md; then
    local tmp; tmp="$(mktemp)"
    awk -v sect='^##[[:space:]]*Technical Labs' -v bullet="$bullet" '
      BEGIN{ins=0}
      { print $0; if(!ins && $0 ~ sect){ print bullet; ins=1 } }
    ' README.md > "$tmp"
    if [[ "$APPLY" -eq 1 ]]; then mv "$tmp" README.md; git add README.md; else rm -f "$tmp"; echo "(dry-run) Would add: $bullet"; fi
  else
    dry "printf '\n%s\n\n%s\n' '##  Technical Labs' '$bullet' >> README.md"
    [[ "$APPLY" -eq 1 ]] && git add README.md || true
  fi
}

main(){
  ensure_repo_root
  git fetch --all --prune
  git checkout main >/dev/null 2>&1 || git checkout -B main
  ts="$(date +%Y%m%d-%H%M)"
  work="recruiter-cleanup-$ts"
  if [[ "$APPLY" -eq 1 ]]; then git checkout -b "$work"; else log "(dry-run) Would create branch $work"; fi

  # === Create target lab dirs
  declare -A L
  L[Active-Directory-Enumeration]="Technical-Labs/Active-Directory-Enumeration"
  L[DNS-Blocking-Automation]="Technical-Labs/DNS-Blocking-Automation"
  L[Firewall-Rule-Automation]="Technical-Labs/Firewall-Rule-Automation"
  L[Malware-Removal-Automation]="Technical-Labs/Malware-Removal-Automation"
  L[Nmap-Recon]="Technical-Labs/Nmap-Recon"
  L[Web-Recon-with-Scrapy]="Technical-Labs/Web-Recon-with-Scrapy"
  L[Wireshark-Sniffing-Network-Traffic]="Technical-Labs/Wireshark-Sniffing-Network-Traffic"
  L[SQLMap-Enumeration]="Technical-Labs/SQLMap-Enumeration"
  L[Directory-Traversal]="Technical-Labs/Directory-Traversal"

  for k in "${!L[@]}"; do
    dry "mkdir -p \"${L[$k]}/src\" \"${L[$k]}/evidence\" \"${L[$k]}/docs\""
  done

  # === Map your actual files (from your list) to labs
  # Active Directory
  safe_mv "GetADComps.ps1"      "${L[Active-Directory-Enumeration]}/src"
  safe_mv "GetADGroups.ps1"     "${L[Active-Directory-Enumeration]}/src"
  safe_mv "GetADUsers.ps1"      "${L[Active-Directory-Enumeration]}/src"
  safe_mv "GetADUsersDetails.ps1" "${L[Active-Directory-Enumeration]}/src"
  safe_mv "a_list_of_active_directory_domain_computers.png" "${L[Active-Directory-Enumeration]}/evidence"
  safe_mv "a_list_of_active_directory_domain_groups.png"    "${L[Active-Directory-Enumeration]}/evidence"
  safe_mv "a_list_of_active_directory_user_details.png"     "${L[Active-Directory-Enumeration]}/evidence"
  safe_mv "using_powershell_to_do_active_directory_search.png" "${L[Active-Directory-Enumeration]}/evidence"

  # Nmap Recon / Bash automation
  safe_mv "NmapAnalysis.sh"     "${L[Nmap-Recon]}/src"
  safe_mv "scripting_automation_-_nmapanalysis_output.png" "${L[Nmap-Recon]}/evidence"
  safe_mv "bash_script_show_target_that_has_both_open_ports.png" "${L[Nmap-Recon]}/evidence"
  safe_mv "change_script_to_receive_prompt_to_specify_port_scan.png" "${L[Nmap-Recon]}/evidence"
  safe_mv "final_bash_output.png" "${L[Nmap-Recon]}/evidence"
  safe_mv "script_change_output.png" "${L[Nmap-Recon]}/evidence"
  safe_mv "error_output.png" "${L[Nmap-Recon]}/evidence"
  safe_mv "fixed_error_by_removing_-f.png" "${L[Nmap-Recon]}/evidence"

  # Wireshark / tcpdump / credential capture
  safe_mv "tcpdump_capturing_100_packets_only_on_icmp.png" "${L[Wireshark-Sniffing-Network-Traffic]}/evidence"
  safe_mv "using_eth0_interface_to_capture_traffic.png"     "${L[Wireshark-Sniffing-Network-Traffic]}/evidence"
  safe_mv "capture_traffic_related_to_port_80_and_ftp_using_tcpdump.png" "${L[Wireshark-Sniffing-Network-Traffic]}/evidence"
  safe_mv "wireshark_analyzing_pcap_files.png"              "${L[Wireshark-Sniffing-Network-Traffic]}/evidence"
  safe_mv "plaintext_credentials_captured_with_post.png"    "${L[Wireshark-Sniffing-Network-Traffic]}/evidence"
  safe_mv "shows_crediatials_were_captured_will_copy_to_file.png" "${L[Wireshark-Sniffing-Network-Traffic]}/evidence"

  # DNS Blocking Automation
  safe_mv "AutoDNS.py"          "${L[DNS-Blocking-Automation]}/src"
  safe_mv "block-DNS.sh"        "${L[DNS-Blocking-Automation]}/src"
  safe_mv "block_dns_resolution_based_on_thread_feed_start.png" "${L[DNS-Blocking-Automation]}/evidence"
  safe_mv "shows_scrit_that_automatically_retrieve_bad_dns_resoltuions.png" "${L[DNS-Blocking-Automation]}/evidence"
  safe_mv "dns_resource_record_type_results_from_scrapypython_config.png"   "${L[DNS-Blocking-Automation]}/evidence"

  # Firewall Rule Automation (iptables / threat feed IPs)
  safe_mv "ip_block.sh"         "${L[Firewall-Rule-Automation]}/src"
  safe_mv "script_will_update_iptables_filter_rules_with_ip_ranges_from_threat_intelligence_feed.png" "${L[Firewall-Rule-Automation]}/evidence"
  safe_mv "automate_script_to_block_malicious_ip_addresses.png" "${L[Firewall-Rule-Automation]}/evidence"
  safe_mv "set_firewall_block_rules_and_set_remove_duplicates.png" "${L[Firewall-Rule-Automation]}/evidence"
  safe_mv "drop_rules_added_to_ip_address_table.png" "${L[Firewall-Rule-Automation]}/evidence"
  safe_mv "completed_config_for_iptables_by_scripting_automated_scheduling.png" "${L[Firewall-Rule-Automation]}/evidence"

  # Malware Removal Automation
  safe_mv "remove-malware.sh"   "${L[Malware-Removal-Automation]}/src"
  safe_mv "display_malware_to_be_removed_by_modified_bash_script.png" "${L[Malware-Removal-Automation]}/evidence"
  safe_mv "removing_malware.png" "${L[Malware-Removal-Automation]}/evidence"
  safe_mv "confirmed_removal_of_malware_and_set_schedule.png" "${L[Malware-Removal-Automation]}/evidence"

  # SQLMap Enumeration
  safe_mv "enumeration_using_sqlmap.png" "${L[SQLMap-Enumeration]}/evidence"
  safe_mv "enumeration_using_sqlmap_name_of_database_discovered_on_targeted_dbms.png" "${L[SQLMap-Enumeration]}/evidence"
  safe_mv "sqlmap,_tables_for_the_public_database.png" "${L[SQLMap-Enumeration]}/evidence"
  safe_mv "sqlmap_enumeration,_enumeration_of_columns_from_teh_users_table.png" "${L[SQLMap-Enumeration]}/evidence"

  # Directory Traversal
  safe_mv "directory_traveral_navigation_to_the_website_highlighted.png" "${L[Directory-Traversal]}/evidence"
  safe_mv "directory_traveral_shows_traversal_to_customer_information_via_the_webroot.png" "${L[Directory-Traversal]}/evidence"
  safe_mv "directory_traveral_shows_webroot_directory_represented.png" "${L[Directory-Traversal]}/evidence"
  safe_mv "directory_traveral_using_etcpasswd_to_get_admin_id.png" "${L[Directory-Traversal]}/evidence"
  safe_mv "directory_traveral_vulnerability_in_url_proven.png" "${L[Directory-Traversal]}/evidence"

  # Web Recon (Scrapy)
  safe_mv "ScrapyRecon.py"      "${L[Web-Recon-with-Scrapy]}/src"
  safe_mv "using_python_and_scrapy_for_recon_screenshots_for_script_lab.png" "${L[Web-Recon-with-Scrapy]}/evidence"

  # Phishing/Social evidence (include under Wireshark as supporting context)
  safe_mv "target_fooled_by_fake_email_login_failed_but_credia_potentially_captured.png" "${L[Wireshark-Sniffing-Network-Traffic]}/evidence"

  # === Create lab READMEs and update top README
  write_readme "${L[Active-Directory-Enumeration]}" "Active Directory Enumeration (PowerShell)"
  write_readme "${L[DNS-Blocking-Automation]}"      "DNS Blocking Automation"
  write_readme "${L[Firewall-Rule-Automation]}"     "Firewall Rule Automation (iptables)"
  write_readme "${L[Malware-Removal-Automation]}"   "Malware Removal Automation"
  write_readme "${L[Nmap-Recon]}"                   "Nmap Recon & Bash Automation"
  write_readme "${L[Web-Recon-with-Scrapy]}"        "Web Recon with Python Scrapy"
  write_readme "${L[Wireshark-Sniffing-Network-Traffic]}" "Wireshark: Sniffing Network Traffic"
  write_readme "${L[SQLMap-Enumeration]}"           "SQLMap Enumeration"
  write_readme "${L[Directory-Traversal]}"          "Directory Traversal Finding"

  update_top_readme "  * Active Directory Enumeration — \`Technical-Labs/Active-Directory-Enumeration/\`"
  update_top_readme "  * DNS Blocking Automation — \`Technical-Labs/DNS-Blocking-Automation/\`"
  update_top_readme "  * Firewall Rule Automation — \`Technical-Labs/Firewall-Rule-Automation/\`"
  update_top_readme "  * Malware Removal Automation — \`Technical-Labs/Malware-Removal-Automation/\`"
  update_top_readme "  * Nmap Recon & Bash Automation — \`Technical-Labs/Nmap-Recon/\`"
  update_top_readme "  * Web Recon with Python Scrapy — \`Technical-Labs/Web-Recon-with-Scrapy/\`"
  update_top_readme "  * Wireshark: Sniffing Network Traffic — \`Technical-Labs/Wireshark-Sniffing-Network-Traffic/\`"
  update_top_readme "  * SQLMap Enumeration — \`Technical-Labs/SQLMap-Enumeration/\`"
  update_top_readme "  * Directory Traversal — \`Technical-Labs/Directory-Traversal/\`"

  if [[ "$APPLY" -eq 1 ]]; then
    if ! git diff --quiet; then
      git add -A
      git commit -m "Recruiter cleanup: organize labs into folders with src/evidence/docs and READMEs"
      git push -u origin "$work"
      log "✅ Pushed branch: $work. Open a PR into main."
    else
      log "No changes to commit."
    fi
  else
    log "Dry-run complete. If it looks right, run again with: APPLY=1 bash ./recruiter_cleanup.sh"
  fi
}

main
