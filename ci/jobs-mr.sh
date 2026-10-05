#!/bin/bash
# ci/jobs-mr.sh - per-MR suite (phone-safe)
set -eu
cd "$(dirname "$0")/.."
sh tests/smoke.sh
python3 tests/test_bridges.py
sh scripts/budget-check.sh
sh scripts/socket-audit.sh
sh tests/power-smoke.sh
bash scripts/plan-consistency.sh
bash scripts/md-links.sh
bash scripts/perf-footnote-lint.sh
bash scripts/wc-budget.sh
bash scripts/sepolicy-pin-check.sh
bash scripts/shell-lint.sh
bash security/hardening-audit.sh
bash tests/reroute-contract.sh
python3 scripts/req-coverage.py
python3 scripts/dtbo-lint.py
echo "jobs-mr: PASS"
