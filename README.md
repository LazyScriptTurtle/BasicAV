# 🛡️ BasicAV – PowerShell Antivirus & Honeypot

**BasicAV** is a modular, local host security system primarily written in PowerShell, with selected modules implemented in C for performance and low-level integration.  
The project combines antivirus, honeypot, and lightweight EDR (Endpoint Detection and Response) capabilities by leveraging native Windows features—without requiring any third-party tools.

---

## 🎯 Project Goals

- Provide local Windows protection using native PowerShell and C-based modules  
- Detect malicious files, unauthorized system activity, and port scanning attempts  
- Implement passive port honeypots (via Windows Firewall)  
- Implement file-based honeypots (traps for malware and intruders)  
- Allow integration with logging and alerting systems  

---

## ✅ Current Status

- ✅ Project directory structure developed  
- ✅ Loading and validation of `config.json` with environment variable expansion  
- ✅ Function to verify administrator privileges  
- ✅ Automatic import of all modules from the `Modules` folder  
- ✅ Initial structure of `Start-BasicAV` function  
- ✅ Basic system messages and interactive menu skeleton  

---

## 🛠️ Planned Features

- File and hash scanning engine  
- Port honeypot module  
- File honeypot with access monitoring  
- Centralized logging and alerting system  
- Detection of predefined attack signatures in logs  
- EDR module (process and event collection)  
- CLI panel for system management  
- Integration with external services (SMTP, Syslog, etc.)  

---

## 📋 Requirements

- Windows 10 / 11 / Server  
- PowerShell 5.1 or newer  
- Administrator privileges  

---

## 📄 License

This is an open-source project licensed under the MIT License.

---

## ✍️ Author

Developed out of passion for cybersecurity and PowerShell by **[LazyScriptTurtle]**.
