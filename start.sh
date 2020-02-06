#!/bin/sh

/usr/bin/coredns -conf /etc/coredns/Corefile -cpu 10% &
/usr/local/bin/node /wg-dashboard/src/server.js
