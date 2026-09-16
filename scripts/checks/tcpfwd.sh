#!/usr/bin/env bash
check_tcp_forwarding() {
  local config="$1"
  if echo "$config" | grep -qi "^AllowTcpForwarding.*yes"; then
    fail "AllowTcpForwarding is enabled"
  elif echo "$config" | grep -qi "^AllowTcpForwarding.*no"; then
    pass "AllowTcpForwarding disabled"
  else
    pass "AllowTcpForwarding not set (default varies by distro)"
  fi
}
