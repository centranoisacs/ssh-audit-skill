#!/usr/bin/env bash
# Check key exchange algorithms against known-weak list
check_kex() {
  local config="$1"
  local weak_kex="diffie-hellman-group1-sha1 diffie-hellman-group14-sha1 diffie-hellman-group-exchange-sha1"

  local kex_line
  kex_line=$(echo "$config" | grep -i "^KexAlgorithms" | tail -1 | cut -d' ' -f2-)

  if [ -z "$kex_line" ]; then
    pass "KexAlgorithms not explicitly set (using server defaults)"
    return
  fi

  local found_weak=0
  for alg in $weak_kex; do
    if echo "$kex_line" | grep -qi "$alg"; then
      fail "Weak KexAlgorithm enabled: $alg"
      found_weak=1
    fi
  done

  if [ "$found_weak" -eq 0 ]; then
    pass "No weak key exchange algorithms"
  fi
}
