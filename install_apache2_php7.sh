#!/bin/sh
# Installation of server components
# Johannes Strasser
# 8.7.2017
# www.strasys.at
#

#Installation of Server components
#
echo "update debian wheeze 7"
apt-get update
wait
echo "Debian Version"
cat /etc/debian_version
wait
echo "install apache2"
apt-get install apache2
wait
echo "install php5 libapache2-mod-php7"
apt-get install php7.0 libapache2-mod-php7.0 php7.0-curl php7.0-xml
wait
echo "Disabeling of not used services:"
echo "disabel cloud9.service"
systemctl disable cloud9.service
wait
cd /lib/systemd/system/
echo "disable bonescript.service"
systemctl disable bonescript.service
wait
rm bonescript.service
echo "disable bonescript.socket"
systemctl disable bonescript.socket
wait
rm bonescript.socket
echo "disable bonescript-autorun.service"
systemctl disable bonescript-autorun.service
wait
rm bonescript-autorun.service
echo "disable avahi-daemon.service"
systemctl disable avahi-daemon.service
wait
rm avahi-daemon.service
echo "purge bonescript bone101 c9-core-installer bb-node-red-installer"
apt-get purge bonescript bone101 c9-core-installer bb-node-red-installer
wait
echo "Installation of apache2, php7 and libapache2-mod-php7 completed"
echo "restart apache2"
service apache2 restart
wait
echo "The network interface file needs to contain following:\n
The rest needs tobe uncommented\n\n
# The loopback network interface\n
auto lo\n
iface lo inet loopback\n
"
read -p "Change the /etc/network/interfaces file and than press enter to continue."
apt-get install network-manager
wait
-p "Would you like to activate SSL encryption? (y/n)? " RESP
if [ "$RESP" = "y" ]; then
echo "Generate private key"
openssl genrsa -out /etc/ssl/private/apache.key 2048 
wait
echo "For standard use we generate our own certificate.\n
The live time of the certificate is set to 365 days.\n
For a puplic certificate a CA (Certifide Authoroty) needs involved.\
Details to do that see: https://wiki.ubuntuusers.de/Apache/SSL\n
of interrest is as well the https://letsencrypt.org/howitworks/ project!"
echo "There will be some questions asked:\
Fill in them as follows:\
Country Name: AT\n
state: Upper Austria\n
locality: Kopfing i.I.\
Organization Name: strasys\n
Organizational Unit: .\n
Common Name ...: privateplc\n
Email Address: info@strasys.at"
openssl req -new -x509 -key /etc/ssl/private/apache.key -days 365 -sha256 -out /etc/ssl/certs/apache.crt
wait
echo "Activate SSL-module"
a2enmod ssl
wait
echo "Reload apache2"
service apache2 force-reload
wait
echo "enable default-ssl"
a2ensite default-ssl
wait
echo "Reload apache2"
service apache2 force-reload
else
exit 1
fi
read -r currenthostname < /etc/hostname
wait
echo "Hostname set to: " $currenthostname
read -p "Would you like to change the hostname? (y/n) " RESP
if [ "$RESP" = "y" ]; then
cd /usr/lib/cgi-bin/
wait
chmod a+x set_hostname.sh
./set_hostname.sh
wait
else
exit 1
fi
read -p "Would you like to reboot (strongly recommended)? (y/n)? " RESP
if [ "$RESP" = "y" ]; then
reboot
else
echo "End of webserver installation process!\n"
exit 1
fi