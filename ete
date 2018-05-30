#!/bin/bash

CAMINHO_HOSTS="/etc/hosts"

echo "Entre com o novo ip"
read ip_novo
echo "Entre com o nome da máquina"
read nome_novo

echo "" > $CAMINHO_HOSTS
sed "1i 127.0.0.1           localhost  localhost.domain" $CAMINHO_HOSTS -i
sed "2i $ip_novo         $nome_novo  $nome_novo.vbs.corp" $CAMINHO_HOSTS -i
sed "3i \ " $CAMINHO_HOSTS -i
