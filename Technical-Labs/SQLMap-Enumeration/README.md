# SQLMap Enumeration & Database Exposure Assessment

**One-Line Summary**  
Assesses database exposure through SQLi to validate application security gaps and remediation needs.

---

## ✅ Objective
Demonstrate SQL injection impact by discovering DBMS, listing tables/columns, and confirming accessible data.

## ✅ Tools & Methods
- SQLMap with safe switches (lab context)
- Targeted enumeration for proof-of-impact

## ✅ What I Did
- Detected DBMS; enumerated schema
- Captured tables/columns evidence
- Mapped results to affected data types

## ✅ Findings / Risk / Outcome
- Verified depth of data exposure
- Prioritized fixes for vulnerable endpoints

## ✅ Remediation / Control Value
- Parameterized queries; least-priv DB accounts
- SDLC gates (code review, SAST/DAST)

## 📁 Evidence & Files
- `evidence/` — `enumeration_using_sqlmap.png`, `enumeration_using_sqlmap_name_of_database_discovered_on_targeted_dbms.png`, `sqlmap,_tables_for_the_public_database.png`, `sqlmap_enumeration,_enumeration_of_columns_from_teh_users_table.png`, `enumerate_sqlmap,_enumeration_of_the_tables_within_the_database.png`
- `docs/` — short write-up
