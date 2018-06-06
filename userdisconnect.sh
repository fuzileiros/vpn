#!/bin/bash

clear
echo -e "\033[01;36mLista de usuários e estado de conexão do mesmo:"
echo ""
NUMBER=$(awk  -F : '$3 >= 500 {print  $1}'  /etc/passwd | grep -v "nobody" | sort | wc -l)
if [ $NUMBER = "0" ]; then
  echo -e "\033[01;33mVocê não possui nenhum usuário SSH criado no momento!"
  echo ""
  echo -e "\033[01;33mCrie um usuário SSH para prosseguir com esta função!"
  echo ""
  echo -e "\033[01;36mAPERTE A TECLA ENTER PARA VOLTAR AO MENU..."
  read ENTER
  vpn
  exit
else
  for USERS in `awk  -F : '$3 >= 500 {print  $1}'  /etc/passwd | grep -v "nobody" | sort`; do
    NUMBER=$(ps -u $USERS | grep sshd | wc -l)
    if [ "$NUMBER" -gt "0" ]; then
      echo -ne "\033[01;33m$(printf '%-36s%s\n' " $USERS")"; echo -e "\033[01;32m ONLINE"
    else
      echo -ne "\033[01;33m$(printf '%-36s%s\n' " $USERS")"; echo -e "\033[01;31m OFFLINE"
    fi
  done
fi
echo ""
echo -e "\033[01;32m0: RETORNAR AO MENU."
echo -e "\033[01;32m*: ATUALIZAR."
echo ""
echo -ne "\033[01;36mNome do usuário para desconectar:\033[01;37m "; read USER
if [ -z $USER ]; then
  echo ""
  echo -e "\033[01;37;41mVocê digitou um nome de usuário vazio. Tente novamente!\033[0m"
  sleep 3s
  userdisconnect
  exit
else
if [ "$USER" = "0" ]; then
  vpn
  exit
else
if [ "$USER" = "*" ]; then
  userdisconnect
  exit
else
  awk  -F : '$3 >= 500 {print  $1}'  /etc/passwd | grep -v "nobody" | sort > /tmp/users.txt
if [[ `grep -cx "$USER" /tmp/users.txt` -ne 1 ]]; then
  echo ""
  echo -e "\033[01;37;41mVocê digitou um nome de usuário inexistente. Digite um nome de\033[0m"; echo -e "\033[01;37;41musuário que seja existente na lista acima. Tente novamente!   \033[0m"
  sleep 7s
  userdisconnect
  exit
else
  NUMBER=$(ps -u $USER | grep sshd | wc -l)
if [ "$NUMBER" -gt "0" ]; then
  clear
  pkill -f $USER
  userdisconnect
  exit
else
  echo ""
  echo -e "\033[01;37;41mEste usuário não está CONECTADO. Tente novamente!\033[0m"
  sleep 3s
  userdisconnect
  exit
fi
fi
fi
fi
fi
  
  
  
  
  
