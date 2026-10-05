#!/bin/bash
# scripts/sepolicy-pin-check.sh — selinux policy inputs must be pinned (ch.08 §278).
# An unpinned policy input fails like an unpinned builder input fails ch.09 §13.
set -eu
cd "$(dirname "$0")/.."
PINS=security/selinux-pins.md
if [ ! -f "$PINS" ]; then echo "REFUSED: $PINS missing"; exit 2; fi
if grep -nEi "branch: ?main|tag: ?latest|floating|TBD|TODO" "$PINS"; then
  echo "SEPOLICY-PIN-CHECK FAIL: floating or unpinned entry in $PINS"; exit 1
fi
grep -qiE "aosp.*(tag|ASDDA|android1[45])" "$PINS" || { echo "SEPOLICY-PIN-CHECK FAIL: no AOSP tag row"; exit 1; }
echo "SEPOLICY-PIN-CHECK OK"
exit 0
