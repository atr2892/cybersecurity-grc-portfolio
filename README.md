Alison T. Richardson-Howard  
Cybersecurity Specialist | Penetration Tester | Security Automation Engineer

📍 Chicago, IL (Remote-Ready)  
📧 alisonrichardsonhoward@gmail.com  
🔗 LinkedIn · 💻 GitHub

🎓 Education & Certifications  
M.S. Cybersecurity & Information Assurance — Western Governors University (in progress)  
CompTIA CySA+, ISC² CC, Google Cybersecurity Professional Certificate  
Currently pursuing: CompTIA PenTest+

📂 Portfolio Overview  
Hands-on labs in a controlled lab environment. Focus: network capture, web app attacks, social engineering/AitM, AD recon, and defensive automation (DNS sinkholing, firewall rules, malware cleanup). Evidence redacted screenshots included (unredacted screenshots available upon request).

## Projects

### 🔹 Pentesting Work

#### 🏥 Penetration Testing Engagement Plan Evaluation – Western View Hospital  
*Type: Engagement Analysis & Strategic Recommendations*

This project evaluates a penetration testing engagement plan for a healthcare organization and analyzes how well it aligns with compliance requirements, operational needs, and industry standards.

**Focus Areas:**  
- Penetration Testing Methodology  
- Risk & Impact Evaluation  
- HIPAA, GDPR, PCI DSS Alignment  
- NIST SP 800-115 & ISO 27001 Integration  
- Reporting & Remediation Strategy

**Key Contributions:**  
- Assessed scope across internal, external, and social engineering vectors  
- Identified gaps in:
  - Encryption validation  
  - Incident response planning  
  - Backup and disaster recovery  
- Recommended:
  - Clear Rules of Engagement  
  - CVSS 3.1-based severity scoring  
  - Phishing awareness controls  
  - Contingency and rollback procedures

**Tools Referenced:**  
Nmap • Burp Suite • Social Engineering Toolkit (SET) • Vulnerability Scanning • Enumeration • Exploitation • Credential Harvesting

**Outcome:**  
Enhanced compliance coverage, minimized risk of service disruption, and improved reporting clarity for both executive and technical stakeholders.

---

1) Network Traffic Capture & Analysis  
Tools: tcpdump, Wireshark  
Steps: capture HTTP/FTP/ICMP, load PCAPs in Wireshark, verify plaintext POST creds.  
Takeaway: insecure protocols leak credentials; capture + analysis confirms risk.

Wireshark Analyzing Pcap Files Capture Traffic Related To Port 80 And Ftp Using Tcpdump Tcpdump Capturing 100 Packets Only On Icmp Using Eth0 Interface To Capture Traffic Plaintext Credentials Captured With Post

2) Nmap Scripting & Automation  
Tools: Bash, Nmap  
Steps: wrote NmapAnalysis.sh; fixed -F conflict; added prompts & dual-port logic.  
Takeaway: fast recon with reliable, prompt-driven scanning.

Error Output Script Change Output Change Script To Receive Prompt To Specify Port Scan Bash Script Show Target That Has Both Open Ports Scripting Automation - Nmapanalysis Output Scipting Automation Lab Screenshots Fixed Error By Removing -F Final Bash Output

3) Active Directory Enumeration  
Tools: PowerShell  
Steps: enumerated domain computers, users, groups, user details.  
Takeaway: AD recon quickly outlines attack surface & access patterns.

A List Of Active Directory Domain Computers Using Powershell To Do Active Directory Search A List Of Active Directory Domain Groups A List Of Active Directory User Details (no screenshots found) (no screenshots found) (no screenshots found)

4) DNS Blocking Automation  
Tools: Bash  
Steps: pull bad domains, update /etc/hosts, verify resolution blocked.  
Takeaway: quick DNS sinkhole stops callbacks/phishing domains.

Shows Scrit That Automatically Retrieve Bad Dns Resoltuions Block Dns Resolution Based On Thread Feed Start (no screenshots found) (no screenshots found) (no screenshots found)

5) Firewall Rule Automation  
Tools: Bash, iptables, cron  
Steps: ingest CIDR threat feed, add DROP rules, de-dup, schedule with cron.  
Takeaway: automated network hardening with scheduled updates.

Completed Config For Iptables By Scripting Automated Scheduling Script Will Update Iptables Filter Rules With Ip Ranges From Threat Intelligence Feed Drop Rules Added To Ip Address Table Automate Script To Block Malicious Ip Addresses Automation Of Ip Range Firewall Block Rules From A Threat Feed List Of Ip Address That Were Used By Attackers Set Firewall Block Rules And Set Remove Duplicates (no screenshots found)

6) Malware Removal Automation  
Tools: Bash, threat hash feed, cron  
Steps: match filenames+hashes, remove malware binaries, schedule cleanup.  
Takeaway: hash-based removal reduces dwell time for known threats.

Confirmed Removal Of Malware And Set Schedule Removing Malware Display Malware To Be Removed By Modified Bash Script (no screenshots found) (no screenshots found) (no screenshots found)

7) SQL Injection Enumeration (SQLMap)  
Tools: SQLMap  
Steps: detect DBMS, list tables, enumerate columns/records.  
Takeaway: shows full DB exposure from SQLi in vulnerable app.

Enumeration Using Sqlmap Enumeration Using Sqlmap Name Of Database Discovered On Targeted Dbms Sqlmap Enumeration, Enumeration Of Columns From Teh Users Table (no screenshots found) Enumerate Sqlmap, Enumeration Of The Tables Within The Database (no screenshots found)

8) Adversary-in-the-Middle (AitM)  
Tools: Burp Suite (proxy), Kali (attacker), Windows (victim)  
Steps: proxy script changed victim settings; intercepted login POST to Juice Shop.  
Takeaway: on-path interception + social engineering exposes credentials.

Shows Crediatials Were Captured Will Copy To File Target Fooled By Fake Email Login Failed But Credia Potentially Captured Attack Script Created Create An Attack Script

9) Directory Traversal  
Tools: Browser, Burp (optional)  
Steps: manipulate URL to access files (e.g., /etc/passwd), confirm data disclosure.  
Takeaway: improper path handling leads to sensitive file exposure.

Directory Traveral Navigation To The Website Highlighted Directory Traveral Shows Traversal To Customer Information Via The Webroot Directory Traveral Shows Webroot Directory Represented Directory Traveral Using Etcpasswd To Get Admin Id Directory Traveral Vulnerability In Url Proven

10) Scripting & Recon Automation  
Tools: Bash, Python (Scapy/Scrapy), PowerShell  
Steps: built DNS recon, AD search, and Nmap automation; validated outputs and fixed errors.  
Takeaway: automation accelerates triage, recon, and defensive response.

Using Python And Scrapy For Recon Screenshots For Script Lab Final Bash Output Fixed Error By Removing -F
