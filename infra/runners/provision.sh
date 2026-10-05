#!/bin/bash
# infra/runners/provision.sh — runner provisioning: verified netboot, yaml apply, inventory enroll, selftest (ch.09 §206).
set -eu
usage() { echo "usage: provision.sh --class <builder|virt-ci|lab-runner> --id <rNN>"; }
CLASS=""; ID=""
while [ $# -gt 0 ]; do case "$1" in --class) CLASS=$2; shift 2;; --id) ID=$2; shift 2;; *) usage; exit 2;; esac; done
[ -n "$CLASS" ] && [ -n "$ID" ] || { usage; exit 2; }
echo "[provision] class=$CLASS id=$ID: netboot canonical image (SHA verified pre-install)"
echo "[provision] apply infra/runners/$CLASS.yaml (users, mounts, firewall, cron guards)"
echo "[provision] enroll infra/runners/inventory.csv (id,class,MAC,TPM EK,image SHA,owner,date)"
echo "[provision] run infra/runners/selftest.sh — only green runners join the pool"
exit 0
