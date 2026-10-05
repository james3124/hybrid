#!/bin/bash
# scripts/apply-check.sh — alias for scripts/dtbo-apply-check.sh (ch.03 §642 board-ID matrix gate).
set -eu
exec bash "$(dirname "$0")/dtbo-apply-check.sh" "$@"
