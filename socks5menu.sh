 #!/bin/bash

checkdatabase
ip=$(wget -qO- ipv4.icanhazip.com)
if [ $(id -u) -eq 0 ]
then
clear
else
echo -e "Execute o script como usuario \033[1;32mroot\033[0m"
exit
fi
if [ -d /etc/VpsPackdir ]
then
true
else
mkdir /etc/VpsPackdir
fi
if [ -d /etc/VpsPackdir/senha ]
then
true
else
mkdir /etc/VpsPackdir/senha
fi
if [ -d /etc/VpsPackdir/limite ]
then
true
else
mkdir /etc/VpsPackdir/limite
fi

clear
if [[ $1 == "" ]]
then
clear
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
echo -e "\033[7;30;46m ==========================================================\033[0m"
echo -e "\033[7;30;47m  DATA:\033[0m\033[7;30;41m $dia/$mes/$ano\033[0m"
echo -e "\033[7;30;47m  IP da VPS:\033[0m\033[7;30;41m $ip\033[0m"
system=$(cat /etc/issue.net)
if [ "$system" ]
then
echo -e "\033[7;30;47m  Sistema Operacional:\033[0m\033[7;30;41m $system\033[0m"
else
echo -e "\033[7;30;47m  Sistema Operacional:\033[0m\033[7;30;41mNot Available\033[0m"
fi
echo -e "\033[7;30;46m ==========================================================\033[0m"
echo -e "\033[7;30;47m  ®Script\033[0m \033[7;30;41mEdited:\033[0m \033[0m \033[0;36;40m@Colt\033[5;37;40mSeals\033[0m"
echo -e "\033[7;30;47m  ®TELEGRAM\033[0m \033[7;30;41mCANAL:\033[0m \033[0m \033[0;36;40m@Vps\033[5;37;40mNerdologia\033[0m"
echo -e "\033[7;30;46m ==========================================================\033[0m"
echo -e "\033[7;30;46m  Para Acessar este menu digite:\033[5;37;40m VPN \033[0m"
echo -e "\033[7;30;46m ==========================================================\033[0m"
NUMBER=$(ps -x | grep -c "socks5.py")
if [ $NUMBER = "2" ]; then
  PORT=$(cat /home/DATABASE/SOCKS5/socks5.py | sed -n '300p' | cut -d "=" -f2 | cut -d " " -f2)
  echo -e "\033[01;35m-\033[01;32m ESTADO:\033[01;32m ATIVO"
  echo -e "\033[01;35m-\033[01;32m PORTA:\033[01;33m $PORT"
  echo ""
  echo -e "\033[01;35m -------------------------------------------------"
  echo -e "\033[01;32m  1 \033[01;35m-\033[01;33m ALTERAR MENSAGEM\033[01;36m(Status: 200)."
  echo -e "\033[01;32m  2 \033[01;35m-\033[01;33m ALTERAR PORTA."
  echo -e "\033[01;32m  3 \033[01;35m-\033[01;31m DESATIVAR\033[01;33m SOCKS5."
  echo -e "\033[01;32m  0 \033[01;35m-\033[01;33m MENU INICIAL"
  echo -e "\033[01;35m -------------------------------------------------"
  echo -ne "\033[1;33m  OPÇÃO \033[01;32m[1-3]\033[1;37m:"; read NUMBERS
  case $NUMBERS in
    1) socks5banner;;
    2) socks5changeport;;
    3) echo ""
          echo -e "\033[01;37mAguarde..."
          pkill -f socks5.py
          sleep 3s
          socks5menu
          exit;;
    0) vpn;;
      *) socks5menu;;
  esac
else
  PORT=$(cat /home/DATABASE/SOCKS5/socks5.py | sed -n '300p' | cut -d "=" -f2 | cut -d " " -f2)
  echo -e "\033[01;35m-\033[01;32m ESTADO:\033[01;31m DESATIVADO"
  echo -e "\033[01;35m-\033[01;32m PORTA:\033[01;37m $PORT"
  echo ""
  echo -e "\033[01;35m -------------------------------------------------"
  echo -e "\033[01;32m  1 \033[01;35m-\033[01;33m ALTERAR MENSAGEM\033[01;36m(Status: 200)."
  echo -e "\033[01;32m  2 \033[01;35m-\033[01;33m ALTERAR PORTA."
  echo -e "\033[01;32m  3 \033[01;35m-\033[01;32m ATIVAR\033[01;33m SOCKS5."
  echo -e "\033[01;32m  0 \033[01;35m-\033[01;33m MENU INICIAL"
  echo -e "\033[01;35m -------------------------------------------------"
  echo -ne "\033[1;33m  OPÇÃO \033[01;32m[1-3]\033[1;37m:"; read NUMBERS
  case $NUMBERS in
    1) socks5banner;;
    2) socks5changeport;;
    3) echo ""
          echo -e "\033[01;37mAguarde..."
          nohup python /home/DATABASE/SOCKS5/socks5.py&> /dev/null &
          sleep 3s
          socks5menu
          exit;;
    0) vpn;;
      *) socks5menu;;
  esac
fi
    
  
  
  
  
  
