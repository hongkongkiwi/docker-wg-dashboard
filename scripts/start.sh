#!/bin/sh

/usr/bin/coredns -conf /etc/coredns/Corefile -quiet -dns.port 53 &
/usr/local/bin/node /wg-dashboard/src/server.js
