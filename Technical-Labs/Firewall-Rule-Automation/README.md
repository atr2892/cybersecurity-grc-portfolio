# Firewall Rule Automation

## Overview
Automated firewall rule creation and updates with logging and rollback support to maintain network filtering controls and provide audit evidence.

## Objective
Implement scripted firewall automation to enforce block/allow rules consistently and produce change logs for auditors.

## Tools & Methods
- **Tools/Scripts:** iptables, Bash scripting
- **Techniques:** Idempotent rule application, logging, rollback testing

## Approach
- **Problem:** Manual firewall management leads to configuration drift and audit headaches.
- **Action:** Developed scripts to apply, log, and rollback firewall rules; tested changes and recorded evidence.
- **Result:** Automated blocklist management with audit logs and reduced manual error.

## GRC Relevance
- Demonstrates control over network filtering (NIST SC-7 / ISO A.13) and provides auditable change records for compliance.
- Useful evidence for network security and access-control assessments.

## Artifacts
- 📁 **src/** — automation scripts
- 📁 **evidence/** — sample logs and change history
- 📁 **docs/** — usage and rollback instructions

