#!/bin/sh
# debian/hooks/40-release.sh — write /etc/halide-release (ch.05 §8 hook 4).
set -eu
echo "[hook 40] /etc/halide-release: version from manifests/version.env, MANIFEST SHAs, SKU, builder digest, fingerprint-equivalent"
echo "[hook 40] done (no-op stub)"
