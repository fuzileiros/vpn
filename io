#!/bin/bash

# Secure OpenVPN server installer for Debian, Ubuntu, CentOS and Arch Linux


if [[ "$EUID" -ne 0 ]]; then
	echo "Sorry, you need to run this as root"
	exit 1
fi

if [[ ! -e /dev/net/tun ]]; then
	echo "TUN is not available"
	exit 2
fi

if grep -qs "CentOS release 5" "/etc/redhat-release"; then
	echo "CentOS 5 is too old and not supported"
	exit 3
fi

if [[ -e /etc/debian_version ]]; then
	OS="debian"
	# Getting the version number, to verify that a recent version of OpenVPN is available
	VERSION_ID=$(cat /etc/os-release | grep "VERSION_ID")
	IPTABLES='/etc/iptables/iptables.rules'
	SYSCTL='/etc/sysctl.conf'
	if [[ "$VERSION_ID" != 'VERSION_ID="7"' ]] && [[ "$VERSION_ID" != 'VERSION_ID="8"' ]] && [[ "$VERSION_ID" != 'VERSION_ID="9"' ]] && [[ "$VERSION_ID" != 'VERSION_ID="14.04"' ]] && [[ "$VERSION_ID" != 'VERSION_ID="16.04"' ]] && [[ "$VERSION_ID" != 'VERSION_ID="17.10"' ]] && [[ "$VERSION_ID" != 'VERSION_ID="18.04"' ]]; then
		echo "Your version of Debian/Ubuntu is not supported."
		echo "I can't install a recent version of OpenVPN on your system."
		echo ""
		echo "However, if you're using Debian unstable/testing, or Ubuntu beta,"
		echo "then you can continue, a recent version of OpenVPN is available on these."
		echo "Keep in mind they are not supported, though."
		while [[ $CONTINUE != "y" && $CONTINUE != "n" ]]; do
			read -p "Continue ? [y/n]: " -e CONTINUE
		done
		if [[ "$CONTINUE" = "n" ]]; then
			echo "Ok, bye !"
			exit 4
		fi
	fi
elif [[ -e /etc/fedora-release ]]; then
	OS=fedora
	IPTABLES='/etc/iptables/iptables.rules'
	SYSCTL='/etc/sysctl.d/openvpn.conf'
elif [[ -e /etc/centos-release || -e /etc/redhat-release || -e /etc/system-release ]]; then
	OS=centos
	IPTABLES='/etc/iptables/iptables.rules'
	SYSCTL='/etc/sysctl.conf'
elif [[ -e /etc/arch-release ]]; then
	OS=arch
	IPTABLES='/etc/iptables/iptables.rules'
	SYSCTL='/etc/sysctl.d/openvpn.conf'
else
	echo "Looks like you aren't running this installer on a Debian, Ubuntu, CentOS or ArchLinux system"
	exit 4
fi

newclient () {
	# Where to write the custom client.ovpn?
	if [ -e /home/$1 ]; then  # if $1 is a user name
		homeDir="/home/$1"
	elif [ ${SUDO_USER} ]; then   # if not, use SUDO_USER
		homeDir="/home/${SUDO_USER}"
	else  # if not SUDO_USER, use /root
		homeDir="/root"
	fi
	# Generates the custom client.ovpn
	cp /etc/openvpn/client-template.txt $homeDir/$1.ovpn
	echo "<ca>" >> $homeDir/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/ca.crt >> $homeDir/$1.ovpn
	echo "</ca>" >> $homeDir/$1.ovpn
	echo "<cert>" >> $homeDir/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/issued/$1.crt >> $homeDir/$1.ovpn
	echo "</cert>" >> $homeDir/$1.ovpn
	echo "<key>" >> $homeDir/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/private/$1.key >> $homeDir/$1.ovpn
	echo "</key>" >> $homeDir/$1.ovpn
	echo "key-direction 1" >> $homeDir/$1.ovpn
	echo "<tls-auth>" >> $homeDir/$1.ovpn
	cat /etc/openvpn/tls-auth.key >> $homeDir/$1.ovpn
	echo "</tls-auth>" >> $homeDir/$1.ovpn
}

# Get Internet network interface with default route
NIC=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)

if [[ -e /etc/openvpn/server.conf ]]; then
	while :
	do
	clear
