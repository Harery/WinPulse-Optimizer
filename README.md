# WinPulse-Optimizer

> **Next-generation, enterprise-grade Windows 11 tuning for maximum performance with zero guesswork.**

---

| 🚀 | **Why WinPulse-Optimizer?** |
|----|--------------------------------------------------------------------------------------------------------------------------------------|
| **Agentless**      | Pure PowerShell—no installs, no bloat; runnable from an elevated shell, Intune or SCCM. |
| **Self-Healing**   | Auto-creates restore points and warns on failure for bullet-proof rollbacks. |
| **Zero-Touch**     | Fully unattended-capable; exits non-zero on error so your pipelines stay clean. |
| **Observable**     | Logs every action to `%USERPROFILE%\Desktop\SystemOptimizer.log` for audit readiness. |
| **Config-Driven**  | Paths, services and visuals externalised in upcoming releases—no code edits needed. |

![Windows 11](https://img.shields.io/badge/OS-Windows%2011-blue?style=flat-square)
![PowerShell](https://img.shields.io/badge/PowerShell-5%2B-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

## Table of Contents
1. [Features](#features)
2. [Prerequisites](#prerequisites)
3. [Installation](#installation)
4. [Usage](#usage)
5. [Roadmap](#roadmap)
6. [Contributing](#contributing)
7. [License](#license)

---

## Features
- **Privilege Check** – Hard-fails if not elevated, ensuring predictable results.  
- **System Restore Automation** – Creates a restore point before any modification.  
- **Visual-Effects Hardening** – Disables non-essential animations while keeping usability high.  
- **Deep Temp Cleanup** – Clears OS, Edge, Chrome and recycle-bin debris in one pass.  
- **Service Diet** – Disables telemetry and Maps broker for leaner background load.  
- **Extensible Architecture** – JSON-driven cleanup paths and service profiles (roadmap).

---

## Prerequisites
- Windows 11 22H2 or later  
- PowerShell 5.x **or** PowerShell 7.x  
- Administrator privileges

---

## Installation
```powershell
# Clone the repo
git clone https://github.com/<your-user>/WinPulse-Optimizer.git
cd WinPulse-Optimizer
