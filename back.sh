#!/bin/bash
 
while true; do
    clear
    echo -e "\033[1;31m"
    echo "  ██████╗  █████╗  ██████╗██╗  ██╗██╗   ██╗██████╗ ███████╗"
    echo "  ██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██║   ██║██╔══██╗██╔════╝"
    echo "  ██████╔╝███████║██║     █████╔╝ ██║   ██║██████╔╝███████╗"
    echo "  ██╔══██╗██╔══██║██║     ██╔═██╗ ██║   ██║██╔═══╝ ╚════██║"
    echo "  ██████╔╝██║  ██║╚██████╗██║  ██╗╚██████╔╝██║     ███████║"
    echo "  ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚══════╝"
    echo -e "\033[0m"
    echo " [1] Backup MariaDB (Base de Dados)"
    echo " [2] Backup WordPress (Ficheiros do Site)"
    echo " [V] Voltar ao Menu Principal"
    echo " ----------------------------------------------------"
    read -p "[Admin]: " b_opt
 
    # Garante que as pastas existem sem duplicar
    sudo mkdir -p /backups/mariadb /backups/wordpress
 
    case ${b_opt,,} in
        1)
            echo "A iniciar backup da MariaDB..."
            sudo sh -c "mysqldump -u root -p --all-databases | gzip > /backups/mariadb/db_backup.sql.gz"
            echo -e "\n\033[1;32mSITUAÇÃO DO BACKUP MARIADB (DENTRO DA PASTA MARIADB):\033[0m"
            ls /backups/mariadb/ ;; # Mostra apenas o ficheiro .gz e o tamanhoQ
        2)
            echo "A iniciar backup do WordPress..."
            # O rsync -a sincroniza tudo direitinho
            sudo rsync -av --delete /var/www/html/ /backups/wordpress/ > /dev/null
            echo -e "\n\033[1;32mSITUAÇÃO DO BACKUP WORDPRESS (DENTRO DA PASTA WORDPRESS):\033[0m"
            ls /backups/wordpress/ # Mostra apenas a pasta, sem cuspir os ficheiros todos
            echo "Ficheiros sincronizados com sucesso!" ;;
        v) break ;;
        *) echo "Opção inválida!" ; sleep 1 ;;
    esac
	
	echo -e "\n----------------------------------------------------"
    read -p "! ENTER para continuar..."
done
