#!/bin/bash
for i in 0 1 2 3; do
    ips=$(dig -t a s$i.t.hmny.io | grep ^s$i.t.hmny.io | cut -f 2 -d A)
    #nmap $ips -Pn -p 6000 -sT -oG - | grep Ports: |  tr '/' ' ' | cut -f 2,5 -d ' ' | sed 's/filtered/broken (s'$i.t.hmny.io')/'
    for ip in $ips; do
	echo | nc -w 3 -tvnz $ip 6000 2>&1 | sed -e 's/$/ (s'$i.t.hmny.io')/'
    done
done
