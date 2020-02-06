#!/bin/sh

/usr/bin/coredns -conf /etc/coredns/Corefile -quiet -dns.port 8053 &
[ -f "/etc/wireguard/wg0.conf" ] && systemctl start wg-quick@wg0
/usr/local/bin/node /wg-dashboard/src/server.js
