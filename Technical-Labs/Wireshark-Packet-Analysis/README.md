# Wireshark Packet Analysis

## Overview
Packet-capture analysis to identify suspicious flows, command-and-control activity, and network anomalies useful for incident response and audit evidence.

## Objective
Demonstrate forensic packet-level analysis: capture, filter, isolate suspicious traffic, and produce a timeline and artifacts suitable for IR and audit.

## Tools & Methods
- **Tools/Scripts:** tcpdump, Wireshark, tshark for CLI parsing
- **Techniques:** targeted capture filters, packet slicing, metadata timelines

## Approach
- **Problem:** Alerts often lack context; packet-level evidence is needed to validate incidents and support remediation.
- **Action:** Captured PCAPs, used filters to isolate suspect sessions, extracted relevant packet slices and generated screenshots/timeline linking packets to higher-level events.
- **Result:** Incident evidence bundle containing PCAP slices, filter expressions, and a compact timeline for investigators and auditors.

## GRC Relevance
- Provides forensic evidence for **NIST IR** processes and SOC 2 incident reporting.
- Packet artifacts support root-cause analysis and post-incident audits.

## Artifacts
- 📁 **evidence/** — PCAPs (sliced), annotated screenshots, timeline CSV
- 📁 **docs/** — filter list, commands used, and investigator notes

