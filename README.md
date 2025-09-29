# Structureality — AitM (Adversary-in-the-Middle) Lab Package
**Purpose:** GitHub-ready package for a completed penetration test lab demonstrating an on-path (AitM) credential capture via social engineering.  
**Notes:** All sensitive data (passwords, full artifacts containing cleartext credentials) MUST be redacted before publishing publicly. This package contains a redacted report and placeholders for the original evidence. Replace placeholder files with your sanitized artifacts before pushing to GitHub.

## What this repo contains
- `REPORT.md` — Redacted lab report (detailed findings, timeline, remediation).
- `README.md` — This file.
- `scripts/newproxy.bat` — Example attack script (lab-only; contains no real attacker addresses).
- `commands.txt` — Commands and notes used during the test.
- `evidence/` — Folder with placeholders and guidance (do **not** include raw credentials).
- `export_instructions.md` — How to export & redact Burp/pcap for sharing.
- `LICENSE` — MIT (change if needed).

## Quick publishing checklist (before you push to a public repo)
1. **Redact credentials** from any Burp exports, HAR, screenshots, or pcap files. See `export_instructions.md`.  
2. **Replace** the placeholder files in `/evidence` with sanitized/redacted artifacts (or remove them if you cannot safely sanitize).  
3. Confirm no private keys, real usernames or production IPs remain.  
4. Consider making the repository private if you must include less-sanitized artifacts.  

