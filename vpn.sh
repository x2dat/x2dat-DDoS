# vpn

function installVPN(){
	echo "begin to install VPN services";
	#check wether vps suppot ppp and tun
	
	#
	if grep -Eqi "release 5." /etc/redhat-release; then
		ver1='5'
	elif grep -Eqi "release 6." /etc/redhat-release; then
		ver1='6'
	elif grep -Eqi "release 7." /etc/redhat-release; then
		ver1='7'
	fi
	
	yum install curl -y
	yum install epel-release -y

	if [ "$ver1" == "7" ]; then
#
		systemctl stop firewalld.service
		systemctl disable firewalld.service
		yum install iptables-services -y
#
		chmod +x /etc/rc.d/rc.local
	fi
#	
	
	rm -rf /etc/pptpd.conf
	rm -rf /etc/ppp
#	
	

	yum install -y ppp pptpd

	#
	mknod /dev/ppp c 108 0 
	echo 1 > /proc/sys/net/ipv4/ip_forward 
	echo "mknod /dev/ppp c 108 0" >> /etc/rc.local
	echo "echo 1 > /proc/sys/net/ipv4/ip_forward" >> /etc/rc.local
	echo "localip 172.16.36.1" >> /etc/pptpd.conf
	echo "remoteip 172.16.36.2-254" >> /etc/pptpd.conf
	echo "ms-dns 8.8.8.8" >> /etc/ppp/options.pptpd
	echo "ms-dns 8.8.4.4" >> /etc/ppp/options.pptpd

	pass=`openssl rand 6 -base64`
	if [ "$1" != "" ]
	then pass=$1
	fi

	echo "vpn pptpd ${pass} *" >> /etc/ppp/chap-secrets

	iptables -t nat -A POSTROUTING -s 172.16.36.0/24 -j SNAT --to-source `curl ip.cn | awk -F ' ' '{print $2}' | awk -F '：' '{print $2}'`
	iptables -A FORWARD -p tcp --syn -s 172.16.36.0/24 -j TCPMSS --set-mss 1356
	iptables -I INPUT -p gre -j ACCEPT
	iptables -I INPUT -p tcp -m tcp --dport 1723 -j ACCEPT
	service iptables save

	if [ "ver1" == "7" ]; then
		systemctl enable iptables.service
		systemctl enable pptpd.service
		systemctl restart iptables.service
		systemctl restart pptpd.service
	else
		chkconfig iptables on
		chkconfig pptpd on
		service iptables start
		service pptpd start		
	fi


}

function addVPNuser(){
	echo "input user name:"
	read username
	echo "input password:"
	read userpassword
	echo "${username} pptpd ${userpassword} *" >> /etc/ppp/chap-secrets
	service iptables restart
	service pptpd start
}

echo "which do you want to?input the number."
echo "1. install VPN service"
echo "2. add VPN user"
read num

case "$num" in
[1] ) (installVPN);;
[2] ) (addVPNuser);;
*) echo "nothing,exit";;
esac
