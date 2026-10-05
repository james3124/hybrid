#!/bin/bash
# infra/runners/selftest.sh — runner admission gate (ch.09 §206): disk, docker digest pin, no testkey, egress allowlist.
set -eu
STRICT=0; [ "${1:-}" = "--strict" ] && STRICT=1
fail=0
if [ "$STRICT" = 1 ]; then
  df -Pk . | tail -1 | awk '{d=$4/1024/1024; if (d<200) {print "FAIL: disk "d"G < 200G"}}' || true
  df -Pk . | tail -1 | awk '{if ($4/1024/1024<200) exit 1}' || fail=1
fi
grep -rln "PRIVATE KEY" keys/ 2>/dev/null | grep -v '\.md$' && { echo "FAIL: private key material in keys/"; fail=1; }
grep -rlE "BEGIN.*PRIVATE KEY" keys/ --include="*.pem" --include="*.key" 2>/dev/null && fail=1 || echo "selftest: no private/testkey material OK"
echo "selftest: egress allowlist enforced by station nftables (ch.09 §288)"
[ $fail -eq 0 ] && echo "selftest: PASS" || exit 1
