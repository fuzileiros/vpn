 #!/bin/bash

checkdatabase

clear
echo -e "\033[01;35m -------------------------------------------------"
echo -e "\033[01;35m|                  \033[01;33m    ADM VPS\033[01;35m                   |"
echo -e "\033[01;35m -------------------------------------------------"
echo ""
NUMBER=$(ps -x | grep -c "sleep")
if [ $NUMBER = "2" ]; then
  echo -e "\033[01;35m   •\033[01;33m ESTADO:\033[01;32m ATIVO"
  NUMBER2=$(awk 'END{print NR}' /home/DATABASE/messages.txt)
  if [ "$NUMBER2" -gt "0" ]; then
    echo -e "\033[01;35m   •\033[01;33m NOTIFICAÇÕES:\033[01;32m ● "
  else
    echo -e "\033[01;35m   •\033[01;33m NOTIFICAÇÕES:\033[01;31m ● "
  fi
  echo -e "\033[01;35m -------------------------------------------------"
  echo -e "\033[01;32m   1 \033[01;35m•\033[01;31m  DESATIVAR\033[01;33m LIMITADOR."
  echo -e "\033[01;32m   2 \033[01;35m•\033[01;33m  VERIFICAR NOTIFICAÇÕES."
  echo -e "\033[01;32m   0 \033[01;35m•\033[01;33m  VOLTAR."
  echo -e "\033[01;35m -------------------------------------------------"
  echo -ne "\033[1;33m  OPÇÃO \033[01;32m[1-2]\033[1;37m:"; read NUMBERS
  case $NUMBERS in
    1) echo ""
          echo -e "\033[01;37mAguarde..."
          pkill -f limiter-start
          sleep 3s
          clear
          limiter-menu
          exit;;
    2) limiter-messages;;
    0) h;;
      *) limiter-menu;;
  esac
else
  echo -e "\033[01;35m   •\033[01;33m ESTADO:\033[01;31m DESATIVADO"
  NUMBER2=$(awk 'END{print NR}' /home/DATABASE/messages.txt)
  if [ "$NUMBER2" -gt "0" ]; then
    echo -e "\033[01;35m   •\033[01;33m NOTIFICAÇÕES:\033[01;32m ●"
  else
    echo -e "\033[01;35m   •\033[01;33m NOTIFICAÇÕES:\033[01;31m ●"
  fi
  echo -e "\033[01;35m -------------------------------------------------"
  echo -e "\033[01;32m   1 \033[01;35m•\033[01;32m  ATIVAR\033[01;33m LIMITADOR."
  echo -e "\033[01;32m   2 \033[01;35m•\033[01;33m  VERIFICAR NOTIFICAÇÕES."
  echo -e "\033[01;32m   0 \033[01;35m•\033[01;33m  VOLTAR."
  echo -e "\033[01;35m -------------------------------------------------"
  echo -ne "\033[1;33m  OPÇÃO \033[01;32m[1-2]\033[1;37m:"; read NUMBERS
  case $NUMBERS in
    1) echo ""
          echo -e "\033[01;37mAguarde..."
          screen -dmS screen limiter-start
          sleep 3s
          clear
          limiter-menu
          exit;;
    2) limiter-messages;;
    0) h;;
      *) limiter-menu;;
  esac
fi