####################################	
#MENU GERENCIAR OPEN VPN COLT SEALS#
####################################
ip=$(wget -qO- ipv4.icanhazip.com)
clear
if [[ $1 == "" ]]
then
dia=$(date | awk {'print $3'})
mes=$(date | awk {'print $2'})
ano=$(date | awk {'print $6'})
if [[ "$mes" = "Jan" || "$mes" = "Jan" ]]; then
mes=01
elif [[ "$mes" = "Feb" || "$mes" = "Fev" ]]; then
mes=02
elif [[ "$mes" = "Mar" || "$mes" = "Mar" ]]; then
mes=03
elif [[ "$mes" = "Apr" || "$mes" = "Abr" ]]; then
mes=04
elif [[ "$mes" = "May" || "$mes" = "Mai" ]]; then
mes=05
elif [[ "$mes" = "Jun" || "$mes" = "Jun" ]]; then
mes=06
elif [[ "$mes" = "Jul" || "$mes" = "Jul" ]]; then
mes=07
elif [[ "$mes" = "Ago" || "$mes" = "Ago" ]]; then
mes=08
elif [[ "$mes" = "Set" || "$mes" = "Sep" ]]; then
mes=09
elif [[ "$mes" = "Out" || "$mes" = "Oct" ]]; then
mes=10
elif [[ "$mes" = "Nov" || "$mes" = "Nov" ]]; then
mes=11
elif [[ "$mes" = "Dec" || "$mes" = "Dez" ]]; then
mes=12
fi
echo -e "\033[5;36;40m ==========================================================\033[0m"
echo -e "\033[7;30;47m  DATA:\033[0m\033[7;30;41m $dia/$mes/$ano\033[0m"
echo -e "\033[7;30;47m  IP da VPS:\033[0m\033[7;30;41m $ip\033[0m"
system=$(cat /etc/issue.net)
if [ "$system" ]
then
echo -e "\033[7;30;47m  Sistema Operacional:\033[0m\033[7;30;41m $system\033[0m"
else
echo -e "\033[7;30;47m  Sistema Operacional:\033[0m\033[7;30;41mNot Available\033[0m"
fi
echo -e "\033[5;36;40m ==========================================================\033[0m"
echo -e "\033[7;30;47m  ®Script\033[0m \033[7;30;41mEdited:\033[0m \033[0m \033[0;36;40m@Colt\033[5;37;40mSeals\033[0m"
echo -e "\033[7;30;47m  ®TELEGRAM\033[0m \033[7;30;41mCANAL:\033[0m \033[0m \033[0;36;40m@Vps\033[5;37;40mNerdologia\033[0m"
echo -e "\033[5;36;40m ==========================================================\033[0m"
echo -e "\033[7;30;46m  Para Acessar o menu Principal:\033[5;37;40m VPN \033[0m"
echo -e "\033[5;36;40m ==========================================================\033[0m"
echo -e "\033[7;30;46m  Para Acessar este menu digite:\033[5;37;40m Usuarios \033[0m"
echo -e "\033[5;36;40m ==========================================================\033[0m"

