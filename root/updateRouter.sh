#!/bin/sh
check=`/bin/pidof chilli`
if [ -z $check ]
	then
	echo "Chilli not running"
	chilli
else
	echo "Chilli runnig PID: "$check
fi


##ejecutar script despues de instalar openwrt y de generar los SSID
t06_id_router=`ifconfig | grep -w br-la.|sed s'|br-lan    Link encap:Ethernet  HWaddr ||'g|sed 's/^ *//g' | sed 's/ *$//g'`
ROUTER_MAC=`ifconfig | grep -w br-la.|sed s'|br-lan    Link encap:Ethernet  HWaddr ||'g|sed 's/^ *//g' | sed 's/ *$//g'`
ROUTER_KEY=`echo -n $t06_id_router | md5sum| awk '{ print $1 }'|sed 's/^ *//g' | sed 's/ *$//g'`
for interface in `iw dev | grep Interface | cut -f 2 -s -d" "`
do
        interface=`echo -n $interface|sed 's/^ *//g' | sed 's/ *$//g'`
        #SSID_KEY se compone de la mac fisica del router y de la interfaz "94:10:3E:08:E3:3EAdmin WiFi"
        SSID_NAME=`iwinfo|grep ESSID|sed 's|ESSID\|\"||g'|grep -w "$interface."|cut -f 2 -s -d":"|sed 's/^ *//g' | sed 's/ *$//g'`
        SSID_KEY=`echo -n $ROUTER_MAC$SSID_NAME | md5sum| awk '{ print $1 }'|sed 's/^ *//g' | sed 's/ *$//g'`
        SSID_MAC=`ifconfig|grep  -w "$interface."|awk '/HWaddr/ {print $5}'`
        ##data
        echo -e "$SSID_KEY\t$SSID_NAME\t\t$SSID_MAC\t\t$ROUTER_KEY\t\t$ROUTER_MAC\t\t$interface"
        QUERY="http://neursoft.com/routerData/updateRouterSSID.php?SSID_KEY=$SSID_KEY&SSID_MAC=$SSID_MAC&SSID_NAME=$SSID_NAME&ROUTER_KEY=$ROUTER_KEY&ROUTER_MAC=$ROUTER_MAC"
        QUERY=`echo $QUERY|sed 's/ /%20/g'`
        echo -e $QUERY
        CODE=`wget $QUERY -O updateRouterStatus`
        echo $CODE
done
