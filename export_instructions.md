# Export & Redaction Instructions (safe sharing)

**Important:** Before adding artifacts to a public repository, redact any cleartext credentials and sensitive host/real-world IPs.

## Redacting Burp/HTTP exports (HAR)
- Export HAR: Burp -> Proxy -> HTTP history -> Select entries -> right-click -> Save selected items -> export HAR.
- To redact passwords in a HAR (if postData is JSON), you can use `jq` (example):

```bash
jq '(.log.entries[] | select(.request.url|test("rest/user/login"))).request.postData.text |= sub("(?i)\"password\"\s*:\s*\"[^\"]+\""; ""password":"<REDACTED>"")' burp_http_history.har > burp_http_history_redacted.har
```

## Redacting raw request/response text files
- Open the saved raw request in a text editor and replace password values with `<REDACTED>`.

## Redacting screenshots
- Use an image editor (GIMP, Paint.NET, or built-in OS tools) to blur or overlay `REDACTED` on any visible credentials or PII.

## Redacting pcaps
- pcaps may contain plaintext credentials; remove or truncate packets that contain credential data, OR do not publish the pcap. If you must publish, create a filtered pcap that omits sensitive traffic:

```bash
# Remove traffic to/from the victim IP (if it contains credentials)
tcpdump -r original.pcap 'not host 10.1.16.20' -w filtered_no_victim.pcap
```

## General guidance
- When in doubt, do not publish raw artifacts publicly. Use private repos or provide redacted exports only.
