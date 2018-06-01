#!/bin/bash
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%30s%s%-15s\n' "Criar UsuÃ¡rio SSH" ; tput sgr0
echo ""
read -p "Nome do usuÃ¡rio: " username
awk -F : ' { print $1 }' /etc/passwd > /tmp/users 
if grep -Fxq "$username" /tmp/users
then
	tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Este usuÃ¡rio jÃ¡ existe. Crie um usuÃ¡rio com outro nome." ; echo "" ; tput sgr0
	exit 1	
else
	if (echo $username | egrep [^a-zA-Z0-9.-_] &> /dev/null)
	then
		tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "VocÃª digitou um nome de usuÃ¡rio invÃ¡lido!" ; tput setab 1 ; echo "Use apenas letras, nÃºmeros, pontos e traÃ§os." ; tput setab 4 ; echo "NÃ£o use espaÃ§os, acentos ou caracteres especiais!" ; echo "" ; tput sgr0
		exit 1
	else
		sizemin=$(echo ${#username})
		if [[ $sizemin -lt 2 ]]
		then
			tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "VocÃª digitou um nome de usuÃ¡rio muito curto," ; echo "use no mÃ­nimo dois caracteres!" ; echo "" ; tput sgr0
			exit 1
		else
			sizemax=$(echo ${#username})
			if [[ $sizemax -gt 32 ]]
			then
				tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "VocÃª digitou um nome de usuÃ¡rio muito grande," ; echo "use no mÃ¡ximo 32 caracteres!" ; echo "" ; tput sgr0
				exit 1
			else
				if [[ -z $username ]]
				then
					tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "VocÃª digitou um nome de usuÃ¡rio vazio!" ; echo "" ; tput sgr0
					exit 1
				else	
					read -p "Senha: " password
					if [[ -z $password ]]
					then
						tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "VocÃª digitou uma senha vazia!" ; echo "" ; tput sgr0
						exit 1
					else
						sizepass=$(echo ${#password})
						if [[ $sizepass -lt 6 ]]
						then
							tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "VocÃª digitou uma senha muito curta!" ; echo "Para manter o usuÃ¡rio seguro use no mÃ­nimo 6 caracteres" ; echo "combinando diferentes letras e nÃºmeros!" ; echo "" ; tput sgr0
							exit 1
						else	
							read -p "Dias para expirar: " dias
							if (echo $dias | egrep '[^0-9]' &> /dev/null)
							then
								tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "VocÃª digitou um nÃºmero de dias invÃ¡lido!" ; echo "" ; tput sgr0
								exit 1
							else
								if [[ -z $dias ]]
								then
									tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "VocÃª deixou o nÃºmero de dias para a conta expirar vazio!" ; echo "" ; tput sgr0
									exit 1
								else	
									if [[ $dias -lt 1 ]]
									then
										tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "VocÃª deve digitar um nÃºmero de dias maior que zero!" ; echo "" ; tput sgr0
										exit 1
									else
										read -p "NÂº de conexÃµes simultÃ¢neas permitidas: " sshlimiter
										if (echo $sshlimiter | egrep '[^0-9]' &> /dev/null)
										then
											tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "VocÃª digitou um nÃºmero de conexÃµes invÃ¡lido!" ; echo "" ; tput sgr0
											exit 1
										else
											if [[ -z $sshlimiter ]]
											then
												tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "VocÃª deixou o nÃºmero de conexÃµes simultÃ¢neas vazio!" ; echo "" ; tput sgr0
												exit 1
											else
												if [[ $sshlimiter -lt 1 ]]
												then
													tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "VocÃª deve digitar um nÃºmero de conexÃµes simultÃ¢neas maior que zero!" ; echo "" ; tput sgr0
													exit 1
												else
													final=$(date "+%Y-%m-%d" -d "+$dias days")
													gui=$(date "+%d/%m/%Y" -d "+$dias days")
													pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
													useradd -e $final -M -s /bin/false -p $pass $username
													[ $? -eq 0 ] && tput setaf 2 ; tput bold ; echo ""; echo "UsuÃ¡rio $username criado" ; echo "Data de expiraÃ§Ã£o: $gui" ; echo "NÂº de conexÃµes simultÃ¢neas permitidas: $sshlimiter" ; echo "" || echo "NÃ£o foi possÃ­vel criar o usuÃ¡rio!" ; tput sgr0
													echo "$username $sshlimiter" >> /root/usuarios.db
													egrep "^$username" /etc/passwd > /tmp/pss1
													sed "s/false/sh/" /tmp/pss1 > /tmp/pss2
													grep -v "^$username*" /etc/passwd > /tmp/pss3 && mv /tmp/pss3 /etc/passwd && cat /tmp/pss2 >> /etc/passwd
													rm /tmp/pss* > /dev/null 2>&1
												fi
											fi
										fi
									fi
								fi
							fi
						fi
					fi
				fi
			fi
		fi
	fi	
fi
