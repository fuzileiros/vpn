 #!/bin/bash

checkdatabase

clear
echo -e "\033[01;35m -------------------------------------------------"
echo -e "\033[01;35m|                  \033[01;33m    ADM VPS\033[01;35m                   |"
echo -e "\033[01;35m -------------------------------------------------"
echo ""
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
    0) h;;
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
    0) h;;
      *) socks5menu;;
  esac
fi
    
  
  
  
  
  