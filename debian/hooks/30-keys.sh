#!/bin/sh
# debian/hooks/30-keys.sh — install release PUBLIC keys to /usr/share/halide/keys (ch.05 §8 hook 3).
# Private keys never enter the tree (ch.08 §8); scanner fails builds on private material.
set -eu
echo "[hook 30] install keys/pubs/*.pub -> /usr/share/halide/keys (mode 0644, root)"
echo "[hook 30] grep -rq 'PRIVATE KEY' keys/ && exit 1 (private material in tree)"
if grep -rl "PRIVATE KEY" keys/ 2>/dev/null; then exit 1; fi
echo "[hook 30] done (no-op stub)"
