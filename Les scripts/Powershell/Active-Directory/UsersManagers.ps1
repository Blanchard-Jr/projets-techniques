# Auteur : Blanchard KOUBEMBA
# Date : 19/10/2024
# Version : V1
# Description : Ce script PowerShell récupère l'attribut "Gestionnaire" pour chaque compte utilisateur actif dans Active Directory et exporte les résultats dans un fichier CSV.

# Importer le module Active Directory
Import-Module ActiveDirectory

# Récupérer tous les utilisateurs actifs dans Active Directory
$users = Get-ADUser -Filter {Enabled -eq $true} -Property DisplayName, Manager

# Créer une liste pour stocker les résultats
$results = @()

# Parcourir chaque utilisateur et récupérer le nom et le gestionnaire
foreach ($user in $users) {
    if ($user.Manager) {
        $manager = Get-ADUser -Identity $user.Manager -Property DisplayName
        $results += [PSCustomObject]@{
            NomUtilisateur = $user.DisplayName
            Gestionnaire   = $manager.DisplayName
        }
    } else {
        $results += [PSCustomObject]@{
            NomUtilisateur = $user.DisplayName
            Gestionnaire   = "Aucun gestionnaire"
        }
    }
}

# Exporter les résultats dans un fichier CSV
$results | Export-Csv -Path "C:\Users\admbka\UsersManagers.csv" -NoTypeInformation -Encoding UTF8

# Message de débogage
Write-Host "Le fichier CSV a été créé avec succès dans C:\Users\admbka."
