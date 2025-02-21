# Création d'un commutateur virtuel avec Switch Embedded Teaming (SET)
New-VMSwitch -Name "vSwitch-Trunk" -NetAdapterName "Ethernet1", "Ethernet2" -EnableEmbeddedTeaming $true -AllowManagementOS $false

# Ajout d'un adaptateur réseau virtuel à la VM 'VM-TEST'
Add-VMNetworkAdapter -VMName 'VM-TEST' -SwitchName 'vSwitch-Trunk' -Name 'Network Adapter 1'

# Configuration du VLAN sur l'adaptateur réseau de la VM
Set-VMNetworkAdapterVlan -VMName 'VM-TEST' -VMNetworkAdapterName 'Network Adapter 1' -Access -VlanId 101

# Vérification de la configuration des adaptateurs réseau de la VM
Get-VMNetworkAdapter -VMName 'VM-TEST'

# Ajout d'un second adaptateur réseau à la VM
Add-VMNetworkAdapter -VMName 'VM-TEST' -SwitchName 'vSwitch' -Name 'Network Adapter 2'

# Configuration du VLAN sur le second adaptateur réseau
Set-VMNetworkAdapterVlan -VMName 'VM-TEST' -VlanId 1 -VMNetworkAdapterName 'Network Adapter 2'

# Vérification des commutateurs virtuels disponibles
Get-VMSwitch

# Vérification de la configuration VLAN des adaptateurs réseau
Get-VMNetworkAdapterVlan
