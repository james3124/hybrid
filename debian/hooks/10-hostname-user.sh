#!/bin/sh
# debian/hooks/10-hostname-user.sh — create halide principal set (ch.05 §8 hook 1, §22).
# Implements debian/users-groups.csv (group,uid,members,why); builder runs before image assembly.
# Phone-safe text stub: prints intended groups/members; exit 0.
set -eu
cd "$(dirname "$0")/../.."
CSV=debian/users-groups.csv
[ -f "$CSV" ] || { echo "REFUSED: $CSV missing"; exit 2; }
echo "[hook 10] users-groups.csv present — implementing"
while IFS=, read -r group uid members why; do
  case "$group" in group|\#*) continue;; esac
  echo "[hook 10] groupadd -g $uid $group; members: $members"
done < "$CSV"
echo "[hook 10] host user halide UID 1000, halide-bridges system group, idmap u/g 0 100000 65536 (ch.04 S15)"
echo "[hook 10] done (no-op stub)"
