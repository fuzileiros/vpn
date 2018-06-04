
echo -e "\033[5;36;40m ==========================================================\033[0m"
echo -e "\033[7;30;47m  Iniciando Testes:\033[0m \033[7;30;41m\033[0m \033[0m\033[0;36;40m\033[5;37;40m Aguarde...\033[0m"
echo -e "\033[5;36;40m ==========================================================\033[0m"
sleep 0.6
clear
echo -e "\033[5;36;40m ==========================================================\033[0m"
ping=$(ping -c1 google.com |awk '{print $8 $9}' |grep -v loss |cut -d = -f2 |sed ':a;N;s/\n//g;ta')
starts_test=$(python ./speedtest)
down_load=$(echo "$starts_test" | grep "Download" | awk '{print $2,$3}')
up_load=$(echo "$starts_test" | grep "Upload" | awk '{print $2,$3}')

echo -e "\033[8;37;40mTempo de Resposta Ping:\033[5;32;40m $ping \033[0m"
echo -e "\033[8;37;40mVelocidade de Upload:\033[5;32;40m $up_load \033[0m"
echo -e "\033[8;37;40mVelocidade de Download:\033[5;32;40m $down_load \033[0m"
