#!/bin/bash

DATABASE="/home/DATABASE/users.db"

while true; do
  clear
  echo ""
  echo -ne " \033[01;37;44m"; printf '%38s%-28s\n' "Monitoring"; echo -ne "\033[0m"
  echo -ne " \033[01;37;44m"; printf '%-52s%s\n' " Usuário" "Conexão/Limite "; echo -e "\033[0m"
  cat $DATABASE | sort | while read DB; do
    MONITORING1=$(echo $DB | cut -d " " -f1)
    MONITORING2=$(ps -u $MONITORING1 | grep sshd | wc -l)
    MONITORING3=$(echo $DB | cut -d " " -f3)
    ps x | grep [[:space:]]$MONITORING1[[:space:]] | grep -v grep | grep -v pts > /tmp/connections
    echo -ne " \033[01;37m"; printf '%-57s%s\n' " $MONITORING1" "$MONITORING2/$MONITORING3 "
    if [ "$MONITORING2" -gt "$MONITORING3" ]; then
      while read CONNECTION; do
        kill $(echo $CONNECTION | cut -d " " -f1)
        echo -e "Nome do usuário: $MONITORING1\nN° de conexões simultâneas permitidas: $MONITORING3\nQuantidade identificada: $MONITORING2\nData: $(date "+%d/%m/%Y às %H:%M:%S")\n" >> /home/DATABASE/messages.txt
        exit
      done < /tmp/connections
    fi
  done
  sleep 5s
done








