#!/bin/bash

# ---------------------------------------------------------
# Auteur : Blanchard KOUBEMBA
# Date : 10/09/2024
# Version : 1.0
# Objectif : Script de sauvegarde incrémentale du répertoire /var/www/html/ vers un serveur de stockage distant.
# ---------------------------------------------------------

# Définir les variables
SOURCE_DIR="/var/www/html/"  # Répertoire source à sauvegarder
DEST_BASE="/home/admin-stockage/sauvegarde/TICKETS"  # Répertoire de destination sur srv-stockage
TODAY=$(date +%Y%m%d)  # Format de la date en YYYYMMDD
LAST_BACKUP=$(ssh admin-stockage@srv-stockage "ls -td $DEST_BASE/backup_* | head -1")  # Dernière sauvegarde
DEST_DIR="$DEST_BASE/backup_$TODAY"  # Répertoire de la nouvelle sauvegarde
LOG_DIR="/var/log/backup"  # Répertoire de log
LOG_FILE="$LOG_DIR/backup_incre_srv-glpi_$TODAY.log"  # Fichier de log

# Créer le répertoire de sauvegarde sur srv-stockage
ssh admin-stockage@srv-stockage "mkdir -p $DEST_DIR"

# Créer le répertoire de log localement
mkdir -p "$LOG_DIR"

# Effectuer la sauvegarde incrémentale via rsync, en excluant les dossiers spécifiques et en ignorant les fichiers manquants
rsync -avz --ignore-missing-args --exclude 'scripts' --exclude '_sessions' --exclude 'ajax' --exclude 'templates' --exclude 'cache' "$SOURCE_DIR" "admin-stockage@srv-stockage:$DEST_DIR" >> "$LOG_FILE" 2>&1

# Vérifier le succès de la sauvegarde
if [ $? -eq 0 ]; then
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Sauvegarde incrémentale réussie vers $DEST_DIR sur $DEST_SERVER." | tee -a "$LOG_FILE"
else
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Erreur : échec de la sauvegarde incrémentale." | tee -a "$LOG_FILE"
    exit 1
fi

# Supprimer les sauvegardes plus anciennes que 30 jours sur srv-stockage
ssh admin-stockage@srv-stockage "find $DEST_BASE -type d -mtime +30 -exec rm -rf {} \;" 2>/dev/null

echo "[$(date +'%Y-%m-%d %H:%M:%S')] Sauvegarde incrémentale effectuée et suppression des sauvegardes plus anciennes que 30 jours." | tee -a "$LOG_FILE"
