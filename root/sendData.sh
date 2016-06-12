#!/bin/sh
macr=`ifconfig | grep -w br-la.|sed s'|br-lan    Link encap:Ethernet  HWaddr ||'g|sed 's/^ *//g' | sed 's/ *$//g'`
ROUTER_MAC=`ifconfig | grep -w br-la.|sed s'|br-lan    Link encap:Ethernet  HWaddr ||'g|sed 's/^ *//g' | sed 's/ *$//g'`
ROUTER_KEY=`echo -n $macr | md5sum| awk '{ print $1 }'|sed 's/^ *//g' | sed 's/ *$//g'`
for interface in `iw dev | grep Interface | cut -f 2 -s -d" "`
do
  maclist=`iw dev $interface station dump | grep Station | cut -f 2 -s -d" "`
  for mac in $maclist
  do
    RSSI=`iw dev $interface station get $mac|grep signal:|cut -f 3 -s -d" "`
    RSSI="${RSSI//[!0-9]/}"
    SSID_NAME=`iw "$interface." info|grep ESSID|sed 's|ESSID\|\"||g'|grep -w "$interface."|cut -f 2 -s -d":"|sed 's/^ *//g' | sed 's/ *$//g'`
    SSID_KEY=`echo -n $ROUTER_MAC$SSID_NAME | md5sum| awk '{ print $1 }'|sed 's/^ *//g' | sed 's/ *$//g'`
    SSID_MAC=`ifconfig|grep  -w "$interface."|awk '/HWaddr/ {print $5}'`
    HOST=`cat /tmp/dhcp.leases | cut -f 2,3,4 -s -d" " | grep $mac | cut -f 3 -s -d" "`
        #echo "$mac=$RSSI=$SSID_KEY=$SSID_MAC=$SSID_NAME=$ROUTER_KEY=$ROUTER_MAC"
        echo "HOST=$HOST&mac=$mac&rssi=$RSSI&SSID_KEY=$SSID_KEY&SSID_MAC=$SSID_MAC&SSID_NAME=$SSID_NAME&ROUTER_KEY=$ROUTER_KEY&ROUTER_MAC=$ROUTER_MAC"
        QUERY="http://neursoft.com/captive/addDataSSID.php?HOST=$HOST&mac=$mac&rssi=$RSSI&SSID_KEY=$SSID_KEY&SSID_MAC=$SSID_MAC&SSID_NAME=$SSID_NAME&ROUTER_KEY=$ROUTER_KEY&ROUTER_MAC=$ROUTER_MAC"
        QUERY=`echo $QUERY|sed 's/ /%20/g'`
        #echo $QUERY
        CODE=`wget -s $QUERY`
  done
done
