Alison T. Richardson-Howard  
Cybersecurity Specialist | Penetration Tester | Security Automation Engineer

📍 Chicago, IL (Remote-Ready)  
📧 alisonrichardsonhoward@gmail.com  
🔗 LinkedIn · 💻 GitHub

---

## 🎓 Education & Certifications
**M.S. Cybersecurity & Information Assurance** — Western Governors University (in progress)  
CompTIA CySA+, ISC² CC, Google Cybersecurity Professional Certificate  
Currently pursuing: CompTIA PenTest+

---

## 📂 Portfolio Overview
Hands-on labs in a controlled lab environment. Focus: network capture, web app attacks, social engineering/AitM, Active Directory reconnaissance, and defensive automation (DNS sinkholing, firewall rule automation, malware cleanup). Evidence includes redacted screenshots (unredacted screenshots available upon request for verified, authorized reviewers).

---

## Projects

### 🔹 Pentesting Work

#### 🏥 Penetration Testing Engagement Plan Evaluation – Western View Hospital  
*Type: Engagement Analysis & Strategic Recommendations*

**Tools Used:**  
Nmap • Burp Suite • Social Engineering Toolkit (SET) • Vulnerability Scanning

**Summary:**  
Evaluated a penetration testing engagement plan for a healthcare organization, assessing alignment with operational continuity, compliance requirements, and industry best practices.

**Steps Performed:**  
- Reviewed scope for internal, external, and social engineering tests  
- Mapped plan elements to HIPAA, NIST SP 800-115, ISO 27001, PCI DSS, and GDPR controls  
- Evaluated reporting, remediation scoring, and Rules of Engagement for safety and uptime concerns

**Key Takeaway:**  
Actionable recommendations provided to reduce disruption risk, improve compliance coverage, and clarify reporting for both technical and executive stakeholders. *(Redacted document available; unredacted on request with appropriate approvals.)*

---

#### 🛰️ 1) Network Traffic Capture & Analysis  
*Type: Network Forensics Lab*

**Tools Used:**  
tcpdump • Wireshark

**Summary:**  
Captured and analyzed HTTP, FTP, and ICMP traffic to demonstrate how plaintext credentials and sensitive information can be exposed on insecure protocols.

**Steps Performed:**  
- Captured packets with `tcpdump` for HTTP (port 80), FTP, and ICMP traffic  
- Loaded PCAPs into Wireshark for protocol analysis and packet inspection  
- Located and examined HTTP POST requests to identify plaintext credentials

**Key Takeaway:**  
Unencrypted protocols leak credentials in transit — enforce TLS and deprecate insecure services to mitigate credential exposure.

---

#### 🔍 2) Nmap Scripting & Automation  
*Type: Recon Automation Lab*

**Tools Used:**  
Bash • Nmap

**Summary:**  
Developed and debugged an Nmap automation script (`NmapAnalysis.sh`) to streamline recon and handle dual-port scanning and user prompts.

**Steps Performed:**  
- Wrote `NmapAnalysis.sh` with interactive prompts for target and port selection  
- Resolved a `-F` conflict and other script errors to improve reliability  
- Added logic to handle targets with multiple open ports and produced consistent output

**Key Takeaway:**  
Automation speeds reconnaissance while reducing manual errors; robust scripts should handle edge cases and provide clear prompts for repeatable scans.

---

#### 🧩 3) Active Directory Enumeration  
*Type: AD Recon Lab*

**Tools Used:**  
PowerShell

**Summary:**  
Performed Active Directory enumeration to identify domain computers, users, groups, and account details — mapping potential attack surface and privilege relationships.

**Steps Performed:**  
- Queried domain for computer and server listings  
- Enumerated user accounts and group memberships using PowerShell  
- Collected user metadata useful for privilege escalation and lateral-movement analysis

**Key Takeaway:**  
AD enumeration quickly surfaces visibility into access patterns and high-value targets; inventory and least-privilege controls reduce exposure.

---

#### 🛑 4) DNS Blocking Automation  
*Type: Defensive Automation Lab*

**Tools Used:**  
Bash

**Summary:**  
Implemented an automated DNS sinkhole process that retrieves malicious domain feeds and blocks resolution by updating `/etc/hosts`.

**Steps Performed:**  
- Pulled threat feed of malicious domains programmatically  
- Updated `/etc/hosts` to redirect/block listed domains  
- Verified blocked resolution via DNS lookups and resolution checks

**Key Takeaway:**  
A simple DNS sinkhole provides fast mitigation for known-malicious domains, reducing callbacks and limiting user exposure to phishing/malware C2.

---

#### 🔥 5) Firewall Rule Automation  
*Type: Network Hardening Automation*

**Tools Used:**  
Bash • iptables • cron

**Summary:**  
Automated ingestion of CIDR threat feeds to add DROP rules to `iptables`, with duplicate removal and scheduled updates.

**Steps Performed:**  
- Ingested CIDR lists from threat feeds and normalized IP ranges  
- Programmatically updated `iptables` with DROP rules, ensuring de-duplication  
- Scheduled regular updates through `cron` to maintain current protections

**Key Takeaway:**  
Automated firewall updates from trusted threat feeds enable continuous network hardening and reduce manual maintenance overhead.

---

#### 🧹 6) Malware Removal Automation  
*Type: Endpoint Remediation Automation*

**Tools Used:**  
Bash • threat hash feed • cron

**Summary:**  
Built an automated cleanup script that matches file names and known-malware hashes to remove binaries and scheduled periodic scans/cleanup.

**Steps Performed:**  
- Matched local files against a threat-hash feed  
- Removed files identified as malicious and logged actions  
- Scheduled cleanup via `cron` to regularly sweep for known threats

**Key Takeaway:**  
Hash-based removal reduces dwell time for known malware; combine with behavioral detection for broader coverage against unknown threats.

---

#### 🛠️ 7) SQL Injection Enumeration (SQLMap)  
*Type: Web App Vulnerability Lab*

**Tools Used:**  
SQLMap

**Summary:**  
Used SQLMap to detect and exploit SQL injection in a vulnerable application, enumerating database, tables, and columns to demonstrate data exposure.

**Steps Performed:**  
- Ran SQLMap to fingerprint the DBMS and identify injectable parameters  
- Enumerated available databases, tables, and columns  
- Extracted example records to demonstrate impact of SQLi vulnerabilities

**Key Takeaway:**  
SQL injection can yield full database exposure; parameterized queries and input validation are critical defenses.

---

#### 🎯 8) Adversary-in-the-Middle (AitM)  
*Type: Web Proxy / On-Path Attack Lab*

**Tools Used:**  
Burp Suite • Kali Linux • Windows (victim)

**Summary:**  
Performed an on-path interception exercise against OWASP Juice Shop (proxying victim traffic) to capture login POSTs and demonstrate credential theft via AitM techniques.

**Steps Performed:**  
- Configured Burp Suite as an intercepting proxy and adjusted victim browser settings  
- Intercepted and analyzed HTTP POST requests containing credentials  
- Documented the workflow and artifacts demonstrating successful interception

**Key Takeaway:**  
On-path interception combine