echo -e "\033[01;36m║\033[1;37m00\033[1;36m║\033[5;31;40m•\033[0m\033[01;37m VOLTAR \033[5;31;40m=\033[0m \033[7;36;40m Voltar ao Menu Principal \033[0m"
echo -e "\033[01;36m║\033[1;37m01\033[1;36m║\033[5;31;40m•\033[0m\033[01;37m CRIAR USUÁRIO \033[5;31;40m=\033[0m \033[7;36;40m Criar usuários \033[0m"
echo -e "\033[01;36m║\033[1;37m02\033[1;36m║\033[5;31;40m•\033[0m\033[01;37m CRIAR TESTE \033[5;31;40m=\033[0m \033[7;36;40m Criar usuarios de curta duração \033[0m"
echo -e "\033[01;36m║\033[1;37m03\033[1;36m║\033[5;31;40m•\033[0m\033[01;37m DETALHES \033[5;31;40m=\033[0m \033[7;36;40m Informações sobre os usuários \033[0m"
echo -e "\033[01;36m║\033[1;37m04\033[1;36m║\033[5;31;40m•\033[0m\033[01;37m MONITORAMENTO  \033[5;31;40m=\033[0m \033[7;36;40m Monitorar conexões atuais \033[0m"
echo -e "\033[01;36m║\033[1;37m05\033[1;36m║\033[5;31;40m•\033[0m\033[01;37m REDEFINIR \033[5;31;40m=\033[0m \033[7;36;40m Redefinir Data, senha, etc \033[0m"
echo -e "\033[01;36m║\033[1;37m06\033[1;36m║\033[5;31;40m•\033[0m\033[01;37m DELETAR USUARIO \033[5;31;40m=\033[0m \033[7;36;40m Menu Deletar, Desconectar, etc \033[0m"
echo -e "\033[01;36m║\033[1;37m07\033[1;36m║\033[5;31;40m•\033[0m\033[01;37m DELETAR EXPIRADOS \033[5;31;40m=\033[0m \033[7;36;40m Deleta todos usuarios expirados \033[0m"
echo -e "\033[01;36m║\033[1;37m08\033[1;36m║\033[5;31;40m•\033[0m\033[01;37m DELETAR TODOS \033[5;31;40m=\033[0m \033[7;36;40m Deleta todos usuarios \033[5;31m CUIDADO \033[0m"
echo -e "\033[01;36m║\033[1;37m09\033[1;36m║\033[5;31;40m•\033[0m\033[0;31;40m SAIR \033[5;31;40m=\033[0m \033[1;30;41m Sair do Menu VPN. \033[0m"
echo -e "\033[5;36;40m ===========================================================\033[0m"
echo -e "\033[5;31;40m    •\033[0m\033[01;37m Digite uma Opção:\033[0;37m"; read -p " " option
		case $option in
			1)
			echo ""
			echo "Diga-me um nome para o arquivo"
			echo "Use somente o nome sem caracteres especiais"
			read -p "Nome do arquivo: " -e -i newclient CLIENT
			cd /etc/openvpn/easy-rsa/
			./easyrsa build-client-full $CLIENT nopass
			# Generates the custom client.ovpn
			newclient "$CLIENT"
			echo ""
			echo "Client $CLIENT added, certs available at $homeDir/$CLIENT.ovpn"
			exit
			;;
			2)
			NUMBEROFCLIENTS=$(tail -n +2 /etc/openvpn/easy-rsa/pki/index.txt | grep -c "^V")
			if [[ "$NUMBEROFCLIENTS" = '0' ]]; then
				echo ""
				echo "Você não tem usuarios existentes!"
				exit 5
			fi
			echo ""
			echo "Select the existing client certificate you want to revoke"
			tail -n +2 /etc/openvpn/easy-rsa/pki/index.txt | grep "^V" | cut -d '=' -f 2 | nl -s ') '
			if [[ "$NUMBEROFCLIENTS" = '1' ]]; then
				read -p "Select one client [1]: " CLIENTNUMBER
			else
				read -p "Selecione um cliente [1-$NUMBEROFCLIENTS]: " CLIENTNUMBER
			fi
			CLIENT=$(tail -n +2 /etc/openvpn/easy-rsa/pki/index.txt | grep "^V" | cut -d '=' -f 2 | sed -n "$CLIENTNUMBER"p)
			cd /etc/openvpn/easy-rsa/
			./easyrsa --batch revoke $CLIENT
			EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl
			rm -f pki/reqs/$CLIENT.req
			rm -f pki/private/$CLIENT.key
			rm -f pki/issued/$CLIENT.crt
			rm -f /etc/openvpn/crl.pem
			cp /etc/openvpn/easy-rsa/pki/crl.pem /etc/openvpn/crl.pem
			chmod 644 /etc/openvpn/crl.pem
			rm -f $(find /home -maxdepth 2 | grep $CLIENT.ovpn) 2>/dev/null
			rm -f /root/$CLIENT.ovpn 2>/dev/null
			echo ""
			echo "Certificate for client $CLIENT removido"
			echo "Exiting..."
			exit
			;;
			3)
			echo ""
			read -p "Do you really want to remove OpenVPN? [y/n]: " -e -i n REMOVE
			if [[ "$REMOVE" = 'y' ]]; then
				PORT=$(grep '^port ' /etc/openvpn/server.conf | cut -d " " -f 2)
				if pgrep firewalld; then
					# Using both permanent and not permanent rules to avoid a firewalld reload.
					firewall-cmd --zone=public --remove-port=$PORT/udp
					firewall-cmd --zone=trusted --remove-source=10.8.0.0/24
					firewall-cmd --permanent --zone=public --remove-port=$PORT/udp
					firewall-cmd --permanent --zone=trusted --remove-source=10.8.0.0/24
				fi
				if iptables -L -n | grep -qE 'REJECT|DROP'; then
					if [[ "$PROTOCOL" = 'udp' ]]; then
						iptables -D INPUT -p udp --dport $PORT -j ACCEPT
					else
						iptables -D INPUT -p tcp --dport $PORT -j ACCEPT
					fi
					iptables -D FORWARD -s 10.8.0.0/24 -j ACCEPT
					iptables-save > $IPTABLES
				fi
				iptables -t nat -D POSTROUTING -o $NIC -s 10.8.0.0/24 -j MASQUERADE
				iptables-save > $IPTABLES
				if hash sestatus 2>/dev/null; then
					if sestatus | grep "Current mode" | grep -qs "enforcing"; then
						if [[ "$PORT" != '443' ]]; then
							semanage port -d -t openvpn_port_t -p udp $PORT
						fi
					fi
				fi
				if [[ "$OS" = 'debian' ]]; then
					apt-get autoremove --purge -y openvpn
				elif [[ "$OS" = 'arch' ]]; then
					pacman -R openvpn --noconfirm
				else
					yum remove openvpn -y
				fi
				OVPNS=$(ls /etc/openvpn/easy-rsa/pki/issued | awk -F "." {'print $1'})
				for i in $OVPNS
				do
				rm $(find /home -maxdepth 2 | grep $i.ovpn) 2>/dev/null
				rm /root/$i.ovpn 2>/dev/null
				done
				rm -rf /etc/openvpn
				rm -rf /usr/share/doc/openvpn*
				echo ""
				echo "OpenVPN removed!"
			else
				echo ""
				echo "Removal aborted!"
			fi
			exit
			;;
			4) exit;;
		esac
	 else
	clear
	clear
	echo ""
	echo ""
	echo ""
	echo -e "\033[5;31;40m • \033[0m\033[01;37m Bem Vindo Aguarde...\033[0m"
