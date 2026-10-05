#!/bin/sh
# debian/hooks/50-clean.sh — shrink image (ch.05 §8 hook 5, low-spec tier budget).
set -eu
echo "[hook 50] purge docs/locales outside top-12, apt clean, truncate /etc/machine-id (regenerated per device)"
echo "[hook 50] done (no-op stub)"
