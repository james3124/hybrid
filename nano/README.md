# HALIDE-nano — 500MB storage target

Sister build of the REF-A daily-driver tree, for ultra-low-storage devices
(feature-phone-class flash, IoT gateways, recovery partitions).

## Architecture (what changed vs the phone tree)

| Area | Phone (REF-A) | nano |
|------|---------------|------|
| Android container (LXC) | yes (~4-6 GiB) | **removed** — host-only Debian |
| GUI (Phosh/Wayland) | yes | no — serial/UART console + busybox `ash` |
| Package set (Debian) | full `packages.host` | `nano/packages.list` only (~120-200 MB) |
| Kernel | GKI + vendor modules | same 6.6 LTS, but `nano/kconfig.fragment` strips DRM/GPU/firmware |
| Bridges | all 6 | nm/prop only, others off |
| OTA | A/B full | delta-only payloads, single slot |

## Storage budget (binding)

Checked by `scripts/nano-budget-check.sh`; CI fails past 500 MiB total.

| Component | Budget (MiB) |
|-----------|--------------|
| kernel + initramfs | 48 |
| Debian rootfs (debootstrap minbase + packages.list) | 220 |
| systemd units + config | 8 |
| bridges (nm + prop, static binaries) | 16 |
| ota cache + logs (capped, tmpfiles) | 24 |
| recovery partition | 64 |
| headroom (dm-verity cushion) | 120 |
| **TOTAL** | **≤ 500** |

## What you give up (honest list)

- No Android apps, no Play/APK at all
- No touchscreen GUI; console only
- No camera/GNSS/audio HAL integration
- Telephony via host `mmcli` only, no Android telephony stack
