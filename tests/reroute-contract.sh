#!/bin/bash
# tests/reroute-contract.sh — reroute (tor) mode text-level contract.
# Exit 0 pass / 1 fail / 2 skip.
set -eu
cd "$(dirname "$0")/.."
FAIL=0
[ -f debian/nftables-tor.conf ] || { echo "FAIL: debian/nftables-tor.conf missing"; FAIL=1; }
grep -qi "halide-tor-kill" debian/nftables-tor.conf || { echo "FAIL: tor kill-switch marker missing"; FAIL=1; }
grep -qiE 'policy drop' debian/nftables-tor.conf || { echo "FAIL: tor profile must be default-deny"; FAIL=1; }
grep -qi "9040" debian/nftables-tor.conf || { echo "FAIL: TransPort 9040 rule missing"; FAIL=1; }
python3 - <<'PY' || FAIL=1
import sys; sys.path.insert(0, "bridges")
import netd_bridge
assert netd_bridge.handle("MODE tor\n") == "OK mode:tor\n"
assert netd_bridge.handle("DNS 1.1.1.1\n").startswith("ERR dns-via-tor-only")
assert netd_bridge.handle("MODE vpn\n") == "OK mode:vpn\n"
PY
[ "$FAIL" = 0 ] && echo "reroute-contract: PASS" || exit 1
