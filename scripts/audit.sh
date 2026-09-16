#!/usr/bin/env bash
set -euo pipefail

HOST="${1:?Usage: audit.sh hostname [port]}"
PORT="${2:-22}"

RED='\033[0;31m'
GRN='\033[0;32m'
NC='\033[0m'

PASS_COUNT=0
FAIL_COUNT=0

pass() { printf "${GRN}PASS${NC} %s\n" "$1"; PASS_COUNT=$((PASS_COUNT + 1)); }
fail() { printf "${RED}FAIL${NC} %s\n" "$1"; FAIL_COUNT=$((FAIL_COUNT + 1)); }

echo "Auditing SSH on $HOST:$PORT ..."
echo ""

SCAN=$(ssh-keyscan -t rsa,ecdsa,ed25519 -p "$PORT" "$HOST" 2>/dev/null)

if [ -z "$SCAN" ]; then
  echo "Could not connect to $HOST:$PORT"
  exit 1
fi

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

echo ""
echo "Trying remote config check (needs SSH access)..."

CONFIG=$(ssh -o ConnectTimeout=5 -o BatchMode=yes "$HOST" -p "$PORT" "cat /etc/ssh/sshd_config 2>/dev/null" 2>/dev/null || echo "NO_ACCESS")

if [ "$CONFIG" = "NO_ACCESS" ]; then
  echo "Could not read remote sshd_config (no SSH access or permission denied)"
  echo "Showing key scan results only."
  echo ""
  echo "--- $PASS_COUNT passed, $FAIL_COUNT failed ---"
  [ "$FAIL_COUNT" -gt 0 ] && exit 1 || exit 0
fi

echo ""

if echo "$CONFIG" | grep -qi "^PermitRootLogin.*no"; then
  pass "Root login disabled"
elif echo "$CONFIG" | grep -qi "^PermitRootLogin.*prohibit-password"; then
  pass "Root login restricted to key-only"
else
  fail "Root login may be enabled (check PermitRootLogin)"
fi

if echo "$CONFIG" | grep -qi "^PasswordAuthentication.*no"; then
  pass "Password auth disabled"
else
  fail "Password auth may be enabled"
fi

if echo "$CONFIG" | grep -qi "^PermitEmptyPasswords.*yes"; then
  fail "Empty passwords allowed!"
else
  pass "Empty passwords not allowed"
fi

echo ""
echo "--- $PASS_COUNT passed, $FAIL_COUNT failed ---"
[ "$FAIL_COUNT" -gt 0 ] && exit 1 || exit 0
