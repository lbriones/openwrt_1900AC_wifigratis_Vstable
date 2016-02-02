
BusyBox v1.23.2 (2015-07-24 23:41:29 CEST) built-in shell (ash)

  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 -----------------------------------------------------
 CHAOS CALMER (15.05, r46767)
 -----------------------------------------------------
  * 1 1/2 oz Gin            Shake with a glassful
  * 1/4 oz Triple Sec       of broken ice and pour
  * 3/4 oz Lime Juice       unstrained into a goblet.
  * 1 1/2 oz Orange Juice
  * 1 tsp. Grenadine Syrup
 -----------------------------------------------------


#OpenWrt_1900AC
##Setting up coovachilli in openwrt for Captive portal application

## Instalación de firmware
##

https://downloads.openwrt.org/chaos_calmer/15.05/mvebu/generic/openwrt-15.05-mvebu-armada-xp-linksys-mamba-squashfs-factory.img

- ir a 192.168.1.1 y terminar wizard
- conectividad
- actualización del firmware del router
- manual < openwrt-15.05-mvebu-armada-xp-linksys-mamba-squashfs-factory.img

## Instalación de librerías de openwrt
##

ir a http://192.168.1.1
- cambiar password
- acceder ssh
- opkg update
- opkg install librt
- opkg install libpthread
- opkg install kmod-tun
- opkg install coova-chilli
- opkg install haserl
- opkg install iwinfo

## Replicar configuraciones
##

https://github.com/lbriones/openwrt_1900AC_wifigratis_Vstable/blob/master/etc/chilli/config
https://github.com/lbriones/openwrt_1900AC_wifigratis_Vstable/blob/master/etc/chilli/www/coova.html
https://github.com/lbriones/openwrt_1900AC_wifigratis_Vstable/blob/master/etc/init.d/chilli
https://github.com/lbriones/openwrt_1900AC_wifigratis_Vstable/blob/master/etc/rc.local
https://github.com/lbriones/openwrt_1900AC_wifigratis_Vstable/blob/master/etc/crontabs/root
https://github.com/lbriones/openwrt_1900AC_wifigratis_Vstable/tree/master/root

- chmod +x sendData.sh
- chmod +x startSendData
- chmod +x updateRouter.sh
- chmod +x /etc/init.d/chilli
- mv config     /etc/chilli/config
- mv coova.html /etc/chilli/www/
- mv chilli     /etc/init.d/
- mv rc.local   /etc/
- mv root       /etc/crontabs/
- /etc/init.d/chilli restart
- /etc/init.d/chilli enable
- reboot

## Ajustes de red
##

- section=$(uci add network interface)
- uci rename network."$section"='chilli'
- uci set network.chilli.type=bridge
- uci set network.chilli.proto=static
- uci set network.chilli.ipaddr='192.168.100.1'
- uci set network.chilli.netmask='255.255.255.0'
- uci commit network
- uci add wireless wifi-iface >/dev/null
- uci set wireless.@wifi-iface[0].ssid='Admin WiFi'
- uci set wireless.@wifi-iface[0].encryption=psk
- uci set wireless.@wifi-iface[0].key="123456789"
- uci set wireless.@wifi-iface[1].device=radio0
- uci set wireless.@wifi-iface[1].mode=ap
- uci set wireless.@wifi-iface[1].encryption=none
- uci set wireless.@wifi-iface[1].network=chilli
- uci set wireless.@wifi-iface[1].ssid='WifiGratis'
- uci commit wireless
- uci set wireless.@wifi-device[0].disabled=0
- uci commit wireless
- wifi

## Redireccionar ambientes
##

- find ./ -type f -exec sed -i -e 's/domain_to/domain_to/g' {} \;

