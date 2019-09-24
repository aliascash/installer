:: Helper script to build Spectrecoin on Windows using VS2017 and QT.

IF "%QTIFWDIR%" == "" GOTO NOQT
:YESQT

set CALL_DIR=%cd%

%QTIFWDIR%\bin\repogen.exe -p packages -i Spectrecoin,Tor repository
%QTIFWDIR%\bin\binarycreator.exe -c config\config.xml -p packages --online-only  Spectrecoin-Online-Installer.exe
%QTIFWDIR%\bin\binarycreator.exe -c config\config.xml -p packages --offline-only Spectrecoin-Installer.exe


echo "Everything is OK"
GOTO END

:NOQT
@ECHO The QTDIR environment variable was NOT detected!

:END
cd %CALL_DIR%
