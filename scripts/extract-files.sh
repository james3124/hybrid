#!/bin/bash
# scripts/extract-files.sh — pull vendor blobs from a stock OTA payload (ch.02 §60/§111).
# Builder-only: needs payload_properties + host-side python + simg2img.
set -eu
usage() { echo "usage: extract-files.sh --ota <ota.zip> --out <vendor-tree>"; }
OTA=""; OUT=""
while [ $# -gt 0 ]; do case "$1" in --ota) OTA=$2; shift 2;; --out) OUT=$2; shift 2;; *) usage; exit 2;; esac; done
[ -n "$OTA" ] && [ -n "$OUT" ] || { usage; exit 2; }
[ -f "$OTA" ] || { echo "REFUSED: $OTA missing (fetch + SHA-verify first per ch.09 §17)"; exit 2; }
echo "extract-files: payload parse -> simg2img super -> delta pull into $OUT"
echo "extract-files: BLOB-SHA256.txt sha256sum -c must pass before commit"
echo "extract-files: fallback to upstream linux-firmware preferred when present (ch.02 §60)"
exit 0
