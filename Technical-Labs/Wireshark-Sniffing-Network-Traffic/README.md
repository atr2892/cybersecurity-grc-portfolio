# Network Traffic Analysis (Wireshark / tcpdump)

**One-Line Summary**  
Validates data-in-transit risks by identifying insecure protocols and exposed credentials.

---

## ✅ Objective
Capture and analyze traffic to confirm encryption posture and detect plaintext credentials/sensitive data in transit.

## ✅ Tools & Methods
- `tcpdump`, Wireshark (filters for HTTP/FTP/ICMP, TLS handshake review)
- PCAP review with redacted screenshots

## ✅ What I Did
- Captured protocol-specific traffic (HTTP/FTP/ICMP)
- Verified **plaintext POST credentials** on legacy endpoints
- Documented filters and findings

## ✅ Findings / Risk / Outcome
- Confirmed insecure services & credential exposure
- Inputs to hardening plan and control verification

## ✅ Remediation / Control Value
- Enforce TLS/HSTS; deprecate legacy protocols
- IDS/NSM rules for credential leakage

## 📁 Evidence & Files
- `evidence/` — `wireshark_analyzing_pcap_files.png`, `capture_traffic_related_to_port_80_and_ftp_using_tcpdump.png`, `tcpdump_capturing_100_packets_only_on_icmp.png`, `using_eth0_interface_to_capture_traffic.png`, `plaintext_credentials_captured_with_post.png`, `target_fooled_by_fake_email_login_failed_but_credia_potentially_captured.png`, `shows_crediatials_were_captured_will_copy_to_file.png`
- `docs/` — PCAP notes / summary
