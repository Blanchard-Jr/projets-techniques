# Auteur : Blanchard Koubemba
# Date : 29 octobre 2024
# Version : 1.0
# Description : Ce script récupère les adresses e-mail des membres du groupe de sécurité universelle "Letsignit" 
#               dans Active Directory et les exporte dans un fichier texte.

# Importer le module Active Directory
Import-Module ActiveDirectory

# Définir le nom du groupe de sécurité
$groupName = "Letsignit"

# Rechercher le groupe de sécurité et obtenir son emplacement
$group = Get-ADGroup -Filter { Name -eq $groupName }

if ($group) {
    Write-Output "Groupe trouvé : $($group.Name)"
    Write-Output "Emplacement du groupe : $($group.DistinguishedName)"
    
    # Récupérer les membres du groupe
    $members = Get-ADGroupMember -Identity $group | Where-Object { $_.objectClass -eq 'user' }
    
    if ($members.Count -gt 0) {
        Write-Output "Membres trouvés : $($members.Count)"
        
        # Récupérer les adresses e-mail des membres
        $emails = $members | ForEach-Object {
            Get-ADUser -Identity $_.DistinguishedName -Property EmailAddress | Select-Object -ExpandProperty EmailAddress
        } | Where-Object { $_ -ne $null }
        
        # Exporter les adresses e-mail dans un fichier texte
        $emails | Out-File -FilePath "C:\Users\admbka\Downloads\AutoriserCalendrierOutlook\accounts.txt"
        
        Write-Output "Exportation des adresses e-mail terminée."
    } else {
        Write-Output "Aucun membre utilisateur trouvé dans le groupe $groupName."
    }
} else {
    Write-Output "Groupe $groupName non trouvé."
}
