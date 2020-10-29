# Retrieve parameters
Param (
  [Parameter(Mandatory=$true)]
  [ValidateSet("DEV", "PROD", "REC")]
  [string]$env,
  [ValidateSet(0, 1)]
  [int] $fileBackup = 1,
  [ValidateSet(0, 1)]
  [int] $folderBackup = 1
)

# Backup a file if it exist
Function Backup-File {
  param (
      $pathToFileFolder,
      $filename
  )
  $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
  if (Test-Path "$pathToFileFolder\$filename" -PathType leaf)
  {
    Rename-Item "$pathToFileFolder\$filename" "$filename-$timestamp"
  }
}

# Backup a folder if it exist
Function Backup-Folder {
  param (
      $pathToFolder
  )
  $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
  if ((Test-Path "$pathToFolder") -And $folderBackup)
  {
    Rename-Item "$pathToFolder" "$pathToFolder-$timestamp"
  }
}

# Backup a file, create the directory if it doesnt exist and copy the file to the destination
# use -backup = 0 if you want no backup
Function BackupCopy-File {
  param (
    $sourceFolderPath,
    $targetFolderPath,
    $filename,
    $backup = 1
  )
  if ($backup -And $fileBackup)
  {
    Backup-File -pathToFileFolder "$targetFolderPath" -filename $filename
  }
  $null = New-Item -ItemType File -Path "$targetFolderPath\$filename" -Force
  Copy-Item -Path "$sourceFolderPath\$filename" -Destination "$targetFolderPath\$filename" -Force
}

# ----------- Constant -----------

# The folder containing the unzipped files
$sourceFolder = "D:\_sources\10581\esirius"
# Where do the file need to be copied
$targetFolder = "D:\programs\eSirius-14"
# The folder containing the font definition
$fontSourceFolder = "D:\_sources\10581\Font_Roboto"
# The mySql connector .msi file
$mysqlConnectorMsi = "D:\_sources\10581\mysql-connector-net-8.0.16.msi"

# ---------- ---------- ----------

Stop-Service -Name "Apache Tomcat 9.0.31"

# eSecurity files (esecurity-commons.properties, esecurity-commons-users.properties)
$currentFolder = "conf\esecurity\config"
BackupCopy-File -sourceFolderPath "$sourceFolder\$env\$currentFolder" -targetFolderPath "$targetFolder\$currentFolder\" -filename "esecurity-commons.properties"
BackupCopy-File -sourceFolderPath "$sourceFolder\$env\$currentFolder" -targetFolderPath "$targetFolder\$currentFolder\" -filename "esecurity-commons-users.properties"

# JDK Files (Gina.jks + Cacerts)
$currentFolder = "esirius-tools\jdk-11.0.5"
BackupCopy-File -sourceFolderPath "$sourceFolder\$env\$currentFolder" -targetFolderPath "$targetFolder\$currentFolder\" -filename "Gina.jks"
$currentFolder = "esirius-tools\jdk-11.0.5\lib\security"
BackupCopy-File -sourceFolderPath "$sourceFolder\$env\$currentFolder" -targetFolderPath "$targetFolder\$currentFolder\" -filename "Cacerts"

# Tomcat bin File (Service.bat)
$currentFolder = "esirius-tools\apache-tomcat-9.0.31\bin"
BackupCopy-File -sourceFolderPath "$sourceFolder\$env\$currentFolder" -targetFolderPath "$targetFolder\$currentFolder\" -filename "Service.bat"

# eSirius Licence (esirius.license.dev(03_04) renamed to esirius.license in target, old esirius.license is backed up)
$currentFolder = "conf\eSirius"
BackupCopy-File -sourceFolderPath "$sourceFolder\$env\$currentFolder" -targetFolderPath "$targetFolder\$currentFolder\" -filename "esirius.license.dev(03_04)"
Backup-File -pathToFileFolder "$targetFolder\$currentFolder\" -filename "esirius.license"
Rename-Item "$targetFolder\$currentFolder\esirius.license.dev(03_04)" "esirius.license"

