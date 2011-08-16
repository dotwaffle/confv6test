#!/bin/sh
log=v6report.txt
echo "Testing v6 connectivity, we'll need your password to run tcpdump"
echo "This should take about 2 minutes to run"
echo
uname -a > $log
echo >> $log
ifconfig -a >> $log
echo >> $log
netstat -rn >> $log
echo >> $log
traceroute6 ripe62.ripe.net >> $log 2>&1
echo >> $log
ping6 -c4 ripe62.ripe.net >> $log
ping6 -c4 2001:67c:64:42::1 >> $log
echo >> $log
echo >> $log
OS=`uname`
case $OS in
    Linux)
        ip neigh >> $log
        echo >> $log
    ;;
    Darwin)
	ndp -an >> $log
        /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I >> $log
        /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s >> $log
        echo >> $log
        sudo tcpdump -v icmp6 >> v6report.txt 2>&1 &
        sleep 80
        sudo kill $!
        echo >> $log
    ;;
esac
echo "Done, please email v6report.txt to opsmtg@ripe.net"
