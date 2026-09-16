#!/usr/bin/env bash
# sourced by audit.sh for --help handling
usage() {
  cat <<'EOF'
Usage: audit.sh [options] hostname [port]

Options:
  -h, --help       Show this help
  --no-color       Disable colored output

Checks SSH server configuration for common security issues.
Without SSH access, only host key types are checked.
With SSH access, reads /etc/ssh/sshd_config for full audit.
EOF
  exit 0
}