# Tomcat conf file (Server.xml)
$currentFolder = "esirius-tools\apache-tomcat-9.0.31\conf"
BackupCopy-File -sourceFolderPath "$sourceFolder\$env\$currentFolder" -targetFolderPath "$targetFolder\$currentFolder\" -filename "Server.xml"

# Tomcat certificate Files
$currentFolder = "esirius-tools\apache-tomcat-9.0.31\conf\certificate"
# Server 03
BackupCopy-File -sourceFolderPath "$sourceFolder\$env\$currentFolder" -targetFolderPath "$targetFolder\$currentFolder\" -filename "w10581apdev03.ge-admin.ad.etat-ge.ch.b64"
BackupCopy-File -sourceFolderPath "$sourceFolder\$env\$currentFolder" -targetFolderPath "$targetFolder\$currentFolder\" -filename "w10581apdev03.ge-admin.ad.etat-ge.ch.key"
# Server 04
# BackupCopy-File -sourceFolderPath "$sourceFolder\$env\$currentFolder" -targetFolderPath "$targetFolder\$currentFolder\" -filename "w10581apdev04.ge-admin.ad.etat-ge.ch.b64"
# BackupCopy-File -sourceFolderPath "$sourceFolder\$env\$currentFolder" -targetFolderPath "$targetFolder\$currentFolder\" -filename "W10581apdev04.ge-admin.ad.etat-ge.ch.key"

# eSirius Portal.jsp (portal.jsp)
$currentFolder = "app\eSirius\JSP\OC\HTML"
BackupCopy-File -sourceFolderPath "$sourceFolder\$env\$currentFolder" -targetFolderPath "$targetFolder\$currentFolder\" -filename "portal.jsp"

# eStat jobs parameters (estat-jobs-parameters.properties)
$currentFolder = "conf\estat\config\user"
BackupCopy-File -sourceFolderPath "$sourceFolder\$env\$currentFolder" -targetFolderPath "$targetFolder\$currentFolder\" -filename "estat-jobs-parameters.properties"

# eSirius alerts (estat-jobs-parameters.properties)
$currentFolder = "conf\eSirius\config\user"
BackupCopy-File -sourceFolderPath "$sourceFolder\$env\$currentFolder" -targetFolderPath "$targetFolder\$currentFolder\" -filename "alert-descriptor.alt.xml"

# eStat \document (all files in documents)
$currentFolder = "conf\estat\config\user\documents"
Backup-Folder "$targetFolder\$currentFolder"
# Copy-Item -Path "$sourceFolder\$env\$currentFolder" -Destination "$targetFolder\$currentFolder" -Recurse

# eKiosk park.xml, \i18n, \Element
$currentFolder = "conf\eKiosk"
BackupCopy-File -sourceFolderPath "$sourceFolder\$env\$currentFolder" -targetFolderPath "$targetFolder\$currentFolder\" -filename "park.xml"
Backup-Folder "$targetFolder\$currentFolder\i18n"
Copy-Item -Path "$sourceFolder\$env\$currentFolder\i18n" -Destination "$targetFolder\$currentFolder\" -Recurse -force
Backup-Folder "$targetFolder\$currentFolder\Element"
Copy-Item -Path "$sourceFolder\$env\$currentFolder\Element" -Destination "$targetFolder\$currentFolder\" -Recurse -force

# eAppointement-afc, eAppointement-oce
.\es2i-eappointement-site-creation $targetFolder "afc" "ScenarioStepThreeD"
.\es2i-eappointement-site-creation $targetFolder "oce" "ScenarioStepThreeC"

# changer config eRdv
# Todo

# es2i-password-manager
.\es2i-password-manager $targetFolder "1" "1"

# Install and uninstall tomcat service
$currentFolder = "esirius-tools\apache-tomcat-9.0.31\bin"
Start-Process $targetFolder\$currentFolder\remove-tomcat-service.bat -Wait
Start-Process $targetFolder\$currentFolder\install-tomcat-service.bat -Wait

# font installation
.\FontInstallation.ps1 -sourceFolder $fontSourceFolder

# connecteur mySql
$arguments = "/i `"$mysqlConnectorMsi`" /passive"
Start-Process msiexec.exe -ArgumentList $arguments -Wait

Start-Service -Name "Apache Tomcat 9.0.31"
