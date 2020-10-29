Param (
  [Parameter(Mandatory=$true)]
  [string] $targetFolder,
  [Parameter(Mandatory=$true)]
  [string] $siteName,
  [Parameter(Mandatory=$true)]
  [ValidateSet("ScenarioStepOne", "ScenarioStepTwo", "ScenarioStepThree", "ScenarioStepThreeB", "ScenarioStepThreeC", "ScenarioStepThreeD", "ScenarioStepFour", "ScenarioStepFive", "ScenarioStepSix")]
  [string] $scenarioName
)

Function SelectScenario-xmlfile {
  param (
      $duplicateAppointement,
      [ValidateSet("ScenarioStepOne", "ScenarioStepTwo", "ScenarioStepThree", "ScenarioStepThreeB", "ScenarioStepThreeC", "ScenarioStepThreeD", "ScenarioStepFour", "ScenarioStepFive", "ScenarioStepSix")]
      $scenarioName
  )

  $xmlConfigFile = Get-Content "$duplicateAppointement\config\appointment-config.xml"

  # Comment the current scenario
  $activeScenarioLine = $xmlConfigFile | select-string -Pattern '^  <bean id="stepId"'
  $xmlConfigFile[$activeScenarioLine.LineNumber-1] = "  <!--$($xmlConfigFile[$activeScenarioLine.LineNumber-1]) -->"

  # Uncomment the wanted scenario
  $activeScenarioLine2 = $xmlConfigFile | select-string -Pattern "$scenarioName"
  $xmlConfigFile[$activeScenarioLine2.LineNumber-1] = $xmlConfigFile[$activeScenarioLine2.LineNumber-1] -replace "<!--", ""
  $xmlConfigFile[$activeScenarioLine2.LineNumber-1] = $xmlConfigFile[$activeScenarioLine2.LineNumber-1] -replace "-->", ""

  $xmlConfigFile | Set-Content -Path "$duplicateAppointement\config\appointment-config.xml"
}

Function Duplicate-eappointement {
  param (
      $siteName,
      $targetFolder,
      $scenarioName
  )

  $catalinaContext = "esirius-tools\apache-tomcat-9.0.31\conf\Catalina\localhost"

  # Duplicate appointement.xml and rename one copy to appointment-siteName
  Copy-Item "$targetFolder\$catalinaContext\eAppointment.xml" -Destination "$targetFolder\$catalinaContext\eAppointment-$siteName.xml"

  # Modify the file, replace conf/appointment/config to conf/appointment-siteName/config
  ((Get-Content -path "$targetFolder\$catalinaContext\eAppointment-$siteName.xml" -Raw) -replace 'conf/appointment/config',"conf/appointment-$siteName/config") | Set-Content -Path "$targetFolder\$catalinaContext\eAppointment-$siteName.xml"

  # Duplicate conf\appointment and rename the copy to conf\appointment-siteName
  $null = New-Item -Path "$targetFolder\conf\" -Name "appointment-$siteName" -ItemType "directory" -Force
  $duplicateAppointement = "$targetFolder\conf\appointment-$siteName"
  Copy-Item -Path "$targetFolder\conf\appointment\*" -Destination "$duplicateAppointement" -Recurse -Force

  # Copy appointement.xml to conf\appointment-afc
  Copy-Item "$targetFolder\$catalinaContext\eAppointment.xml" -Destination "$duplicateAppointement"

  # Modify the file \config\log4J2.xml and change all eappointement to eappointement-afc
  (((Get-Content -path "$duplicateAppointement\config\log4j2.xml" -Raw) -replace '/eappointment-{',"/eappointment-$siteName-{") -replace '/eappointment-system',"/eappointment-$siteName-system") | Set-Content -Path "$duplicateAppointement\config\log4j2.xml"

  # Modify the file \config\appointment-init-web-parameters.properties and change all /appointment to /appointment-afc
  ((Get-Content -path "$duplicateAppointement\config\appointment-init-web-parameters.properties" -Raw) -replace '/appointment',"/appointment-$siteName") | Set-Content -Path "$duplicateAppointement\config\appointment-init-web-parameters.properties"

  # Modify the file \config\appointment-global-parameters.properties and change all eAppointment to /eAppointment-afc
  ((Get-Content -path "$duplicateAppointement\config\appointment-global-parameters.properties" -Raw) -replace 'eAppointment',"eAppointment-$siteName") | Set-Content -Path "$duplicateAppointement\config\appointment-global-parameters.properties"

  # Select the rigth scenario
  SelectScenario-xmlfile -duplicateAppointement "$targetFolder\conf\appointment-$siteName" -scenarioName $scenarioName

  # Create Hta file
  $currentFolder = "tools\shortcuts\appointment"
  Copy-Item "$targetFolder\$currentFolder\eAppointment.hta" -Destination "$targetFolder\$currentFolder\eAppointment-$siteName.hta"
  ((Get-Content -path "$targetFolder\$currentFolder\eAppointment.hta" -Raw) -replace '/eAppointment/appointment.do',"/eAppointment-$siteName/appointment.do") | Set-Content -Path "$targetFolder\$currentFolder\eAppointment.hta"
}

Duplicate-eappointement $siteName $targetFolder $scenarioName