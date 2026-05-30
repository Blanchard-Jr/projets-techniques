# 🔥 Lab FortiGate — SD-WAN Multi-WAN sous EVE-NG

> **Contexte** : Lab réalisé post-CCNA 200-301 dans le cadre de la préparation à la certification **Fortinet NSE4**.  
> **Plateforme** : EVE-NG  
> **Niveau** : Intermédiaire — Réseaux & Sécurité

---

## 🎯 Objectifs

- Mettre en place un accès Internet **multi-WAN** avec FortiGate
- Configurer la **répartition de charge (load balancing)** entre deux liens WAN
- Superviser les liens via **SLA ICMP**
- Analyser et troubleshooter les flux réseau

---

## 🏗️ Architecture

```
                    ┌─────────────────────────────────┐
                    │         INTERNET (simulé)        │
                    │       Routeur Cisco ISR           │
                    └────────┬──────────────┬──────────┘
                             │              │
                    WAN1     │              │     WAN2
               10.0.0.0/30  │              │  20.0.0.0/30
                             │              │
                    ┌────────┴──────────────┴──────────┐
                    │         FortiGate (FW / SD-WAN)   │
                    │         Zone SD-WAN configurée    │
                    └──────────────────┬────────────────┘
                                       │
                              LAN 172.16.20.0/24
                                       │
                              ┌────────┴────────┐
                              │     Switch L2    │
                              └────────┬────────┘
                                       │
                              Clients internes (PC)
```

| Composant        | Rôle                              | Réseau          |
|------------------|-----------------------------------|-----------------|
| Routeur Cisco    | Simulation accès WAN / Internet   | —               |
| FortiGate        | Firewall + SD-WAN + NAT           | —               |
| WAN1             | Lien WAN principal                | 10.0.0.0/30     |
| WAN2             | Lien WAN secondaire               | 20.0.0.0/30     |
| LAN              | Réseau clients internes           | 172.16.20.0/24  |

---

## ⚙️ Mise en œuvre

### 1. Configuration des interfaces WAN / LAN

- Assignation des adresses IP sur WAN1, WAN2 et l'interface LAN
- Vérification de la connectivité inter-interfaces

### 2. NAT multi-WAN

- Règle NAT source sur WAN1 et WAN2
- Vérification que chaque lien effectue bien la translation

### 3. Policy Firewall LAN → Internet

- Création d'une politique autorisant le trafic LAN vers la zone SD-WAN
- Application du NAT sur la politique

### 4. Création de la zone SD-WAN

- Ajout de WAN1 et WAN2 dans la zone SD-WAN
- Activation de la zone dans les politiques firewall

### 5. Load Balancing

- Stratégie : **Volume-based** (répartition par volume de trafic)
- Les deux liens WAN utilisés simultanément

### 6. SLA ICMP

- Sonde SLA vers `8.8.8.8` sur chaque lien WAN
- Seuils configurés : latence, jitter, perte de paquets
- Basculement automatique si un lien est dégradé

---

## ⚠️ Problématiques rencontrées

| Problème | Cause identifiée | Solution appliquée |
|----------|------------------|--------------------|
| Pas d'accès Internet sur WAN2 | NAT absent sur ce lien | Ajout d'une règle NAT sur WAN2 |
| Trafic routé via interface MGMT | Route par défaut incorrecte | Correction de la table de routage |
| SD-WAN inefficace | Mauvaise stratégie sélectionnée | Reconfiguration en volume-based |
| Pas de résolution DNS côté client | DNS non poussé aux clients | Ajout du serveur DNS dans le DHCP LAN |

---

## ✅ Résultats

- ✔️ Répartition dynamique du trafic entre WAN1 et WAN2
- ✔️ Basculement automatique en cas de dégradation d'un lien (SLA)
- ✔️ Supervision en temps réel via le dashboard FortiGate
- ✔️ Validation par logs et tableaux de bord FortiGate

---

## 🧠 Compétences travaillées

`Routing` `SD-WAN` `NAT` `Firewalling` `Troubleshooting réseau` `FortiGate` `EVE-NG` `Cisco IOS`

---

## 📁 Structure du dossier

```
lab-fortigate-sdwan-multiwан/
├── README.md                  ← Ce fichier
├── captures/                  ← Screenshots EVE-NG, dashboard FortiGate
│   ├── topologie-eve-ng.png
│   ├── sdwan-dashboard.png
│   └── sla-monitoring.png
├── configs/                   ← Exports de configuration
│   ├── fortigate-config.txt   ← Config FortiGate (anonymisée)
│   └── cisco-router.txt       ← Config routeur Cisco
└── doc/
    └── lab-notes.md           ← Notes de troubleshooting détaillées
```

---

## 🔗 Liens utiles

- [Documentation FortiGate SD-WAN — Fortinet Docs](https://docs.fortinet.com/product/fortigate)
- [EVE-NG Community](https://www.eve-ng.net/)
- [Certification NSE4 — Fortinet](https://training.fortinet.com/local/staticpage/view.php?page=nse4)

---

## 👤 Auteur

**Blanchard Koubemba** — Ingénieur Réseaux & Sécurité  
🏅 CCNA 200-301 | En cours : Fortinet NSE4  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Blanchard_Koubemba-blue?logo=linkedin)](https://www.linkedin.com/in/blanchard-koubemba-a9524ab5/)
