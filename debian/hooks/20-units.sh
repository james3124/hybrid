#!/bin/sh
# debian/hooks/20-units.sh — the ONLY place units get enabled/masked at image build (ch.05 §8 hook 2).
# Manual systemctl enable on a live device is lab-only; CI diffs rendered unit list vs committed.
set -eu
echo "[hook 20] enable halide.slice halide-android.service halide-prop-bridge.service halide-ril-bridge.service"
echo "[hook 20] enable halide-audio-bridge.service halide-netd-bridge.service halide-permission-bridge.service"
echo "[hook 20] enable halide-alarm-bridge.service halide-suspend-prepare.service halide-bootstage.service"
echo "[hook 20] mask units that fight ModemManager / NM single-stack (ch.05 §2 graph)"
for u in NetworkManager-wait-online.service multipathd.service; do
  echo "[hook 20] systemctl mask $u"
done
echo "[hook 20] done (no-op stub)"
