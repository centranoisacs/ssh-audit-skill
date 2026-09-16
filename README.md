# ssh-audit-skill

Agent skill that audits SSH server configurations for security issues.

Checks host key types, root login, password auth, and other common misconfigurations.

## Usage

```bash
scripts/audit.sh hostname [port]
```

## What it checks

- Host key types (Ed25519 recommended, RSA flagged)
- Root login settings
- Password authentication
- Empty password policy

## As an Agent Skill

This is an [Agent Skill](https://github.com/agentskills/agentskills). Drop the folder in your skills directory and ask the agent to audit a server's SSH config.

## Related

Built as a security companion to [server-health-check](https://github.com/centranoisacs/server-health-check).
