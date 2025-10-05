# Firewall Rule Automation

**One-Line Summary**  
Transforms threat intelligence into enforced network controls to harden perimeter defenses.

---

## ✅ Objective
Ingest IP/CIDR threat feeds and automatically enforce **DROP** rules with de-duplication and scheduling.

## ✅ Tools & Methods
- Bash + `iptables` (cron for refresh)
- Idempotent updates, deduplication

## ✅ What I Did
- Pulled hostile IP ranges from feed(s)
- Added/updated DROP rules; removed duplicates
- Scheduled rule refresh and captured verification

## ✅ Findings / Risk / Outcome
- Reduced unwanted inbound/outbound connectivity
- Repeatable **control enforcement** with audit trail

## ✅ Remediation / Control Value
- Integrate with change management
- Tune allowlists; ship counters to SIEM

## 📁 Evidence & Files
- `src/` — `ip_block.sh`
- `evidence/` — `completed_config_for_iptables_by_scripting_automated_scheduling.png`, `script_will_update_iptables_filter_rules_with_ip_ranges_from_threat_intelligence_feed.png`, `drop_rules_added_to_ip_address_table.png`, `automate_script_to_block_malicious_ip_addresses.png`, `automation_of_ip_range_firewall_block_rules_from_a_threat_feed_list_of_ip_address_that_were_used_by_attackers.png`, `set_firewall_block_rules_and_set_remove_duplicates.png`
- `docs/` — runbook/notes
