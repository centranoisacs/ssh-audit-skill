#!/usr/bin/env bash
check_client_alive() {
  local config="$1"
  local interval
  interval=$(echo "$config" | grep -i "^ClientAliveInterval" | awk '{print $2}')

  if [ -z "$interval" ] || [ "$interval" -eq 0 ] 2>/dev/null; then
    fail "ClientAliveInterval not set or 0 (idle sessions never disconnect)"
  else
    pass "ClientAliveInterval set to ${interval}s"
  fi
}
