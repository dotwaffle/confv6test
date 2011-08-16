#!/bin/bash
# This script tests the conference WiFi, including basic IPv6 tests.
# Based on the RIPE62 v6probs.sh

# Store the logfile somewhere volatile that will (hopefully) get
# auto-cleaned on user reboot.
log=/tmp/v6report.txt

# Where should people email these reports to?
email=fixme@example.com

# Show a banner to let the user know everything's working just fine.
echo "Testing v6 connectivity, we'll need your password to run tcpdump"
echo "This should take about 2 minutes to run"
echo

# What kind of system are we running on?
uname -a > $log
echo >> $log

# What is the state of the interfaces?
# NOTE: While "ip a" would be better, it's not portable.
ifconfig -a >> $log
echo >> $log

# What does the routing table look like?
netstat -rn >> $log
echo >> $log

# How do we get to Google via v6?
traceroute6 ipv6.google.com >> $log 2>&1
echo >> $log

# What's the v6 connectivity like to RIPE's website?
ping6 -c4 www.ripe.net >> $log
echo >> $log

# If DNS broken, what's the connectivity like?
ping6 -c4 2001:67c:2e8:22::c100:68b >> $log
echo >> $log

# What is the neighbor cache?
OS=`uname`
case $OS in
    Linux)
        ip neigh >> $log
        echo >> $log
    ;;
    Darwin)
        ndp -an >> $log
        echo >> $log
    ;;
esac

# On OSX we can do a few nice things to see how the wifi is working too.
case $OS in
    Darwin)
        /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I >> $log
        /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s >> $log
        echo >> $log
        interface=$(route get ripe.net | grep interface | cut -f2 -d:)
        sudo tcpdump -i $interface -v icmp6 >> v6report.txt 2>&1 &
        sleep 80
        sudo kill $!
        echo >> $log
    ;;
esac

# Finish up.
echo "Done, please email $log to $email"
