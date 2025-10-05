# Nmap Recon & Bash Automation

**One-Line Summary**  
Performs automated asset and service discovery to surface unmanaged risk and misconfigurations.

---

## ✅ Objective
Automate recon to produce consistent baselines and detect unexpected exposures.

## ✅ Tools & Methods
- Bash + Nmap (`NmapAnalysis.sh`)
- Prompted inputs; error handling; dual-port logic

## ✅ What I Did
- Scanned targets (fast/full); normalized outputs
- Fixed `-F` conflict; added prompts & logic
- Captured outputs and error/fix evidence

## ✅ Findings / Risk / Outcome
- Identified exposed services/anomalies
- Improved repeatability for assessments

## ✅ Remediation / Control Value
- Feed exposures to vuln management
- Track service changes over time

## 📁 Evidence & Files
- `src/` — `NmapAnalysis.sh`
- `evidence/` — `scripting_automation_-_nmapanalysis_output.png`, `bash_script_show_target_that_has_both_open_ports.png`, `change_script_to_receive_prompt_to_specify_port_scan.png`, `final_bash_output.png`, `script_change_output.png`, `error_output.png`, `fixed_error_by_removing_-f.png`, `scipting_automation_lab_screenshots.png`
- `docs/` — SOP/notes
