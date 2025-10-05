#!/usr/bin/env bash
set -euo pipefail

ROOT="Technical-Labs"
APPLY="${APPLY:-0}"
BRANCH="png-lab-sort-$(date +%Y%m%d-%H%M)"
MOVED=0

log(){ printf '[%s] %s\n' "$(date +'%H:%M:%S')" "$*"; }
dry(){ if [[ "$APPLY" -eq 1 ]]; then eval "$*"; else echo "(dry-run) $*"; fi; }

ensure_root() {
  if [[ ! -d .git ]]; then echo "Run from repo root (where .git lives)"; exit 1; fi
  if [[ ! -d "$ROOT" ]]; then echo "Missing $ROOT directory"; exit 1; fi
}

ensure_branch() {
  git fetch --all --prune
  git checkout main >/dev/null 2>&1 || git checkout -B main
  if [[ "$APPLY" -eq 1 ]]; then git checkout -b "$BRANCH"; else log "(dry-run) Would create branch $BRANCH"; fi
}

safe_target() {
  local dest_dir="$1"; local base="$2"
  local candidate="${dest_dir}/${base}"
  if [[ ! -e "$candidate" ]]; then echo "$candidate"; return; fi
  local stem="${base%.*}"; local ext="${base##*.}"
  if [[ "$ext" == "$base" ]]; then
    local n=1; while [[ -e "${dest_dir}/${stem}-${n}" ]]; do n=$((n+1)); done
    echo "${dest_dir}/${stem}-${n}"
  else
    local n=1; while [[ -e "${dest_dir}/${stem}-${n}.${ext}" ]]; do n=$((n+1)); done
    echo "${dest_dir}/${stem}-${n}.${ext}"
  fi
}

move_to() {
  local src="$1"; local dest_dir="$2"
  local base; base="$(basename "$src")"
  dry "mkdir -p \"$dest_dir\""
  local target; target="$(safe_target "$dest_dir" "$base")"
  if [[ "$APPLY" -eq 1 ]]; then
    if git ls-files --error-unmatch "$src" >/dev/null 2>&1; then
      git mv "$src" "$target" && MOVED=$((MOVED+1)) && { log "moved: $src -> $target"; return; }
    fi
    mv "$src" "$target" && MOVED=$((MOVED+1)) && { log "moved: $src -> $target"; return; }
  else
    echo "(dry-run) mv \"$src\" \"$target\""
  fi
}

route_lab() {
  local f; f="$(basename "${1,,}")"
  # Active Directory
  if [[ "$f" =~ ^a_list_of_active_directory_.*\.png$ || "$f" == using_powershell_to_do_active_directory_search.png ]]; then echo "Active-Directory-Enumeration"; return; fi
  # DNS Blocking
  if [[ "$f" == block_dns_resolution_based_on_thread_feed_start.png || "$f" == shows_scrit_that_automatically_retrieve_bad_dns_resoltuions.png || "$f" == dns_resource_record_type_results_from_scrapypython_config.png ]]; then echo "DNS-Blocking-Automation"; return; fi
  # Firewall Automation
  if [[ "$f" == script_will_update_iptables_filter_rules_with_ip_ranges_from_threat_intelligence_feed.png \
     || "$f" == automate_script_to_block_malicious_ip_addresses.png \
     || "$f" == set_firewall_block_rules_and_set_remove_duplicates.png \
     || "$f" == drop_rules_added_to_ip_address_table.png \
     || "$f" == completed_config_for_iptables_by_scripting_automated_scheduling.png \
     || "$f" == automation_of_ip_range_firewall_block_rules_from_a_threat_feed_list_of_ip_address_that_were_used_by_attackers.png ]]; then echo "Firewall-Rule-Automation"; return; fi
  # Malware Removal
  if [[ "$f" == display_malware_to_be_removed_by_modified_bash_script.png || "$f" == removing_malware.png || "$f" == confirmed_removal_of_malware_and_set_schedule.png ]]; then echo "Malware-Removal-Automation"; return; fi
  # Nmap Recon
  if [[ "$f" == scripting_automation_-_nmapanalysis_output.png || "$f" == bash_script_show_target_that_has_both_open_ports.png || "$f" == change_script_to_receive_prompt_to_specify_port_scan.png || "$f" == final_bash_output.png || "$f" == script_change_output.png || "$f" == error_output.png || "$f" == fixed_error_by_removing_-f.png || "$f" == scipting_automation_lab_screenshots.png ]]; then echo "Nmap-Recon"; return; fi
  # Wireshark / tcpdump / AitM
  if [[ "$f" == tcpdump_capturing_100_packets_only_on_icmp.png || "$f" == using_eth0_interface_to_capture_traffic.png || "$f" == capture_traffic_related_to_port_80_and_ftp_using_tcpdump.png || "$f" == wireshark_analyzing_pcap_files.png || "$f" == plaintext_credentials_captured_with_post.png || "$f" == shows_crediatials_were_captured_will_copy_to_file.png || "$f" == target_fooled_by_fake_email_login_failed_but_credia_potentially_captured.png ]]; then echo "Wireshark-Sniffing-Network-Traffic"; return; fi
  # SQLMap
  if [[ "$f" == enumeration_using_sqlmap.png || "$f" == enumeration_using_sqlmap_name_of_database_discovered_on_targeted_dbms.png || "$f" == sqlmap,_tables_for_the_public_database.png || "$f" == sqlmap_enumeration,_enumeration_of_columns_from_teh_users_table.png || "$f" == enumerate_sqlmap,_enumeration_of_the_tables_within_the_database.png ]]; then echo "SQLMap-Enumeration"; return; fi
  # Directory Traversal (typo in filenames handled)
  if [[ "$f" =~ ^directory_traveral_.*\.png$ ]]; then echo "Directory-Traversal"; return; fi
  # Web Recon (Scrapy)
  if [[ "$f" == using_python_and_scrapy_for_recon_screenshots_for_script_lab.png ]]; then echo "Web-Recon-with-Scrapy"; return; fi
  echo ""
}

main() {
  ensure_root
  ensure_branch

  mapfile -t files < <(find . -type f -iname '*.png' \
    -not -path "./${ROOT}/*/evidence/*" \
    -not -path "./.git/*" \
    -printf "%P\n" | sort)

  if [[ "${#files[@]}" -eq 0 ]]; then log "No PNG files to process."; exit 0; fi
  log "Found ${#files[@]} PNG file(s)."

  for rel in "${files[@]}"; do
    case "$rel" in Technical-Labs/*/evidence/*) continue;; esac
    lab="$(route_lab "$rel")"
    if [[ -z "$lab" ]]; then log "SKIP (no rule): $rel"; continue; fi
    dest="${ROOT}/${lab}/evidence"
    move_to "$rel" "$dest"
  done

  if [[ "$APPLY" -eq 1 ]]; then
    if [[ "$MOVED" -gt 0 ]]; then
      git add -A
      git commit -m "Move PNG evidence into matching labs' evidence/ folders"
      git push -u origin "$BRANCH"
      log "✅ Moved $MOVED file(s). Pushed branch: $BRANCH"
    else
      log "No files moved."
    fi
  else
    log "Dry-run complete. To apply: APPLY=1 bash $(basename "$0")"
  fi
}

main "$@"
