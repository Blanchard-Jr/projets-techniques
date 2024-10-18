#!/bin/bash

# Auteur : Blanchard KOUBEMBA
# Date : 10/09/2024
# Version : 1.0
# Objectif : Sauvegarde complète du serveur GLPI avec rsync

# ---------------------------------------------------------
# Script de sauvegarde complet du serveur GLPI avec rsync
# ---------------------------------------------------------

# Variables de base
SOURCE_DIR="/"  # Le répertoire racine à sauvegarder (tout le système de fichiers)
DEST_SERVER="admin-stockage@srv-stockage"  # Serveur de destination pour la sauvegarde
MACHINE_NAME="srv-glpi"  # Nom de la machine à sauvegarder (utile pour identifier chaque serveur)
DEST_BASE="/home/admin-stockage/sauvegarde/MACHINE/$MACHINE_NAME"  # Répertoire de destination spécifique à la machine

# Date du jour pour ajouter un timestamp à la sauvegarde
TODAY=$(date +%Y%m%d)
DEST_DIR="$DEST_BASE/$TODAY"  # Répertoire final de la sauvegarde
LOG_DIR="/var/log/backup"  # Répertoire où seront stockés les fichiers de log
LOG_FILE="$LOG_DIR/backup_diff_${MACHINE_NAME}_$TODAY.log"  # Nom du fichier log

# Options rsync
RSYNC_OPTIONS="-aAXv --progress --exclude={'/proc/*','/sys/*','/dev/*','/tmp/*','/run/*','/mnt/*','/media/*','/lost+found'}"

# ---------------------------------------------------------
# Fonction pour vérifier et créer les répertoires de log et de destination
# ---------------------------------------------------------
check_and_create_dirs() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Vérification des répertoires..." | tee -a "$LOG_FILE"
    ssh "$DEST_SERVER" "mkdir -p $DEST_DIR"
    mkdir -p "$LOG_DIR"
    if [ $? -ne 0 ]; then
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] Erreur : impossible de créer le répertoire de destination sur $DEST_SERVER." | tee -a "$LOG_FILE"
        exit 1
    fi
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Répertoire de destination créé : $DEST_DIR" | tee -a "$LOG_FILE"
}

# ---------------------------------------------------------
# Fonction de sauvegarde via rsync
# ---------------------------------------------------------
run_backup() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Démarrage de la sauvegarde de $SOURCE_DIR vers $DEST_DIR sur $DEST_SERVER..." | tee -a "$LOG_FILE"
    sudo rsync $RSYNC_OPTIONS "$SOURCE_DIR" "$DEST_SERVER":"$DEST_DIR" >> "$LOG_FILE" 2>&1

    if [ $? -eq 0 ]; then
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] Sauvegarde réussie vers $DEST_DIR sur $DEST_SERVER." | tee -a "$LOG_FILE"
    else
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] Erreur : échec de la sauvegarde." | tee -a "$LOG_FILE"
        exit 1
    fi
}

# ---------------------------------------------------------
# Fonction principale
# ---------------------------------------------------------
main() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Début du processus de sauvegarde pour la machine : $MACHINE_NAME" | tee -a "$LOG_FILE"

    # Vérifier et créer les répertoires nécessaires
    check_and_create_dirs

    # Lancer la sauvegarde avec rsync
    run_backup

    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Sauvegarde complète terminée pour $MACHINE_NAME." | tee -a "$LOG_FILE"
}

# Exécuter la fonction principale
main

