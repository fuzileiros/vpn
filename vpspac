#!/bin/bash

if [ $(id -u) -eq 0 ]
then
	clear
else
	if echo $(id) |grep sudo > /dev/null
	then
	clear
	echo "Voce não é root"
	echo "Seu usuario esta no grupo sudo"
	echo -e "Para virar root execute \033[1;31msudo su\033[0m"
	exit
	else
	clear
	echo -e "Vc nao esta como usuario root, nem com seus direitos (sudo)\nPara virar root execute \033[1;31msu\033[0m e digite sua senha root"
	exit
	fi
fi

if [ -d /etc/VpsPackdir ]
then
echo ""
else
mkdir /etc/VpsPackdir
fi

if [ -d /etc/VpsPackdir/senha ]
then
echo ""
else
mkdir /etc/VpsPackdir/senha
fi

if [ -d /etc/VpsPackdir/limite ]
then
echo ""
else
mkdir /etc/VpsPackdir/limite
fi

clear
echo -e "\033[1;37m•••••> © Edited @ColtSeals & TecnologY \033[0m"
echo -e "\033[1;32m•••••> TELEGRAM GRUPO: @NerdologiaVps"
echo -e "\033[1;32m•••••> TELEGRAM CANAL: @VpsNerdologia"
echo -e "\033[1;37mEscolha uma opção:    Para Sair Ctrl + C\033[1;33m"
echo -e "\033[01;36m[\033[1;37m01\033[1;36m]\033[01;37m Configurar_Squid_SSH \033[01;32m(Squid e openssh configuração)\033[0m"
echo -e "\033[01;36m[\033[1;37m02\033[1;36m]\033[01;37m Limite \033[01;32m(Limite de conexões simultaneas)\033[0m"
echo -e "\033[01;36m[\033[1;37m03\033[1;36m]\033[01;37m Criar_Usuario \033[01;32m(Criar usuarios)\033[0m"
echo -e "\033[01;36m[\033[1;37m04\033[1;36m]\033[01;37m OpenVPN \033[01;32m(Configurar e Gerenciar Usuarios .ovpn)\033[0m"
echo -e "\033[01;36m[\033[1;37m05\033[1;36m]\033[01;37m Remover_expirados \033[01;32m(Remover usuarios já expirados)\033[0m"
echo -e "\033[01;36m[\033[1;37m06\033[1;36m]\033[01;37m Criar_Teste \033[01;32m(Criar usuarios de curta duração)\033[0m"
echo -e "\033[01;36m[\033[1;37m07\033[1;36m]\033[01;37m BadVpn \033[01;32m(Instala badvpn para tunnel udp)\033[0m"
echo -e "\033[01;36m[\033[1;37m08\033[1;36m]\033[01;37m BadVpn_Start \033[01;32m(Ativa chamadas voip, jogos online, etc)\033[0m"
echo -e "\033[01;36m[\033[1;37m09\033[1;36m]\033[01;37m BadVpn_Stop \033[01;32m(Parar serviço do badvpn)\033[0m"
echo -e "\033[01;36m[\033[1;37m10\033[1;36m]\033[01;37m Monitorar \033[01;32m(Monitorar conexões atuais)\033[0m"
echo -e "\033[01;36m[\033[1;37m11\033[1;36m]\033[01;37m Remover_Limite \033[01;32m(Remover limite de conexoes de um usuario)\033[0m"
echo -e "\033[01;36m[\033[1;37m12\033[1;36m]\033[01;37m Mudar_Nome \033[01;32m(Mudar nome de um usuario)\033[0m"
echo -e "\033[01;36m[\033[1;37m13\033[1;36m]\033[01;37m Redefinir_Usuario \033[01;32m(Redefinir Data, senha, etc)\033[0m"
echo -e "\033[01;36m[\033[1;37m14\033[1;36m]\033[01;37m Deletar_Usuario \033[01;32m(Menu Deletar, Desconectar, etc)\033[0m"
echo -e "\033[01;36m[\033[1;37m15\033[1;36m]\033[01;37m Firewall_block \033[01;32m(bloquear torrent, icmp)\033[1;31m[RISCOS]"
echo -e "\033[01;36m[\033[1;37m15\033[1;36m]\033[01;37m Reset_Firewall \033[01;32m(Resetar regras iptables)\033[1;31m[RISCOS]"
echo -e "\033[01;36m[\033[1;37m17\033[1;36m]\033[01;37m Addhost \033[01;32m(Adicionar Hosts aceitos pelo squid)\033[0m"
echo -e "\033[01;36m[\033[1;37m18\033[1;36m]\033[01;37m Remover_Host \033[01;32m(Remover Hosts aceitos pelo squid)\033[0m"
echo -e "\033[01;36m[\033[1;37m19\033[1;36m]\033[01;37m Backup-Users \033[01;32m(Backup dos usuarios)\033[0m"
echo -e "\033[01;36m[\033[1;37m20\033[1;36m]\033[01;37m Rest-Users \033[01;32m(Restaurar usuarios feito backup)\033[0m"
echo -e "\033[01;36m[\033[1;37m21\033[1;36m]\033[01;37m Usuarios_Detalhes \033[01;32m(Informações sobre os usuarios)\033[0m"
echo -e "\033[01;36m[\033[1;37m22\033[1;36m]\033[01;37m Banner \033[01;32m(Adicionar um banner)\033[0m"
echo -e "\033[01;36m[\033[1;37m23\033[1;36m]\033[01;37m Speedtest \033[01;32m(Teste de conexão [velocidade de banda])\033[0m"
echo -e "\033[01;36m[\033[1;37m24\033[1;36m]\033[01;37m ClearCache \033[01;32m(Limpa Cache e Swap do servidor)\033[0m"
echo -e "\033[01;36m[\033[1;37m25\033[1;36m]\033[01;37m VNC \033[01;32m(Ativa a Interface Gráfica no Servidor)\033[0m"
echo -e "\033[01;36m[\033[1;37m26\033[1;36m]\033[01;37m TCPTweaker \033[01;32m(Melhora a velocidade e desempenho da VPS)\033[0m"
echo -e "\033[01;36m[\033[1;37m27\033[1;36m]\033[01;37m Deletar_Todos \033[01;32m(Todos os usuarios serão deletados)\033[0m"
echo -e "\033[01;36m[\033[1;37m28\033[1;36m]\033[01;37m Ajuda \033[01;32m(Informações sobre cada opção do MenuVPS)\033[0m"
echo -e "\033[01;36m[\033[1;37m29\033[1;36m]\033[01;37m Créditos \033[01;32m(Informações sobre o Editor)\033[0m"
echo -e "\033[01;36m[\033[1;37m30\033[1;36m]\033[01;37m Telegram \033[01;32m(Canais & Grupo Oficial ENTREM!)\033[0m"
echo -e "\033[01;36m[\033[1;37m31\033[1;36m]\033[01;37m Desinstalar \033[01;32m(Remover MenuVPS)\033[0m"
read -p ": " opcao
else
opcao=$1
fi
case $opcao in
  1 | 01 )
   ConfSquid;;
  2 | 02 )
   limite;;
  3 | 03 )
   criarusuario;;
  4 | 04 )
   OpenVPN;;
  5 | 05 )
   RemoverExpirados;;
  6 | 06 )
   Teste;;
  7 | 07 )
   BadVpn.sh;;
  8 | 08 )
   badvpn start;;
  9 | 09 )
   badvpn stop;;
  10)
   Monitorar;; 
  11)
   RemoverLimite;;
  12)
   MudarNome;;
  13)
   RedefinirUsuario;;
  14)
   DeletarUsuario;;
  15)
   FirewallBlock;;
  16)
   FirewallReset;;
  17)
   AddHost;;
  18)
   RemoverHost;;
  19)
   Backup;;
  20)
   RedefinirUsuario;;
  21)
   DetalhesUsuarios;;
  22)
   Banner;;
  23)
   speedtest.py;;
  24)
   LimpadorCache;;
  25)
   VNC;;
  26)
   tcptweaker;;
  27)
   DeletarTodos;;
  28)
   Ajuda;;
  29)
   Creditos;;
  30)
  Telegram;;
  31)
   Desinstalar;;
     32)
   SistemaDetalhes;;
  
esac
