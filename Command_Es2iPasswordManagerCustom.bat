@echo off
cd "%~dp0"

chcp 28591 > nul

set action = %1
set modifType = %2
set username = %3
set password = %4

SET JAVA_JDK=C:/programs/eSirius-14/esirius-tools/jdk-11.0.5
SET JAVA_CLASSPATH=C:/programs/eSirius-14/tools/es2i-password-manager/lib/es2i-password-manager-14.0.0.0.jar com.es2i.password.manager.CommandPasswordManager
SET CONF_FILE=C:/programs/eSirius-14/tools/es2i-password-manager/es2i-password-manager.properties

%JAVA_JDK%/bin/java.exe -Des2i.password.manager.property.file=%CONF_FILE% -cp %JAVA_CLASSPATH% %action% %modifType% %username% %password%