sleep 3
clear
	echo ""
	echo ""
	echo ""
	echo -e "\033[5;31;40m • \033[0m\033[01;37mEstamos iniciando a instalação do OPenVPN...\033[0m"
sleep 3
clear

	# OpenVPN setup and first user creation
	#ColtSeals
	# Autodetect IP address and pre-fill for the user
	IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
	read -p "Endereço de IP da máquina: " -e -i $IP IP
	echo ""
	echo -e "\033[5;31;40m•\033[0m\033[01;37m Qual porta você deseja utilizar?\033[0m"
	echo ""
	echo -e "\033[5;37;40mNa Vivo, as recomendadas são 443 e 1194\033[0m"" -e -i 443 PORT
	# If $IP is a private IP address, the server must be behind NAT
	if echo "$IP" | grep -qE '^(10\.|172\.1[6789]\.|172\.2[0-9]\.|172\.3[01]\.|192\.168)'; then
		echo ""
		clear
	echo -e "\033[5;31;40m•\033[0m\033[01;37mPrimeiro precisaremos do IP de sua maquina, este IP está correto?"
		read -p "Public IP address / hostname: " -e PUBLICIP
	fi
	clear
	echo "Qual protocolo você deseja para as conexões do OpenVPN?"
	echo "Tenha em mente que a Vivo não suporta UDP, mas o mesmo..."
	echo "...Ainda é listado como opção."
	while [[ $PROTOCOL != "UDP" && $PROTOCOL != "TCP" ]]; do
		read -p "Protocol [UDP/TCP]: " -e -i TCP PROTOCOL
	done
	echo ""
	clear
	echo -e "\033[5;31;40m      •\033[0m\033[01;37m Qual DNS você deseja utilizar?\033[0m"
	echo -e "\033[5;36;40m ==========================================================\033[0m"
	echo -e "   1)\033[5;31;40m •\033[0m\033[0;33;40m Current system resolvers"
	echo -e "   2)\033[5;31;40m •\033[0m\033[0;33;40m Cloudflare \033[5;36;40m(Mundial)\033[0m"
	echo -e "   3)\033[5;31;40m •\033[0m\033[0;33;40m Quad9 \033[5;36;40m(Mundial)\033[0m"
	echo -e "   4)\033[5;31;40m •\033[0m\033[0;33;40m FDN \033[5;36;40m(França)\033[0m"
	echo -e "   5)\033[5;31;40m •\033[0m\033[0;33;40m DNS.WATCH \033[5;36;40m(Alemanha)\033[0m"
	echo -e "   6)\033[5;31;40m •\033[0m\033[0;33;40m OpenDNS \033[5;36;40m(Mundial)\033[0m"
	echo -e "   7)\033[5;31;40m •\033[0m\033[0;33;40m\033[01;34;40m G\033[01;31mo\033[01;33mo\033[01;34mg\033[01;32ml\033[01;31me\033[00;37;40m \033[5;33;40m(Recomendado)\033[0m"
	echo -e "   8)\033[5;31;40m •\033[0m\033[0;33;40m Yandex Basic \033[5;36;40m(Russia)\033[0m"
	echo -e "   9)\033[5;31;40m •\033[0m\033[0;33;40m AdGuard DNS \033[5;36;40m(Russia)\033[0m"
	while [[ $DNS != "1" && $DNS != "2" && $DNS != "3" && $DNS != "4" && $DNS != "5" && $DNS != "6" && $DNS != "7" && $DNS != "8" && $DNS != "9" ]]; do
		read -p "DNS [1-9]: " -e -i 1 DNS
	done
	echo ''
		echo -e "\033[5;31;40m      •\033[0m\033[01;37m Qual codificação usar para o canal de dados?\033[0m"
	echo -e "\033[5;36;40m ==========================================================\033[0m"
	echo -e "   1)\033[5;31;40m •\033[0m AES-128-CBC mais rápido e suficientemente seguro \033[5;33;40m(Recomendado)\033[0m"
	echo -e "   2)\033[5;31;40m •\033[0m AES-192-CBC"
	echo -e "   3)\033[5;31;40m •\033[0m AES-256-CBC"
	echo "Alternativas para o AES, use-as somente se você souber o que está fazendo."
	echo "Eles são relativamente mais lentos, mas tão seguros quanto o AES."
	echo -e "   4)\033[5;31;40m •\033[0m CAMELLIA-128-CBC"
	echo -e "   5)\033[5;31;40m •\033[0m CAMELLIA-192-CBC"
	echo -e "   6)\033[5;31;40m •\033[0m CAMELLIA-256-CBC"
	echo -e "   7)\033[5;31;40m •\033[0m SEED-CBC"
		echo -e "\033[5;36;40m ==========================================================\033[0m"
	while [[ $CIPHER != "1" && $CIPHER != "2" && $CIPHER != "3" && $CIPHER != "4" && $CIPHER != "5" && $CIPHER != "6" && $CIPHER != "7" ]]; do
		read -p "Cipher [1-7]: " -e -i 1 CIPHER
	done
	case $CIPHER in
		1)
		CIPHER="cipher AES-128-CBC"
		;;
		2)
		CIPHER="cipher AES-192-CBC"
		;;
		3)
		CIPHER="cipher AES-256-CBC"
		;;
		4)
		CIPHER="cipher CAMELLIA-128-CBC"
		;;
		5)
		CIPHER="cipher CAMELLIA-192-CBC"
		;;
		6)
		CIPHER="cipher CAMELLIA-256-CBC"
		;;
		7)
		CIPHER="cipher SEED-CBC"
		;;
	esac
	echo ""
		echo -e "\033[5;31;40m      •\033[0m\033[01;37m Tamanho da chave Diffie-Hellman que deseja usar:\033[0m"
	echo -e "   1)\033[5;31;40m •\033[0m2048 bits (mais rápido)"
	echo -e "   2)\033[5;31;40m •\033[0m3072 bits \033[5;33;40m(Recomendado, melhor compromisso)•\033[0m"
	echo -e "   3)\033[5;31;40m •\033[0m4096 bits (mais seguro)"
	while [[ $DH_KEY_SIZE != "1" && $DH_KEY_SIZE != "2" && $DH_KEY_SIZE != "3" ]]; do
		read -p "DH key size [1-3]: " -e -i 2 DH_KEY_SIZE
	done
	case $DH_KEY_SIZE in
		1)
		DH_KEY_SIZE="2048"
		;;
		2)
		DH_KEY_SIZE="3072"
		;;
		3)
		DH_KEY_SIZE="4096"
		;;
	esac
	echo ""
	echo "Tamanho da chave RSA que deseja usar:"
	echo -e "   1)\033[5;31;40m •\033[0m2048 bits (mais rápido)"
	echo -e "   2)\033[5;31;40m •\033[0m3072 bits \033[5;33;40m(Recomendado, melhor compromisso)•\033[0m"
	echo -e "   3)\033[5;31;40m •\033[0m4096 bits (mais seguro)"
	while [[ $RSA_KEY_SIZE != "1" && $RSA_KEY_SIZE != "2" && $RSA_KEY_SIZE != "3" ]]; do
		read -p "RSA key size [1-3]: " -e -i 2 RSA_KEY_SIZE
	done
	case $RSA_KEY_SIZE in
		1)
		RSA_KEY_SIZE="2048"
		;;
		2)
		RSA_KEY_SIZE="3072"
		;;
		3)
		RSA_KEY_SIZE="4096"
		;;
	esac
	echo ""
	echo "Finalmente, diga-me um nome para o certificado do cliente e configuração"
	while [[ $CLIENT = "" ]]; do
		echo "Por favor, use apenas uma palavra, sem caracteres especiais"
		read -p "Client name: " -e -i client CLIENT
	done
	echo ""
	echo "Ok, isso era tudo que eu precisava."
	read -n1 -r -p "pressione qualquer tecla para continuar..."

	if [[ "$OS" = 'debian' ]]; then
		apt-get install ca-certificates gnupg -y
		# We add the OpenVPN repo to get the latest version.
		# Debian 7
		if [[ "$VERSION_ID" = 'VERSION_ID="7"' ]]; then
			echo "deb http://build.openvpn.net/debian/openvpn/stable wheezy main" > /etc/apt/sources.list.d/openvpn.list
			wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg | apt-key add -
			apt-get update
		fi
		# Debian 8
		if [[ "$VERSION_ID" = 'VERSION_ID="8"' ]]; then
			echo "deb http://build.openvpn.net/debian/openvpn/stable jessie main" > /etc/apt/sources.list.d/openvpn.list
			wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg | apt-key add -
			apt update
		fi
		# Ubuntu 14.04
		if [[ "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then
			echo "deb http://build.openvpn.net/debian/openvpn/stable trusty main" > /etc/apt/sources.list.d/openvpn.list
			wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg | apt-key add -
			apt-get update
		fi
		# Ubuntu >= 16.04 and Debian > 8 have OpenVPN > 2.3.3 without the need of a third party repository.
		# The we install OpenVPN
		apt-get install openvpn iptables openssl wget ca-certificates curl -y
		# Install iptables service
		if [[ ! -e /etc/systemd/system/iptables.service ]]; then
			mkdir /etc/iptables
			iptables-save > /etc/iptables/iptables.rules
			echo "#!/bin/sh
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT" > /etc/iptables/flush-iptables.sh
			chmod +x /etc/iptables/flush-iptables.sh
			echo "[Unit]
Description=Packet Filtering Framework
DefaultDependencies=no
Before=network-pre.target
Wants=network-pre.target
[Service]
Type=oneshot
ExecStart=/sbin/iptables-restore /etc/iptables/iptables.rules
ExecReload=/sbin/iptables-restore /etc/iptables/iptables.rules
ExecStop=/etc/iptables/flush-iptables.sh
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/iptables.service
			systemctl daemon-reload
			systemctl enable iptables.service
		fi
	elif [[ "$OS" = 'centos' || "$OS" = 'fedora' ]]; then
		if [[ "$OS" = 'centos' ]]; then
			yum install epel-release -y
		fi
		yum install openvpn iptables openssl wget ca-certificates curl -y
		# Install iptables service
		if [[ ! -e /etc/systemd/system/iptables.service ]]; then
			mkdir /etc/iptables
			iptables-save > /etc/iptables/iptables.rules
			echo "#!/bin/sh
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT" > /etc/iptables/flush-iptables.sh
			chmod +x /etc/iptables/flush-iptables.sh
			echo "[Unit]
Description=Packet Filtering Framework
DefaultDependencies=no
Before=network-pre.target
Wants=network-pre.target
[Service]
Type=oneshot
ExecStart=/sbin/iptables-restore /etc/iptables/iptables.rules
ExecReload=/sbin/iptables-restore /etc/iptables/iptables.rules
ExecStop=/etc/iptables/flush-iptables.sh
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/iptables.service
			systemctl daemon-reload
			systemctl enable iptables.service
			# Disable firewalld to allow iptables to start upon reboot
			systemctl disable firewalld
			systemctl mask firewalld
		fi
	else
		# Else, the distro is ArchLinux
		echo ""
		echo ""
		echo "Como você está usando o ArchLinux, eu preciso atualizar os pacotes em seu sistema para instalar os que eu preciso."
		echo "Não fazer isso pode causar problemas entre dependências, ou falta de arquivos em repositórios."
		echo ""
		echo "Continuar atualizará os pacotes instalados e instalará os necessários."
		while [[ $CONTINUE != "y" && $CONTINUE != "n" ]]; do
			read -p "Continue ? [y/n]: " -e -i y CONTINUE
		done
		if [[ "$CONTINUE" = "n" ]]; then
			echo "Ok, bye !"
			exit 4
		fi

		if [[ "$OS" = 'arch' ]]; then
			# Install dependencies
			pacman -Syu openvpn iptables openssl wget ca-certificates curl --needed --noconfirm
			iptables-save > /etc/iptables/iptables.rules # iptables won't start if this file does not exist
			systemctl daemon-reload
			systemctl enable iptables
			systemctl start iptables
		fi
	fi
	# Find out if the machine uses nogroup or nobody for the permissionless group
	if grep -qs "^nogroup:" /etc/group; then
		NOGROUP=nogroup
	else
		NOGROUP=nobody
	fi

	# An old version of easy-rsa was available by default in some openvpn packages
	if [[ -d /etc/openvpn/easy-rsa/ ]]; then
		rm -rf /etc/openvpn/easy-rsa/
	fi
	# Get easy-rsa
	wget -O ~/EasyRSA-3.0.4.tgz https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.4/EasyRSA-3.0.4.tgz
	tar xzf ~/EasyRSA-3.0.4.tgz -C ~/
	mv ~/EasyRSA-3.0.4/ /etc/openvpn/
	mv /etc/openvpn/EasyRSA-3.0.4/ /etc/openvpn/easy-rsa/
	chown -R root:root /etc/openvpn/easy-rsa/
	rm -f ~/EasyRSA-3.0.4.tgz
	cd /etc/openvpn/easy-rsa/
	# Generate a random, alphanumeric identifier of 16 characters for CN and one for server name
	SERVER_CN="cn_$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)"
	SERVER_NAME="server_$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)"
	echo "set_var EASYRSA_KEY_SIZE $RSA_KEY_SIZE" > vars
	echo "set_var EASYRSA_REQ_CN $SERVER_CN" >> vars
	# Create the PKI, set up the CA, the DH params and the server + client certificates
	./easyrsa init-pki
	./easyrsa --batch build-ca nopass
	openssl dhparam -out dh.pem $DH_KEY_SIZE
	./easyrsa build-server-full $SERVER_NAME nopass
	./easyrsa build-client-full $CLIENT nopass
	EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl
	# generate tls-auth key
	openvpn --genkey --secret /etc/openvpn/tls-auth.key
	# Move all the generated files
	cp pki/ca.crt pki/private/ca.key dh.pem pki/issued/$SERVER_NAME.crt pki/private/$SERVER_NAME.key /etc/openvpn/easy-rsa/pki/crl.pem /etc/openvpn
	# Make cert revocation list readable for non-root
	chmod 644 /etc/openvpn/crl.pem

	# Generate server.conf
	echo "port $PORT" > /etc/openvpn/server.conf
	if [[ "$PROTOCOL" = 'UDP' ]]; then
		echo "proto udp" >> /etc/openvpn/server.conf
	elif [[ "$PROTOCOL" = 'TCP' ]]; then
		echo "proto tcp" >> /etc/openvpn/server.conf
	fi
	echo "dev tun
user nobody
group $NOGROUP
persist-key
persist-tun
keepalive 10 120
topology subnet
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt" >> /etc/openvpn/server.conf
	# DNS resolvers
	case $DNS in
		1)
		# Locate the proper resolv.conf
		# Needed for systems running systemd-resolved
		if grep -q "127.0.0.53" "/etc/resolv.conf"; then
			RESOLVCONF='/run/systemd/resolve/resolv.conf'
		else
			RESOLVCONF='/etc/resolv.conf'
		fi
		# Obtain the resolvers from resolv.conf and use them for OpenVPN
		grep -v '#' $RESOLVCONF | grep 'nameserver' | grep -E -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | while read line; do
			echo "push \"dhcp-option DNS $line\"" >> /etc/openvpn/server.conf
		done
		;;
		2) # Cloudflare
		echo 'push "dhcp-option DNS 1.0.0.1"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 1.1.1.1"' >> /etc/openvpn/server.conf	
		;;
		3) # Quad9
		echo 'push "dhcp-option DNS 9.9.9.9"' >> /etc/openvpn/server.conf
		;;
		4) # FDN
		echo 'push "dhcp-option DNS 80.67.169.40"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 80.67.169.12"' >> /etc/openvpn/server.conf
		;;
		5) # DNS.WATCH
		echo 'push "dhcp-option DNS 84.200.69.80"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 84.200.70.40"' >> /etc/openvpn/server.conf
		;;
		6) # OpenDNS
		echo 'push "dhcp-option DNS 208.67.222.222"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 208.67.220.220"' >> /etc/openvpn/server.conf
		;;
		7) # Google
		echo 'push "dhcp-option DNS 8.8.8.8"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 8.8.4.4"' >> /etc/openvpn/server.conf
		;;
		8) # Yandex Basic
		echo 'push "dhcp-option DNS 77.88.8.8"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 77.88.8.1"' >> /etc/openvpn/server.conf
		;;
		9) # AdGuard DNS
		echo 'push "dhcp-option DNS 176.103.130.130"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 176.103.130.131"' >> /etc/openvpn/server.conf
		;;
	esac
