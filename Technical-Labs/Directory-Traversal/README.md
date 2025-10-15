# Directory Traversal Vulnerability Assessment

**One-Line Summary**  
Demonstrates unauthorized file access to expose input handling and access control failures.

---

## ✅ Objective
Prove path traversal by accessing files outside intended directories (e.g., `/etc/passwd`).

## ✅ Tools & Methods
- Browser / Burp request manipulation
- Crafted `../` payloads, captured outputs

## ✅ What I Did
- Built traversal payloads and navigated webroot
- Accessed sensitive system files and recorded evidence

## ✅ Findings / Risk / Outcome
- Confirmed insufficient path normalization/authorization
- Validated **sensitive data exposure** via traversal

## ✅ Remediation / Control Value
- Normalize/validate paths server-side
- Restrict filesystem reads; add WAF patterns & auth checks

## 📁 Evidence & Files
- `evidence/` — `directory_traveral_navigation_to_the_website_highlighted.png`, `directory_traveral_shows_traversal_to_customer_information_via_the_webroot.png`, `directory_traveral_shows_webroot_directory_represented.png`, `directory_traveral_using_etcpasswd_to_get_admin_id.png`, `directory_traveral_vulnerability_in_url_proven.png`
- `docs/` — short report for defect ticket
