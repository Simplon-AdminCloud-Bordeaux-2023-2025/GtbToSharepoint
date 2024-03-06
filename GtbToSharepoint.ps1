# =======================================================
# NOM: GtbToSharepoint.ps1
# AUTEUR: Grégory El-Bajoury
# CREATION: 02/02/2024
#
# VERSION ACTUELLE : 1.2
#
# MODIFICATIONS :
# 02/02/2024 - Grégory El-Bajoury -> v1.0
# - Création du script
#
# 05/02/2024 - Justine Schmidt -> v1.1
# - Connexion au Sharepoint via credentials Gestionnaire d'identification Windows
# - Fichier .csv copié uniquement si créé le jour même
#
# 15/02/2024 - Grégory El-Bajoury -> v1.2
# - Implémentation des credentials gtb_cs en clair (non fonctionnel avec Gestionnaire d'identification Windows)
# - Correction des dossiers de destination
# - Ciblage des fichiers .csv désirés
#
# Remarque :
# - Nécessite Powershell version 7.2.0 minimum
# - Nécessite l'installation du module PnP : Install-Module PnP.Powershell -Scope CurrentUser
#
#Requires -Version 2.0
# =======================================================
# Ce script vise à envoyer des fichiers spécifiques de la GTB vers le sharepoint d'un collaborateur
# WARNING : Bien vérifier les chemins de départ et d'arrivée

# Import du module PnP
# Import-Module PnP.PowerShell

# Récupération des variables d'environnement
$SiteURL = "https://machinfr.sharepoint.com/sites/machin/"
$Username = "lUtilisateur" # Remplacer par le nom de votre utilisateur
$Password = "leMotDePasse" # Remplacer par le mot de passe de votre utilisateur

# Création de l'objet PSCredential
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)

# Connexion à SharePoint
Connect-PnPOnline -Url $SiteURL -Credentials $Credential

# Chemins de destination dans SharePoint ajustés
$FolderURLDat = "Documents partages/General/01 - Sources/01 - Fiche cle"
$FolderURLCsv = "Documents partages/General/01 - Sources/02 - Barriere"

# Copie des fichiers .dat et .csv spécifiés

# Récupérer la date actuelle
$CurrentDate = Get-Date

# Chemin du fichier local .dat
$FilePathDat = "C:\chemin\vers\fichier\dat"
# Chemin du répertoire contenant les fichiers .csv
$FolderPathCsv = "C:\chemin\vers\fichiers\csv"

# Transfert du fichier .dat
if (Test-Path $FilePathDat) {
    Add-PnPFile -Path $FilePathDat -Folder $FolderURLDat
    Write-Host "Fichier .dat transféré avec succès : $FilePathDat" -ForegroundColor Green
} else {
    Write-Host "Fichier .dat non trouvé: $FilePathDat" -ForegroundColor Red
}

# Préparation des motifs de recherche pour les fichiers .csv
$patterns = @("*BA01*.csv", "*BA02*.csv", "*P004*.csv", "*P006*.csv", "*S102*.csv")

# Recherche et transfert des fichiers .csv correspondant aux motifs et modifiés le jour même
foreach ($pattern in $patterns) {
    $CsvFiles = Get-ChildItem -Path $FolderPathCsv -Filter $pattern |
                Where-Object { $_.LastWriteTime.Date -eq $CurrentDate.Date }
    foreach ($File in $CsvFiles) {
        $result = Add-PnPFile -Path $File.FullName -Folder $FolderURLCsv
        if ($result) {
            Write-Host "Fichier .csv transféré avec succès : $($File.FullName)" -ForegroundColor Green
        } else {
            Write-Host "Erreur lors du transfert du fichier .csv : $($File.FullName)" -ForegroundColor Red
        }
    }
}

# Déconnexion
Disconnect-PnPOnline

#  ________  ________  _______   ________          ________                ___  ___  ___  ________  _________  ___  ________   _______      
# |\   ____\|\   __  \|\  ___ \ |\   ____\        |\   __  \              |\  \|\  \|\  \|\   ____\|\___   ___\\  \|\   ___  \|\  ___ \     
# \ \  \___|\ \  \|\  \ \   __/|\ \  \___|        \ \  \|\  \  /\         \ \  \ \  \\\  \ \  \___|\|___ \  \_\ \  \ \  \\ \  \ \   __/|    
#  \ \  \  __\ \   _  _\ \  \_|/_\ \  \  ___       \ \__     \/  \      __ \ \  \ \  \\\  \ \_____  \   \ \  \ \ \  \ \  \\ \  \ \  \_|/__  
#   \ \  \|\  \ \  \\  \\ \  \_|\ \ \  \|\  \       \|_/  __     /|    |\  \\_\  \ \  \\\  \|____|\  \   \ \  \ \ \  \ \  \\ \  \ \  \_|\ \ 
#    \ \_______\ \__\\ _\\ \_______\ \_______\        /  /_|\   / /    \ \________\ \_______\____\_\  \   \ \__\ \ \__\ \__\\ \__\ \_______\
#     \|_______|\|__|\|__|\|_______|\|_______|       /_______   \/      \|________|\|_______|\_________\   \|__|  \|__|\|__| \|__|\|_______|
#                                                    |_______|\__\                          \|_________|                                    
#               
