# Spectrecoin installer

# Preparation
* Install [QT Installer Framework](http://doc.qt.io/qtinstallerframework/index.html)
* Setup env var QTIFWDIR with path to installed QT Installer Framework

## Windows - offline
%QTIFWDIR%\bin\binarycreator.exe --offline-only -c config\config.xml -p packages Spectrecoin-Installer.exe

## Windows - online
%QTIFWDIR%\bin\repogen.exe -p packages -i Spectrecoin,Tor repository
%QTIFWDIR%\bin\binarycreator.exe -n -c config\config.xml -p packages Spectrecoin-Installer.exe
