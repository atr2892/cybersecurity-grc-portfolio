# Directory Traversal

## Overview
Demonstrates exploitation of directory traversal vulnerabilities to access restricted files and validate remediation steps.

## Objective
Identify and test improper input validation in web applications that exposes unauthorized file access.

## Tools & Methods
- **Tools/Scripts:** Burp Suite, curl
- **Techniques:** Path traversal payloads ("../" sequences), file inclusion testing

## Approach
- **Problem:** Web apps with insufficient input sanitization may expose sensitive files.
- **Action:** Tested traversal payloads against vulnerable endpoints, validated responses, and documented proof.
- **Result:** Confirmed access to restricted files and recommended input validation and path normalization as remediation.

## GRC Relevance
- Maps to **OWASP Top 10 (Security Misconfiguration / Broken Access Controls)**.
- Provides audit evidence and remediation steps for secure coding and access controls.

## Artifacts
- 📁 **src/** — payload examples and test scripts
- 📁 **evidence/** — screenshots of exploited endpoints and blocked fixes
- 📁 **docs/** — remediation guidance

