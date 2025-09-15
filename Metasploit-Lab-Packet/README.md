# Metasploit Exploitation Lab  

## 🔎 Overview  
This lab demonstrates how to use the **Metasploit Framework (MSF)** with **Nmap** and auxiliary modules to identify services, perform scanning, and verify SMB/LDAP information.  

The workflow:  
1. Initialize and connect the MSF database.  
2. Perform reconnaissance with **Nmap** and import results.  
3. Run a **SYN scan** from inside MSF.  
4. Perform an **SMB version scan** for service fingerprinting.  
5. Test LDAP query enumeration.  
6. Exploit ZeroLogon and extract hashes with Impacket.  
7. Perform Pass-the-Hash and gain remote access.  
8. Deliver and execute a Meterpreter payload for reverse shell access.  

---

## 🎯 Objectives  
- Confirm MSF database setup and framework launch.  
- Import Nmap scan results into MSF.  
- Use MSF to run a SYN scan.  
- Use MSF to enumerate SMB versions.  
- Demonstrate LDAP query enumeration.  
- Exploit ZeroLogon with MSF.  
- Use Impacket to dump hashes and perform Pass-the-Hash.  
- Create, deliver, and execute a Meterpreter payload.  

---

## 🛠 Tools Used  
- [Kali Linux](https://www.kali.org/)  
- [Metasploit Framework](https://www.metasploit.com/)  
- [Nmap](https://nmap.org/)  
- [Impacket](https://github.com/fortra/impacket)  

---

## 📊 Summary of Completed Tasks  
- ✅ Database initialized and MSF launched.  
- ✅ Nmap scan executed and imported into MSF DB.  
- ✅ SYN scan executed via MSF.  
- ✅ SMB version scan executed via MSF.  
- ✅ LDAP query tested.  
- ✅ ZeroLogon exploited with MSF.  
- ✅ Hashes dumped with Impacket.  
- ✅ Pass-the-Hash executed successfully.  
- ✅ Meterpreter payload created, delivered, and executed for reverse shell.  

---

## 📂 Portfolio Value  
This project demonstrates:  
- Practical use of Metasploit auxiliary and exploit modules.  
- Integration of **Nmap → MSF → Impacket** workflows.  
- Post-exploitation techniques (hash extraction, pass-the-hash, Meterpreter).  
- Ability to write both technical walkthroughs and client-style reports.  
