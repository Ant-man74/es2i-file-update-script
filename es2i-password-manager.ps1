
Param (
  [Parameter(Mandatory=$true)]
  [string] $adminPassword,
  [Parameter(Mandatory=$true)]
  [string] $esiiPassword
)

# Il me manque le patch clear .bat

start-process "cmd.exe" -Wait "/c .\Command_Es2iPasswordManagerCustom.bat 2 1 admin $adminPassword"
start-process "cmd.exe" -Wait "/c .\Command_Es2iPasswordManagerCustom.bat 2 1 esii $esiiPassword"
