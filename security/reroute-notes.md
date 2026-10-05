# Reroute (Tor-style) mode — design note

Owner: Security + Platform · Phase: 2+ · Skeleton, phone-safe text layer.

Mode selected via the netd bridge: `MODE tor` (bridges/netd_bridge.py).
While active:

1. Container DNS is forced through the router's DNSPort (127.0.0.1/10.152.152.10)
   — public resolvers (8.8.8.8 etc.) are rejected at the bridge (`ERR dns-via-tor-only`).
2. All container TCP goes to the local Tor TransPort (9040) via `debian/nftables-tor.conf`;
   everything else is dropped + logged (`halide-tor-kill`).
3. Host output policy is default-deny; only Tor directory/guard ports (9001/9030) survive.
4. Fail-closed: Tor down → container has no path at all (same kill-switch doctrine
   as the VPN profile, ch.05 §16 / ch.08 §16).

`MODE direct` and `MODE vpn` restore the standard profiles.
Runtime (builder) bits: torrc with `TransPort 9040`, `DNSPort 9053`,
`VirtualAddrNetwork 10.192.0.0/10`; a systemd unit under debian/overlays.
On-phone verification: `tests/net-firewall.sh`, `bridges/tests/netd_contract.sh`
(tor section), `tests/dns-leak.sh`, `tests/telemetry-off.sh`.
