#!/bin/bash
# scripts/nano-budget-check.sh — 500MB storage budget gate for HALIDE-nano.
set -eu
cd "$(dirname "$0")/.."
TOTAL=$(awk -F'|' '/^\|/ && $3 ~ /Budget/ {next} /^\|/ && $2 ~ /[0-9]+/ && $2 !~ /Budget|TOTAL/ {s+=$3} END {print s+0}' nano/README.md 2>/dev/null)
# Simpler deterministic path: sum the TOTAL-adjacent budget rows in README table.
SUM=$(grep -E '^\| (kernel|Debian|systemd|bridges|ota|recovery|headroom)' nano/README.md | awk -F'|' '{gsub(/[^0-9]/,"",$3); s+=$3} END {print s}')
echo "nano storage used-budget: ${SUM} MiB (cap 500)"
[ "${SUM:-9999}" -le 500 ] && echo "nano-budget: PASS" || { echo "nano-budget: FAIL"; exit 1; }
# package count sanity: keep tiny
N=$(grep -cE '^[a-z0-9-]+$' nano/packages.list)
echo "nano packages: $N (cap 20)"
[ "$N" -le 20 ] || { echo "nano-budget: FAIL package creep"; exit 1; }
