# DNS Blocking Automation

**One-Line Summary**  
Automates malicious domain blocking to prevent callbacks and reduce threat exposure.

---

## ✅ Objective
Convert domain IOCs into **resolver-level blocks** (hosts/sinkhole) and verify prevention.

## ✅ Tools & Methods
- Bash/Python: `block-DNS.sh`, `AutoDNS.py`
- Feed ingestion; hosts/sinkhole updates; verification

## ✅ What I Did
- Pulled domains from feed(s)
- Updated resolver to **deny resolution**
- Verified blocks & captured proof

## ✅ Findings / Risk / Outcome
- Callback attempts **denied** at DNS layer
- Lowered phishing/C2 exposure

## ✅ Remediation / Control Value
- Schedule updates; integrate lookups with SIEM alerts
- Pair with egress filtering for layered control

## 📁 Evidence & Files
- `src/` — `block-DNS.sh`, `AutoDNS.py`
- `evidence/` — `block_dns_resolution_based_on_thread_feed_start.png`, `shows_scrit_that_automatically_retrieve_bad_dns_resoltuions.png`, `dns_resource_record_type_results_from_scrapypython_config.png`
- `docs/` — summary + feed sources
