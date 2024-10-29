# Auteur : Blanchard Koubemba
# Date : 29 octobre 2024
# Version : 1.0
# Description : Ce script configure les autorisations de calendrier pour plusieurs comptes utilisateurs dans Exchange Online,
#               en traitant les comptes par lots et en enregistrant les opérations dans un fichier de log.

# Charger la liste des comptes à partir d'un fichier texte (un compte par ligne)
$accounts = Get-Content -Path "C:\Users\admbka\Downloads\AutoriserCalendrierOutlook\accounts.txt"

# Définir le chemin du fichier de log
$logFilePath = "C:\Users\admbka\Downloads\AutoriserCalendrierOutlook\log.txt"

# Fonction pour écrire dans le fichier de log
function Write-Log {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message"
    Add-Content -Path $logFilePath -Value $logMessage
}

# Se connecter à Exchange Online
Connect-ExchangeOnline -UserPrincipalName admbka@endrix.com -ShowProgress $true
Write-Log "Connexion à Exchange Online réussie."

# Définir la taille du lot
$batchSize = 100

# Boucler sur les comptes par lots
for ($i = 0; $i -lt $accounts.Count; $i += $batchSize) {
    $batch = $accounts[$i..([math]::Min($i + $batchSize - 1, $accounts.Count - 1))]
    
    foreach ($account in $batch) {
        try {
            Set-MailboxFolderPermission -Identity "${account}:\Calendrier" -User Default -AccessRights Reviewer
            Write-Log "Autorisations configurées pour $account"
        } catch {
            Write-Log "Erreur lors de la configuration des autorisations pour $account : $_"
        }
    }
    
    # Pause pour éviter de surcharger le serveur
    Start-Sleep -Seconds 10
}

# Se déconnecter d'Exchange Online
Disconnect-ExchangeOnline -Confirm:$false
Write-Log "Déconnexion d'Exchange Online réussie."
