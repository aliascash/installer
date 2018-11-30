:: Helper script to build Spectrecoin on Windows using VS2017 and QT.

IF "%QTIFWDIR%" == "" GOTO NOQT
:YESQT

set CALL_DIR=%cd%

%QTIFWDIR%\bin\repogen.exe -p packages -i Blockchain,Spectrecoin,Tor repository
%QTIFWDIR%\bin\binarycreator.exe -n -c config\config.xml -p packages Spectrecoin-Installer.exe


echo "Everything is OK"
GOTO END

:NOQT
@ECHO The QTDIR environment variable was NOT detected!

:END
cd %CALL_DIR%
