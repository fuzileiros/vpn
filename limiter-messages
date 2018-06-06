#!/bin/bash

MESSAGES="/home/DATABASE/messages.txt"

clear
echo -e "\033[01;32mUsuários que ultrapassaram o N° de conexões simultâneas permitidas:"
echo ""
NUMBER=$(cat $MESSAGES | wc -l)
if [ $NUMBER = "0" ]; then
  echo -e "\033[01;33mVocê não possui nenhuma mensagem no momento!"
  echo ""
  echo -e "\033[01;36mAPERTE A TECLA ENTER PARA VOLTAR AO MENU..."
  read ENTER
  limiter-menu
  exit
else
  echo -ne "\033[01;32m"; cat $MESSAGES
  rm $MESSAGES
  touch $MESSAGES
fi
echo ""
echo -e "\033[01;36mAPERTE A TECLA ENTER PARA VOLTAR AO MENU..."
read ENTER
limiter-menu
exit






