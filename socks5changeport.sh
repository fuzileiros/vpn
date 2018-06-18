#!/bin/bash

SOCKS5="/home/DATABASE/SOCKS5/socks5.py"

clear
echo -e "\033[01;36mSOCKS5 RODANDO NA PORTA:\033[01;32m 0: RETORNAR AO MENU."
echo ""
echo -ne "\033[01;33m"; cat $SOCKS5 | sed -n '300p' | awk -F "=" '{print $2}' | awk -F " " '{print $1}'
echo ""
echo -ne "\033[01;36mPorta para alterar:\033[01;37m "; read PORT
if [ -z $PORT ]; then
  echo ""
  echo -e "\033[01;37;41mVocê digitou uma porta vazia. Tente novamente!\033[0m"
  sleep 3s
  socks5changeport
  exit
else
if [ "$PORT" = "0" ]; then
  socks5menu
  exit
else
if echo "$PORT" | grep -q '[^0-9]'; then
  echo ""
  echo -e "\033[01;37;41mPorta inválida. Tente novamente!\033[0m"
  sleep 3s
  socks5changeport
  exit
else
if cat /etc/ssh/sshd_config | grep "Port" | cut -d " " -f2 | grep -xq "$PORT"; then
  echo ""
  echo -e "\033[01;37;41mOps! Esta porta já está em uso. Tente outra porta!\033[0m"
  sleep 3s
  socks5changeport
  exit
else
if cat /etc/default/dropbear | grep -q "$PORT"; then
  echo ""
  echo -e "\033[01;37;41mOps! Esta porta já está em uso. Tente outra porta!\033[0m"
  sleep 3s
  socks5changeport
  exit
else
if cat /etc/squid/squid.conf | grep "http_port" | cut -d " " -f2 | grep -xq "$PORT"; then
  echo ""
  echo -e "\033[01;37;41mOps! Esta porta já está em uso. Tente outra porta!\033[0m"
  sleep 3s
  socks5changeport
  exit
else
if cat /etc/squid3/squid.conf | grep "http_port" | cut -d " " -f2 | grep -xq "$PORT"; then
  echo ""
  echo -e "\033[01;37;41mOps! Esta porta já está em uso. Tente outra porta!\033[0m"
  sleep 3s
  socks5changeport
  exit
else
  NUMBER=$(ps -x | grep -c "socks5.py")
  if [ $NUMBER = "2" ]; then
    OLOCO=$(cat $SOCKS5 | sed -n '300p' | awk -F "=" '{print $2}')
    cat $SOCKS5 | sed "s/$OLOCO/ $PORT/g" > socks5.txt
    mv socks5.txt $SOCKS5
    pkill -f socks5.py
    nohup python /home/DATABASE/SOCKS5/socks5.py&> /dev/null &
  else
    OLOCO=$(cat $SOCKS5 | sed -n '300p' | awk -F "=" '{print $2}')
    cat $SOCKS5 | sed "s/$OLOCO/ $PORT/g" > socks5.txt
    mv socks5.txt $SOCKS5
  fi
  clear
  echo -e "\033[01;36mSOCKS5 RODANDO NA PORTA:\033[01;32m 0: RETORNAR AO MENU."
  echo ""
  echo -ne "\033[01;33m"; cat $SOCKS5 | sed -n '300p' | awk -F "=" '{print $2}' | awk -F " " '{print $1}'
  echo ""
  echo -e "\033[01;32mPorta alterada com sucesso!"
  echo -e "\033[01;32mPorta: $PORT"
fi
fi
fi
fi
fi
fi
fi
echo ""
echo -ne "\033[01;36mAPERTE A TECLA ENTER..."
read ENTER
socks5changeport
exit