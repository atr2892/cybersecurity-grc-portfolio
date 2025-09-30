# Cybersecurity Portfolio — Alison T. Richardson‑Howard

**Cybersecurity Specialist / Penetration Tester**

Welcome to my hands-on cybersecurity portfolio. This repository collects practical labs and reports demonstrating penetration testing techniques, network forensics, and web application security assessments performed in isolated lab environments.

## Labs included
- [Nmap NSE Lab](labs/nmap-nse-lab) — Service enumeration and automated script-based reconnaissance with Nmap Scripting Engine.
- [SQLMap Lab](labs/sqlmap-lab) — Evaluation of database security using SQLMap to enumerate DBMS and extract data.
- [Tcpdump Capture Lab](labs/tcpdump-lab) — Network traffic capture and analysis of HTTP/FTP traffic using tcpdump and Wireshark.
- [Adversary-in-the-Middle (AitM) Lab](labs/aitm-lab) — Simulated BEC phishing and on-path interception to capture web credentials.


## How this repo is organized
Each lab follows a consistent structure:
- `README.md` — short overview, objectives, and tools used.
- `report.pdf` — detailed redacted report (where available).
- `evidence/` — screenshots and sanitized artifacts (sensitive data redacted or removed for public sharing).
- `scripts/` — any scripts used during the lab (safe examples only).

## Notes on safety and redaction
Some labs contain sensitive artifacts (screenshots, HAR files, pcaps). Before publishing publicly, ensure no cleartext credentials or private data are included. Where needed, artifacts have been redacted; originals are kept locally but not recommended for public repositories.
