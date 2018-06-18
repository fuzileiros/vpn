#!/bin/bash

SOCKS5="/home/DATABASE/SOCKS5/socks5.py"

clear
echo -e "\033[01;36mBANNER ATUAL: \033[01;32m0: RETORNAR AO MENU."
echo ""
echo -ne "\033[01;33m"; cat $SOCKS5 | sed -n '64p' | cut -d "," -f2 | sed "s/'//g" | sed "s/)//g" | cut -d " " -f2 
echo ""
echo -ne "\033[01;36mDigite uma mensagem:\033[01;37m "; read BANNER
if [ -z $BANNER ]; then
  echo ""
  echo -e "\033[01;37;41mVocê digitou uma mensagem vazia. Tente novamente.\033[0m"
  sleep 3s
  socks5banner
  exit
else
if [ "$BANNER" = "0" ]; then
  vpn
  exit
else
  NUMBER=$(ps -x | grep -c "socks5.py")
  if [ $NUMBER = "2" ]; then
    OLOCO=$(cat $SOCKS5 | sed -n '64p' | awk -F "," '{print $2}')
    cat $SOCKS5 | sed "s/$OLOCO/'$BANNER')/g" > socks5.txt
    mv socks5.txt $SOCKS5
    pkill -f socks5.py
    nohup python /home/DATABASE/SOCKS5/socks5.py&> /dev/null &
  else
    OLOCO=$(cat $SOCKS5 | sed -n '64p' | awk -F "," '{print $2}')
    cat $SOCKS5 | sed "s/$OLOCO/'$BANNER')/g" > socks5.txt
    mv socks5.txt $SOCKS5
  fi
  clear
  echo -e "\033[01;36mBANNER ATUAL: \033[01;32m0: RETORNAR AO MENU."
  echo ""
  echo -ne "\033[01;33m"; cat $SOCKS5 | sed -n '64p' | cut -d "," -f2 | sed "s/'//g" | sed "s/)//g" | cut -d " " -f2
  echo ""
  echo -e "\033[01;32mMensagem alterada com sucesso!"
fi
fi
echo ""
echo -ne "\033[01;36mAPERTE A TECLA ENTER..."
read ENTER
socks5banner
exit
