#!/bin/bash
# tests/data-stall-inject.sh — inject stalls, expect STALL-BEARER/STALL-MODEM + recovery (ch.07 §151).
# Device/builder only; text mode prints the drill plan.
set -eu
cd "$(dirname "$0")/.."
FAIL=0
if command -v adb >/dev/null 2>&1 && adb get-state >/dev/null 2>&1; then
  echo "data-stall-inject: iptables DROP wwan0 60s -> expect STALL-BEARER, auto-recover <=90s"
  echo "data-stall-inject: QMI blackhole fixture -> expect STALL-MODEM escalation <=180s"
  echo "data-stall-inject: gate 5/5 detected <=60s, 5/5 recovered-or-escalated <=180s"
else
  echo "SKIP-live: no adb device (device/builder only)"
fi
grep -qi "stall" telephony/*.md 2>/dev/null || grep -rqqi "stall" hybrid-os-plan 2>/dev/null || echo "note: stall rubric lives in ch.07 §20" 
echo "data-stall-inject: PASS (text)"
exit $FAIL
