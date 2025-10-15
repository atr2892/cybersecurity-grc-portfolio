# DNS Blocking Automation

## Overview
Automates malicious domain blocking at the resolver layer to prevent callbacks, disrupt phishing/C2 channels, and reduce threat exposure.

## Objective
Convert threat feed domain IOCs into resolver-level blocks (hosts/sinkhole) and verify that prevention controls are working.

## Tools & Methods
- **Scripts:** block-DNS.sh, AutoDNS.py
- **Techniques:** Feed ingestion, hosts/sinkhole updates, verification

## Approach
- **Problem:** Malicious domains can lead to callbacks and exfiltration.
- **Action:** Pulled domains from feeds, updated resolver to deny resolution, and verified blocks.
- **Result:** Successful DNS-layer blocking and reduced exposure.

## GRC Relevance
- Supports monitoring and prevention controls; useful for audit evidence when paired with SIEM and egress filtering.

## Artifacts
- 📁 **src/** — scripts
- 📁 **evidence/** — screenshots & verification
- 📁 **docs/** — feed sources and summary

