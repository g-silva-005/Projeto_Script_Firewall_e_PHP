while true; do
    clear
    echo -e "\033[1;35m" # Roxo para destacar que é o Segurança
    echo "  ██████╗███████╗███╗   ██╗████████╗ ██████╗ ███████╗"
    echo " ██╔════╝██╔════╝████╗  ██║╚══██╔══╝██╔═══██╗██╔════╝"
    echo " ██║     █████╗  ██╔██╗ ██║   ██║   ██║   ██║███████╗"
    echo " ██║     ██╔══╝  ██║╚██╗██║   ██║   ██║   ██║╚════██║"
    echo " ╚██████╗███████╗██║ ╚████║   ██║   ╚██████╔╝███████║"
    echo "  ╚═════╝╚══════╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝ ╚══════╝"
    echo -e "\033[0m"
    echo " [1] Atualizar o sistema   [3] Sincronizar hora"
    echo " [2] Verificar Logs        [4] Configurar Backup Semanal"
    echo " [Q] Terminar"
    echo " ----------------------------------------------------"
    read -p "[Admin]: " opt
    case ${opt,,} in
		1)
			echo "---- A iniciar as Atualizações ----"
			sleep 1
			sudo dnf update -y
			read -p "! Pressione ENTER para voltar ao menu !"
			;;
		2)
			echo "---- Logs de acesso APACHE (a mostrar as ultimas 10 linhas) ----"
			sudo tail -n 10 /var/log/httpd/access_log
			echo ""
			echo "---- Tentativas de login ----"
			sudo tail -n 10 /var/log/secure
			echo ""
			read -p "! Pressione ENTER para voltar ao menu !"
			;;
		3)
			echo "---- A sincronizar hora ----"
			sudo systemctl restart chronyd
			sudo chronyd tracking
			sleep 1
			read -p "! Pressione ENTER para voltar ao menu !"
			;;
		4)
			echo "---- A configurar Backup semanal (Domingo 00:00) ----"
			(crontab -l 2>/dev/null; echo "0 0 * * 0 tar -czf /backup/www_$(date +\%F).tar.gz /var/www/html") | crontab -
			echo ""
			echo "---- Agendamento concluído usando Crontab ----"
			read -p "! Pressione ENTER para voltar ao menu !"
			;;
		q|Q)
			exit
			;;
		*)
			;;
	esac
done 
	