#!/usr/bin/env bash
# JSON output helpers — sourced by audit.sh when --json is passed
JSON_RESULTS=()

json_pass() {
  JSON_RESULTS+=("{"status":"pass","check":"$1","detail":"$2"}")
}

json_fail() {
  JSON_RESULTS+=("{"status":"fail","check":"$1","detail":"$2"}")
}

json_print() {
  local first=1
  printf "["
  for r in "${JSON_RESULTS[@]}"; do
    [ "$first" -eq 0 ] && printf ","
    printf "%s" "$r"
    first=0
  done
  printf "]\n"
}
