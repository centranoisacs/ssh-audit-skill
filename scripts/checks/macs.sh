#!/usr/bin/env bash
# Check MAC algorithms against known-weak list
check_macs() {
  local config="$1"
  local weak_macs="hmac-md5 hmac-sha1 umac-64 hmac-md5-96 hmac-sha1-96"

  local mac_line
  mac_line=$(echo "$config" | grep -i "^MACs" | tail -1 | cut -d' ' -f2-)

  if [ -z "$mac_line" ]; then
    pass "MACs not explicitly set (using server defaults)"
    return
  fi

  local found_weak=0
  for m in $weak_macs; do
    if echo "$mac_line" | grep -qi "\b${m}\b"; then
      fail "Weak MAC enabled: $m"
      found_weak=1
    fi
  done

  if [ "$found_weak" -eq 0 ]; then
    pass "No weak MAC algorithms configured"
  fi
}
