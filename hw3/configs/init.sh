#!/bin/bash
if [ -f /tmp/clab-p2p.hosts ] && ! grep -q "BEGIN CLAB P2P HOSTS" /etc/hosts; then cat /tmp/clab-p2p.hosts >> /etc/hosts; fi
ip route del default dev eth0 2>/dev/null || true
sysctl -w net.ipv4.fib_multipath_hash_policy=1
sysctl -w net.ipv4.fib_multipath_use_neigh=1
sysctl -w net.ipv4.icmp_errors_use_inbound_ifaddr=1
sysctl -w net.ipv4.conf.all.rp_filter=0
sysctl -w net.ipv4.conf.default.rp_filter=0
sysctl -w net.ipv4.icmp_ratemask=0
for iface in /sys/class/net/*; do
    ifname=$(basename "$iface")
    sysctl -w net.ipv4.conf.$ifname.rp_filter=0 || true
done
case "$(hostname)" in
    p1)
        ip link set eth1 mtu 9486 2>/dev/null || true
        ;;
    p2)
        ip link set eth3 mtu 9486 2>/dev/null || true
        ;;
esac
