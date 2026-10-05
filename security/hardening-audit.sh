#!/bin/bash
# security/hardening-audit.sh — cross-cutting hardening posture check (ch.08).
# Exit 0 pass / 1 fail / 2 skip.
set -eu
cd "$(dirname "$0")/.."
FAIL=0
chk() { if eval "$2"; then echo "OK: $1"; else echo "FAIL: $1"; FAIL=1; fi; }
chk "default-deny container egress (nftables)"      "grep -q 'policy drop' debian/nftables.conf"
chk "tor kill-switch profile present"               "[ -f debian/nftables-tor.conf ]"
chk "no private key material committed"             "! grep -rl 'BEGIN.*PRIVATE KEY' keys/ --include='*.pem' --include='*.key' | grep ."
chk "prop allowlist is the consent source"          "[ -f bridges/prop-allowlist.txt ] && [ \$(wc -l < bridges/prop-allowlist.txt) -lt 100 ]"
chk "telemetry off when declined (allowlist exists)" "[ -f security/egress-allowlist.txt ]"
chk "apparmor container profile present"            "ls debian/apparmor-lxc-android/* >/dev/null 2>&1 || ls debian/apparmor.d | grep -q lxc"
chk "seccomp policy for container"                  "ls debian/lxc-seccomp.policy >/dev/null 2>&1"
chk "release keys public-only"                      "! grep -rIl 'PRIVATE KEY' keys/ | grep -v '\.md$' | grep ."
[ "$FAIL" = 0 ] && echo "HARDENING-AUDIT PASS" || exit 1
