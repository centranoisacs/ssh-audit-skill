---
name: ssh-audit-skill
description: Audits SSH server configuration for security issues. Use when asked to check SSH hardening, audit a server's SSH setup, or verify sshd_config settings.
compatibility: Requires ssh and ssh-keyscan CLI tools.
---

## When to use

- User asks to "check SSH security" or "audit SSH config"
- User mentions hardening a server
- User asks about weak ciphers, key exchange, or SSH settings
- User wants to verify a server meets compliance baselines (CIS, NIST)

## What this does

Connects to a remote host via ssh-keyscan (no auth needed) and optionally reads /etc/ssh/sshd_config (needs SSH access) to check for:
- Weak host key types (RSA without Ed25519)
- Root login enabled
- Password authentication enabled
- Empty passwords allowed
- Weak key exchange algorithms
- Weak ciphers and MACs
- Missing idle timeout (ClientAliveInterval)
- Excessive auth retries (MaxAuthTries)
- X11/TCP forwarding enabled unnecessarily

## Usage

```
scripts/audit.sh <hostname> [port]
```

## Example output

```
PASS Ed25519 host key present
FAIL RSA host key still offered (weak if < 3072 bits)
PASS Root login disabled
PASS Password auth disabled
PASS Empty passwords not allowed

--- 4 passed, 1 failed ---
```
