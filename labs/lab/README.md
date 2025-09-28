# Student Lab: Sniffing Network Traffic

## Objective
Capture network traffic using `tcpdump`, analyze with Wireshark, and document findings.

## Quick Commands
```bash
# list interfaces
tcpdump -D

# capture 100 packets on eth0
sudo tcpdump -i eth0 -c 100

# capture 100 packets with no name/port resolution
sudo tcpdump -i eth0 -c 100 -nn

# capture 100 ICMP packets
sudo tcpdump -i eth0 -c 100 icmp

# capture HTTP traffic to file
sudo tcpdump -i eth0 port 80 -w juiceshop-web.pcap

# capture all traffic to file (for FTP session)
sudo tcpdump -i eth0 -w PC-ftp.pcap

# read pcap
tcpdump -r juiceshop-web.pcap -nn -tt
```

## Analysis (Wireshark)
Open `.pcap` files in Wireshark and use filters such as:
- `ip.src == 10.1.16.66 and http.request.method == POST`
- `ftp`
- `frame contains "PASS"`
- `tcp.port == 21 || tcp.port == 20`
