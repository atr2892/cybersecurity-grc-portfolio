# DNS Blocking Automation

## Overview
Automates malicious domain blocking at the resolver layer to prevent callbacks, disrupt phishing/C2 channels, and reduce threat exposure.  

## Objective
Convert threat feed domain IOCs into resolver-level blocks (hosts/sinkhole) and verify that prevention controls are working.  

## Tools & Methods
- **Scripts:** `block-DNS.sh`, `AutoDNS.py`  
- **Techniques:** IOC feed ingestion, hosts/sinkhole updates, verification of domain blocking  

## Approach
- **Problem:** Malicious domains (from threat intel feeds) can bypass detection and lead to callbacks or exfiltration.  
- **Action:** Pulled domains from feeds, updated resolver configuration to deny resolution, and verified blocks with proof artifacts.  
- **Result:** DNS-layer blocking successfully denied callbacks and reduced phishing/C2 exposure.  

## GRC Relevance
- Supports **NIST CSF PR.DS-1 (Data-at-Rest Protection)** and **DE.CM-1 (Monitoring Network for Anomalies)**.  
- Demonstrates preventive and detective controls for audit evidence.  
- Adds compensating control value when paired with egress filtering and SIEM integration.  

## Artifacts
- 📁 **src/** — Scripts (`block-DNS.sh`, `AutoDNS.py`)  
- 📁 **evidence/** — Screenshots showing domain resolution blocks and verification  
- 📁 **docs/** — Lab summary + feed source documentation  
