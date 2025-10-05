# Splunk Detections & Controls

**Purpose (GRC):** Show how detections validate controls & surface threats.

## Control efficacy & threat examples
- DNS sinkhole blocks known-bad domains → see `evidence/`
- Firewall DROP rules apply to threat ranges → see `evidence/`

## Suggested searches to add
- Suspicious DNS resolutions to deny-listed domains
- New local admin membership
- Multiple failed logins followed by success

> Next: commit 2–3 saved searches and a short “What to do when it fires” note.
