# GtbToSharepoint.ps1

## Description
Ce script PowerShell automatise le transfert de fichiers spécifiques depuis un système local vers un site SharePoint. Il est particulièrement utile pour les tâches quotidiennes de gestion de fichiers, telles que la mise à jour de fichiers .dat et .csv dans des dossiers SharePoint spécifiques basés sur des critères de sélection prédéfinis.

## Auteurs
- **Grégory El Bajoury**
- **Justine SCHMIDT**

## Date de création
- **02/02/2024**

## Version actuelle
- **1.2 (15/02/2024)**

## Modifications
- **02/02/2024** - Grégory El-Bajoury -> v1.0 - Création du script
- **05/02/2024** - Justine Schmidt -> v1.1 - Connexion au SharePoint via credentials du Gestionnaire d'identification Windows et modification pour copier les fichiers `.csv` uniquement s'ils ont été créés le jour même.
- **15/02/2024** - Grégory El-Bajoury -> v1.2 -Implémentation des credentials gtb_cs en clair (non fonctionnel avec Gestionnaire d'identification Windows), correction des dossiers de destination, ciblage des fichiers .csv désirés

## Prérequis
- Nécessite Powershell version 7.2.0 minimum
- Accès à un site SharePoint
- Les fichiers à transférer doivent être accessibles sur le système local
- Nécessite l'installation du module PnP : Install-Module PnP.Powershell -Scope CurrentUser

## Fonctionnalités
- Connexion sécurisée à SharePoint en utilisant les informations d'identification stockées localement.
- Transfert d'un fichier `.dat` spécifique vers un dossier SharePoint.
- Transfert des fichiers `.csv` qui ont été générés le jour même vers un autre dossier SharePoint.
- Utilisation de chemins de fichiers et d'URLs paramétrables pour une flexibilité accrue.

## Installation

### Module PnP PowerShell
Si le module PnP PowerShell n'est pas déjà installé, exécutez la commande suivante dans PowerShell pour l'installer :
```
Install-Module PnP.PowerShell -Scope CurrentUser
```
### Import du Module
Assurez-vous d'importer le module PnP PowerShell au début du script en décommentant la ligne :
```
# Import-Module PnP.PowerShell

```

## Configuration

### Variables d'Environnement
Il est recommandé de configurer les variables d'environnement suivantes sur votre machine pour améliorer la sécurité et la portabilité du script

`SP_USERNAME` : Le nom d'utilisateur SharePoint.
`SP_PASSWORD` : Le mot de passe de l'utilisateur.
`SP_SITE_URL` : L'URL du site SharePoint cible.

### Variables du Script à Éditer
Avant d'exécuter le script, assurez-vous de personnaliser les variables suivantes selon vos besoins :

`$Username` et `$Password` : Identifiants SharePoint si les variables d'environnement ne sont pas utilisées.

`$SiteURL`                 : URL du site SharePoint où les fichiers seront téléchargés.

`$FolderURLDat` et `$FolderURLCsv` : Chemins des dossiers de destination dans SharePoint.

`$FilePathDat` : Chemin local du fichier .dat à transférer.

`$FolderPathCsv` : Chemin local du dossier contenant les fichiers .csv à transférer.

### Utilisation
Pour exécuter le script :

1.Ouvrez une fenêtre PowerShell.

2.Naviguez jusqu'au dossier contenant le script.

3.Exécutez le script avec la commande :
```
.\GtbToSharepoint.ps1

```
### Fonctionnement
Le script effectue les opérations suivantes :

1. Se connecte à SharePoint en utilisant les credentials fournis.
2. Transfère un fichier `.dat` spécifié vers le dossier SharePoint ciblé.
3. Recherche des fichiers `.csv` correspondant à des motifs prédéfinis, modifiés le jour même, et les transfère vers le dossier SharePoint spécifié.
4. Affiche des messages de statut pour chaque opération effectuée.

### Remarques 
Vérifiez et modifiez les chemins de fichier et les motifs de recherche selon les besoins de votre projet.

Assurez-vous que l'utilisateur a les permissions nécessaires pour effectuer des opérations dans les dossiers SharePoint ciblés.
