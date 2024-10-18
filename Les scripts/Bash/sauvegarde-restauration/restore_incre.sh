#!/bin/bash

# Auteur : Blanchard KOUBEMBA
# Date : 10/09/2024
# Version : 1.0
# Objectif : Restaurer un fichier de sauvegarde spécifique pour GLPI

# Définir les variables
BACKUP_SERVER="admin-stockage@srv-stockage"
BACKUP_BASE_DIR="/home/admin-stockage/sauvegarde/TICKETS"
DESTINATION_DIR="/var/www/html/glpi"

# Demander la date du backup
echo "Entrez la date du backup (par exemple, backup_20240910) :"
read BACKUP_DATE

# Définir le chemin du fichier de sauvegarde
BACKUP_FILE="$BACKUP_BASE_DIR/$BACKUP_DATE/glpi/index.php"

# Vérifier si le fichier de sauvegarde existe
ssh $BACKUP_SERVER "test -e $BACKUP_FILE"
if [ $? -ne 0 ]; then
    echo "Le fichier de sauvegarde '$BACKUP_FILE' n'existe pas sur le serveur de sauvegarde."
    exit 1
fi

# Définir le fichier de log
LOG_FILE="/var/log/restore/restore_incre_srv-glpi_$(date +%Y%m%d).log"

# Exécuter la commande rsync
rsync -avz --no-group $BACKUP_SERVER:$BACKUP_FILE $DESTINATION_DIR &>> $LOG_FILE

# Vérifier si la commande rsync a réussi
if [ $? -eq 0 ]; then
    echo "Le fichier a été restauré avec succès." | tee -a $LOG_FILE
else
    echo "Une erreur est survenue lors de la restauration du fichier." | tee -a $LOG_FILE
    exit 1
fi