echo 'push "redirect-gateway def1 bypass-dhcp" '>> /etc/openvpn/server.conf
echo "crl-verify crl.pem
ca ca.crt
cert $SERVER_NAME.crt
key $SERVER_NAME.key
tls-auth tls-auth.key 0
dh dh.pem
auth SHA256
$CIPHER
tls-server
tls-version-min 1.2
tls-cipher TLS-DHE-RSA-WITH-AES-128-GCM-SHA256
status openvpn.log
verb 3" >> /etc/openvpn/server.conf

	# Create the sysctl configuration file if needed (mainly for Arch Linux)
	if [[ ! -e $SYSCTL ]]; then
		touch $SYSCTL
	fi

	# Enable net.ipv4.ip_forward for the system
	sed -i '/\<net.ipv4.ip_forward\>/c\net.ipv4.ip_forward=1' $SYSCTL
	if ! grep -q "\<net.ipv4.ip_forward\>" $SYSCTL; then
		echo 'net.ipv4.ip_forward=1' >> $SYSCTL
	fi
	# Avoid an unneeded reboot
	echo 1 > /proc/sys/net/ipv4/ip_forward
	# Set NAT for the VPN subnet
	iptables -t nat -A POSTROUTING -o $NIC -s 10.8.0.0/24 -j MASQUERADE
	# Save persitent iptables rules
	iptables-save > $IPTABLES
	if pgrep firewalld; then
		# We don't use --add-service=openvpn because that would only work with
		# the default port. Using both permanent and not permanent rules to
		# avoid a firewalld reload.
		if [[ "$PROTOCOL" = 'UDP' ]]; then
			firewall-cmd --zone=public --add-port=$PORT/udp
			firewall-cmd --permanent --zone=public --add-port=$PORT/udp
		elif [[ "$PROTOCOL" = 'TCP' ]]; then
			firewall-cmd --zone=public --add-port=$PORT/tcp
			firewall-cmd --permanent --zone=public --add-port=$PORT/tcp
		fi
		firewall-cmd --zone=trusted --add-source=10.8.0.0/24
		firewall-cmd --permanent --zone=trusted --add-source=10.8.0.0/24
	fi
	if iptables -L -n | grep -qE 'REJECT|DROP'; then
		# If iptables has at least one REJECT rule, we asume this is needed.
		# Not the best approach but I can't think of other and this shouldn't
		# cause problems.
		if [[ "$PROTOCOL" = 'UDP' ]]; then
			iptables -I INPUT -p udp --dport $PORT -j ACCEPT
		elif [[ "$PROTOCOL" = 'TCP' ]]; then
			iptables -I INPUT -p tcp --dport $PORT -j ACCEPT
		fi
		iptables -I FORWARD -s 10.8.0.0/24 -j ACCEPT
		iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
		# Save persitent OpenVPN rules
        iptables-save > $IPTABLES
	fi
	# If SELinux is enabled and a custom port was selected, we need this
	if hash sestatus 2>/dev/null; then
		if sestatus | grep "Current mode" | grep -qs "enforcing"; then
			if [[ "$PORT" != '443' ]]; then
				# semanage isn't available in CentOS 6 by default
				if ! hash semanage 2>/dev/null; then
					yum install policycoreutils-python -y
				fi
				if [[ "$PROTOCOL" = 'UDP' ]]; then
					semanage port -a -t openvpn_port_t -p udp $PORT
				elif [[ "$PROTOCOL" = 'TCP' ]]; then
					semanage port -a -t openvpn_port_t -p tcp $PORT
				fi
			fi
		fi
	fi
	# And finally, restart OpenVPN
	if [[ "$OS" = 'debian' ]]; then
		# Little hack to check for systemd
		if pgrep systemd-journal; then
				#Workaround to fix OpenVPN service on OpenVZ
				sed -i 's|LimitNPROC|#LimitNPROC|' /lib/systemd/system/openvpn\@.service
				sed -i 's|/etc/openvpn/server|/etc/openvpn|' /lib/systemd/system/openvpn\@.service
				sed -i 's|%i.conf|server.conf|' /lib/systemd/system/openvpn\@.service
				systemctl daemon-reload
				systemctl restart openvpn
				systemctl enable openvpn
		else
			/etc/init.d/openvpn restart
		fi
	else
		if pgrep systemd-journal; then
			if [[ "$OS" = 'arch' || "$OS" = 'fedora' ]]; then
				#Workaround to avoid rewriting the entire script for Arch & Fedora
				sed -i 's|/etc/openvpn/server|/etc/openvpn|' /usr/lib/systemd/system/openvpn-server@.service
				sed -i 's|%i.conf|server.conf|' /usr/lib/systemd/system/openvpn-server@.service
				systemctl daemon-reload
				systemctl restart openvpn-server@openvpn.service
				systemctl enable openvpn-server@openvpn.service
			else
				systemctl restart openvpn@server.service
				systemctl enable openvpn@server.service
			fi
		else
			service openvpn restart
			chkconfig openvpn on
		fi
	fi
	# If the server is behind a NAT, use the correct IP address
	if [[ "$PUBLICIP" != "" ]]; then
		IP=$PUBLICIP
	fi
	# client-template.txt is created so we have a template to add further users later
	echo "client" > /etc/openvpn/client-template.txt
	if [[ "$PROTOCOL" = 'UDP' ]]; then
		echo "proto udp" >> /etc/openvpn/client-template.txt
	elif [[ "$PROTOCOL" = 'TCP' ]]; then
		echo "proto tcp-client" >> /etc/openvpn/client-template.txt
	fi
	echo "dev tun
proto $PROTOCOL
sndbuf 0
rcvbuf 0
setenv opt method GET
remote portalrecarga.vivo.com.br/recarga $PORT
http-proxy $IP 80
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
verify-x509-name $SERVER_NAME name
auth SHA256
auth-nocache
$CIPHER
tls-client
tls-version-min 1.2
tls-cipher TLS-DHE-RSA-WITH-AES-128-GCM-SHA256
setenv opt block-outside-dns
verb 3" >> /etc/openvpn/client-template.txt

	# Generate the custom client.ovpn
	newclient "$CLIENT"
	echo ""
	echo "Finished!"
	echo ""
	echo "Your client config is available at $homeDir/$CLIENT.ovpn"
	echo "If you want to add more clients, you simply need to run this script another time!"
fi
exit 0;
