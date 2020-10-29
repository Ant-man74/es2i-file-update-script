# es2i-file-update-script

## Command Line Option

- -env: option requise, valeur possible: DEV, PROD, REC. Indique l'environnement à copier
- -folderBackup: 1 ou 0, 1 par défaut, indique si les dossiers doivent être backup lors de l'exécution
- -fileBackup: 1 ou 0, 1 par défaut, indique si les fichiers doivent être backup lors de l'exécution

## Resource nécessaire

- Le dossier Roboto des font
- L'instalateur msi du connecteur mySql
- Le dossier contenant les différents environnement
- Une instalation eSirius

## A Modifier

- Pour que le script fonctionne, changer les constantes (ligne 50) à votre convenance du script es2i-file-update-script.ps1

- Le script FontInstallation.ps1 doit être exécuté à chaque démarrage de la machine, il est conseillé de le mettre en script de démarage
