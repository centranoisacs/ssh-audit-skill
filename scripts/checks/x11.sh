#!/usr/bin/env bash
check_x11_forwarding() {
  local config="$1"
  if echo "$config" | grep -qi "^X11Forwarding.*yes"; then
    fail "X11Forwarding is enabled (disable unless needed)"
  else
    pass "X11Forwarding disabled or not set"
  fi
}
