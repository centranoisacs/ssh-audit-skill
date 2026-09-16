---
name: ssh-audit-skill
description: Audits SSH server configuration for security issues. Use when asked to check if a server's SSH setup is hardened or has weak settings.
compatibility: Requires ssh and ssh-keyscan CLI tools.
---

## What this does

Connects to a remote host and checks SSH configuration for common security problems:
- Weak key exchange algorithms
- Weak ciphers
- Weak MACs
- Root login enabled
- Password auth enabled when it shouldn't be

## Usage

```
scripts/audit.sh <hostname>
```

Reports findings as PASS / FAIL with a short explanation for each check.
