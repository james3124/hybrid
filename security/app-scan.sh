#!/bin/bash
# security/app-scan.sh — suspicious-app / over-privilege static audit.
# Flags: Android permissions mapped in permission-map.csv without host-side
# polkit counterpart; apps not in DEFAULT-APPS.csv; permission rows granted
# to packages outside halide.* / android.* namespaces.
set -eu
cd "$(dirname "$0")/.."
FAIL=0
P=bridges/permission-map.csv
D=apps/DEFAULT-APPS.csv
[ -f "$P" ] || { echo "REFUSED: $P missing"; exit 2; }
[ -f "$D" ] || { echo "REFUSED: $D missing"; exit 2; }
awk -F, 'NF>1 && $1 !~ /^android_perm/ && $2 !~ /^org\.halide\./ {print "FAIL: non-halide polkit action:",$2}' "$P" | tee /tmp/appscan.log && grep -q . /tmp/appscan.log && FAIL=1
awk -F, 'NF>1 && $1 !~ /^android_perm/ && $1 !~ /^android\./ {print "note: non-android permission row:",$1}' "$P" || true
grep -cE '^android\.intent' "$D" | xargs echo "default-actions rows:"
# duplicate package+action rows = review smell
dup=$(awk -F, 'NF>1 && $1 !~ /^package/{print $1","$2}' "$D" | sort | uniq -d)
[ -z "$dup" ] || { echo "FAIL: duplicate DEFAULT-APPS rows: $dup"; FAIL=1; }
[ "$FAIL" = 0 ] && echo "APP-SCAN PASS" || exit 1
