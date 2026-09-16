#!/usr/bin/env bash
check_max_auth_tries() {
  local config="$1"
  local val
  val=$(echo "$config" | grep -i "^MaxAuthTries" | awk '{print $2}')

  if [ -z "$val" ]; then
    fail "MaxAuthTries not set (default 6 — consider lowering to 3-4)"
  elif [ "$val" -le 4 ]; then
    pass "MaxAuthTries set to $val"
  else
    fail "MaxAuthTries is $val (consider lowering to 3-4)"
  fi
}
