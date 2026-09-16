#!/usr/bin/env bash
check_log_level() {
  local config="$1"
  local level
  level=$(echo "$config" | grep -i "^LogLevel" | awk '{print $2}' | tr '[:lower:]' '[:upper:]')

  if [ -z "$level" ]; then
    pass "LogLevel not set (default INFO)"
  elif [ "$level" = "QUIET" ] || [ "$level" = "FATAL" ] || [ "$level" = "ERROR" ]; then
    fail "LogLevel is $level (too low — authentication failures may be hidden)"
  elif [ "$level" = "VERBOSE" ] || [ "$level" = "DEBUG" ]; then
    pass "LogLevel set to $level"
  else
    pass "LogLevel set to $level"
  fi
}
