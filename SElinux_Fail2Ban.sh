#!/bin/bash

cat << END

Escolha, por favor, uma das seguintes opcoes:

1: Entrar nas opções do SElinux
2: Entrar nas opções do Fail2Ban
3: Fechar o programa

END

while true;do
read -p ": " opcao
	case $opcao in
	1)
	echo ""
	cat << END
	
Escolha, por favor, uma das seguintes opcoes:

1: Ativar de forma permanente o modo "Enforcing"
2: Monitorizar logs 

END
	while true;do
	read -p ": " w
		case $w in
		1)
		echo ""
		echo "---- A ativar o enforcing de modo permamente ----"
		sudo setenforce 1
		sudo sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config
		echo ""
		;;
		2)
		echo "----- A verificar ferramentas de logs -----"
		if rpm -q setroubleshoot-server &> /dev/null; then
			echo "Já instalou! A passar para o próximo menu..."
			sleep 2 
		else
			echo "----- A instalar as ferramentas necessárias para ver os logs -----"
			sudo dnf install setroubleshoot-server -y
			echo "Instalação concluída!"
		fi
		echo ""
		read -p "Nas logs, queres ver os alertas ou ver alguma falha? Escreve alerta (para ver os alertas) ou falha (para ver alguma falha): " logs 
		if [ $logs = alerta ]; then
			echo ""
			echo " ----- A apresentar alertas ----- "
			sudo sealert -a /var/log/audit/audit.log
		elif [ $logs = falha ]; then
			echo ""
			echo " ----- A apresentar falhas recentes ----- "
			sudo ausearch -m avc -ts recent
		else
			echo ""
			echo "Inseriste alguma coisa de errado. Tenta escrever alerta (para ver os alertas) ou falha (para ver alguma falha)."
		fi
		*)
		echo ""
		echo "Oops! Algo correu mal ! Tenta selecionar 1 ou 2."
		;;
		esac
	;;
	2)
	cat << END

Escolha, por favor, uma das seguintes opcoes:

1: Instalar o Fail2Ban
2: Ativar a proteção 

END

	while true; do
		read -p ": " l
		case $l in
		1)
		echo "---- 	A instalar o Fail2Ban ----"
		sudo dnf install epel-release -y
		sudo dnf install fail2ban -y
		;;
		2)
		echo "----- A configurar o Fail2ban -----"
		if [ -f /etc/fail2ban/jail.local ]; then
			echo "Aviso: O ficheiro /etc/fail2ban/jail.local já existe!"
			echo "Configuração ignorada para evitar perder dados existentes. A fechar programa..."
			sleep 2
		else
			echo "A criar ficheiro de configuração..."
			sudo tee /etc/fail2ban/jail.local << END
		[DEFAULT]
		bantime = 1h
		findtime = 10m
		maxretry = 3

		[sshd]
		enabled = true

		[apache-auth]
		enabled = true
		port = http,https
		logpath = /var/log/httpd/error_log
		END
			echo "Configuração injetada com sucesso!"
		fi

END
		sudo systemctl enable --now fail2ban
		echo ""
		echo "---- IPs Bloqueados ----"
		sudo fail2ban-client status sshd
		;;
		*)
		echo "Uups! Opção inválida, seleciona 1 ou 2."
		;;
		esac
	;;
	3)
	echo "A sair do programa..."
	sleep 2
	exit 0
	;;
	*)
	echo "Opção inválida! Selecione 1, 2 ou 3"
	esac
	