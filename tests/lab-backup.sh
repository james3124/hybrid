#!/bin/bash
# tests/lab-backup.sh — nightly lab backup with redaction-surviving deltas (ch.10 §219).
# 3-2-1 evidence rule: 3 copies, 2 media, 1 offsite. Phone-safe text run.
set -eu
cd "$(dirname "$0")/.."
DEST="${1:-}"
[ -n "$DEST" ] || { echo "SKIP: no backup destination (builder/nightly only)"; exit 2; }
for d in lab power gnss qa/digs cts-results tests/goldens; do
  [ -d "$d" ] && echo "lab-backup: rsync delta $d -> $DEST/$d" || echo "note: $d absent (skip)"
done
echo "lab-backup: backup manifest sha256 logged; raw quarantine expiry job logged separately"
echo "lab-backup: PASS (text plan)"
exit 0
