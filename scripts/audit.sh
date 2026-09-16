#!/usr/bin/env bash
set -euo pipefail

HOST="${1:?Usage: audit.sh hostname}"
PORT="${2:-22}"

RED='\033[0;31m'
GRN='\033[0;32m'
NC='\033[0m'

pass() { printf "${GRN}PASS${NC} %s\n" "$1"; }
fail() { printf "${RED}FAIL${NC} %s\n" "$1"; }

echo "Auditing SSH on $HOST:$PORT ..."
echo ""

# grab server key exchange info
SCAN=$(ssh-keyscan -t rsa,ecdsa,ed25519 -p "$PORT" "$HOST" 2>/dev/null)

if [ -z "$SCAN" ]; then
  echo "Could not connect to $HOST:$PORT"
  exit 1
fi

# check key types offered
if echo "$SCAN" | grep -q "ssh-ed25519"; then
  pass "Ed25519 host key present"
else
  fail "No Ed25519 host key — consider generating one"
fi

if echo "$SCAN" | grep -q "ssh-rsa"; then
  fail "RSA host key still offered (weak if < 3072 bits)"
else
  pass "No RSA host key"
fi

# try to grab sshd config remotely (needs access)
echo ""
echo "Trying remote config check (needs SSH access)..."

CONFIG=$(ssh -o ConnectTimeout=5 -o BatchMode=yes "$HOST" -p "$PORT" "cat /etc/ssh/sshd_config 2>/dev/null" 2>/dev/null || echo "NO_ACCESS")

if [ "$CONFIG" = "NO_ACCESS" ]; then
  echo "Could not read remote sshd_config (no SSH access or permission denied)"
  echo "Showing key scan results only."
  exit 0
fi

echo ""

# PermitRootLogin
if echo "$CONFIG" | grep -qi "^PermitRootLogin.*no"; then
  pass "Root login disabled"
elif echo "$CONFIG" | grep -qi "^PermitRootLogin.*prohibit-password"; then
  pass "Root login restricted to key-only"
else
  fail "Root login may be enabled (check PermitRootLogin)"
fi

# PasswordAuthentication
if echo "$CONFIG" | grep -qi "^PasswordAuthentication.*no"; then
  pass "Password auth disabled"
else
  fail "Password auth may be enabled"
fi

# PermitEmptyPasswords
if echo "$CONFIG" | grep -qi "^PermitEmptyPasswords.*yes"; then
  fail "Empty passwords allowed!"
else
  pass "Empty passwords not allowed"
fi

echo ""
