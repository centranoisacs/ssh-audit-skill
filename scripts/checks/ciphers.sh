#!/usr/bin/env bash
# Check ciphers against known-weak list
check_ciphers() {
  local config="$1"
  local weak_ciphers="3des-cbc arcfour arcfour128 arcfour256 blowfish-cbc cast128-cbc"

  local cipher_line
  cipher_line=$(echo "$config" | grep -i "^Ciphers" | tail -1 | cut -d' ' -f2-)

  if [ -z "$cipher_line" ]; then
    pass "Ciphers not explicitly set (using server defaults)"
    return
  fi

  local found_weak=0
  for c in $weak_ciphers; do
    if echo "$cipher_line" | grep -qi "$c"; then
      fail "Weak cipher enabled: $c"
      found_weak=1
    fi
  done

  if [ "$found_weak" -eq 0 ]; then
    pass "No weak ciphers configured"
  fi
}
