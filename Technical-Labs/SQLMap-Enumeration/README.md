# SQLMap Enumeration

## Overview
Automated SQL injection discovery and controlled exploitation in a test environment to validate application-level controls and produce remediation guidance.

## Objective
Validate web app input validation and demonstrate impact of SQL injection for remediation prioritization.

## Tools & Methods
- **Tools/Scripts:** SQLMap, Burp Suite
- **Techniques:** Parameter fuzzing, controlled data extraction

## Approach
- **Problem:** Unvalidated input can permit SQL injection leading to data exposure.
- **Action:** Identified parameters and ran SQLMap in safe, controlled mode to enumerate schema and sample rows.
- **Result:** Evidence of SQLi and remediation checklist for developers.

## GRC Relevance
- Maps to **PCI DSS** and **OWASP** remediation expectations.
- Supplies evidence for application security testing and risk registers.

## Artifacts
- 📁 **src/** — command examples
- 📁 **evidence/** — sanitized output logs
- 📁 **docs/** — remediation checklist

