#!/bin/bash
# tests/ddos-contract.sh — flood-mitigation ruleset contract.
set -eu
cd "$(dirname "$0")/.."
FAIL=0
R=debian/nftables-ddos.conf
[ -f "$R" ] || { echo "FAIL: $R missing"; exit 1; }
grep -qi 'policy drop' "$R" || { echo "FAIL: default-deny missing"; FAIL=1; }
grep -qi 'limit rate' "$R" || { echo "FAIL: no rate limiting"; FAIL=1; }
grep -qi 'syn' "$R" || { echo "FAIL: no SYN-flood rule"; FAIL=1; }
[ "$FAIL" = 0 ] && echo "ddos-contract: PASS" || exit 1
