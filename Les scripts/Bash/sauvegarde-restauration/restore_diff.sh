#!/bin/bash

# Auteur : Blanchard KOUBEMBA
# Date : 10/09/2024
# Version : 1.0
# Objectif : Restauration complète du serveur GLPI avec rsync

# ---------------------------------------------------------
# Script de restauration complet du serveur GLPI avec rsync
# ---------------------------------------------------------

# Variables de base
SOURCE_SERVER="admin-stockage@srv-stockage"  # Serveur de sauvegarde
MACHINE_NAME="srv-glpi"  # Nom de la machine à restaurer
LOG_DIR="/var/log/restore"  # Répertoire où seront stockés les fichiers de log
LOG_FILE="$LOG_DIR/restore_diff_${MACHINE_NAME}_$(date +%Y%m%d).log"  # Nom du fichier log

# Options rsync
RSYNC_OPTIONS="-aAXv --progress"

# ---------------------------------------------------------
# Fonction pour vérifier et créer les répertoires de log
# ---------------------------------------------------------
check_and_create_dirs() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Vérification des répertoires de log..." | tee -a "$LOG_FILE"
    mkdir -p "$LOG_DIR"
    if [ $? -ne 0 ]; then
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] Erreur : impossible de créer le répertoire de log." | tee -a "$LOG_FILE"
        exit 1
    fi
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Répertoire de log créé : $LOG_DIR" | tee -a "$LOG_FILE"
}

# ---------------------------------------------------------
# Fonction de restauration via rsync
# ---------------------------------------------------------
run_restore() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Démarrage de la restauration de $SOURCE_DIR vers $DEST_DIR depuis $SOURCE_SERVER..." | tee -a "$LOG_FILE"
    sudo rsync $RSYNC_OPTIONS "$SOURCE_SERVER":"$SOURCE_DIR" "$DEST_DIR" >> "$LOG_FILE" 2>&1

    if [ $? -eq 0 ]; then
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] Restauration réussie de $SOURCE_DIR vers $DEST_DIR." | tee -a "$LOG_FILE"
    else
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] Erreur : échec de la restauration." | tee -a "$LOG_FILE"
        exit 1
    fi
}

# ---------------------------------------------------------
# Fonction principale
# ---------------------------------------------------------
main() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Début du processus de restauration pour la machine : $MACHINE_NAME" | tee -a "$LOG_FILE"

    # Demander la date de la sauvegarde à restaurer
    read -p "Entrez la date de la sauvegarde à restaurer (format YYYYMMDD) : " BACKUP_DATE

    # Définir les répertoires source et destination
    SOURCE_DIR="/home/admin-stockage/sauvegarde/MACHINE/$MACHINE_NAME/$BACKUP_DATE"
    DEST_DIR="/"

    # Vérifier et créer les répertoires nécessaires
    check_and_create_dirs

    # Lancer la restauration avec rsync
    run_restore

    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Restauration complète terminée pour $MACHINE_NAME." | tee -a "$LOG_FILE"
}

# Exécuter la fonction principale
main

