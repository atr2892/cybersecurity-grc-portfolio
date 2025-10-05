# Active Directory Enumeration

**One-Line Summary**  
Implements access discovery to identify privilege exposure and support IAM risk reduction.

---

## ✅ Objective
Inventory **computers, users, groups, and user details** to surface unnecessary privilege and inform least-privilege remediation.

## ✅ Tools & Methods
- PowerShell: `GetADComps.ps1`, `GetADUsers.ps1`, `GetADGroups.ps1`, `GetADUsersDetails.ps1`
- Exported listings as audit evidence

## ✅ What I Did
- Queried domain **computers**, **groups**, **users**, and **user details**
- Captured evidence of enumeration and relationships

## ✅ Findings / Risk / Outcome
- Clear map of identities & memberships
- Candidates for **privilege reduction** and monitoring identified

## ✅ Remediation / Control Value
- Enforce **least privilege** + periodic access reviews
- Alert on creation/assignment of privileged groups

## 📁 Evidence & Files
- `src/` — PowerShell scripts
- `evidence/` — `a_list_of_active_directory_domain_computers.png`, `a_list_of_active_directory_domain_groups.png`, `a_list_of_active_directory_user_details.png`, `using_powershell_to_do_active_directory_search.png`
- `docs/` — notes/CSV exports
