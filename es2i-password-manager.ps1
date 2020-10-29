
Param (
  [Parameter(Mandatory=$true)]
  [string] $targetFolder,
  [Parameter(Mandatory=$true)]
  [string] $adminPassword,
  [Parameter(Mandatory=$true)]
  [string] $esiiPassword
)

$currentFolder = "tools\es2i-password-manager\script"

# Il me manque le patch clear .bat

start-process "cmd.exe" -Wait "/c $targetFolder\$currentFolder\Command_Es2iPasswordManagerCustom.bat 2 1 admin $adminPassword"
start-process "cmd.exe" -Wait "/c $targetFolder\$currentFolder\Command_Es2iPasswordManagerCustom.bat 2 1 esii $esiiPassword"
