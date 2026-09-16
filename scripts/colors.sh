#!/usr/bin/env bash
# sourced by audit.sh — color setup
if [ "${NO_COLOR:-}" = "1" ] || [ "${1:-}" = "--no-color" ]; then
  RED=""
  GRN=""
  YLW=""
  NC=""
else
  RED='\033[0;31m'
  GRN='\033[0;32m'
  YLW='\033[0;33m'
  NC='\033[0m'
fi
