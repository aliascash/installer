;NSIS Modern User Interface
;Spectrecoin installation script
;Written by HLXEasy

;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"

;--------------------------------
;General

  ;Name and file
  Name "Spectrecoin"
  OutFile "Spectrecoin-Installer.exe"
  Unicode True

  ;Default installation folder
  InstallDir "$LOCALAPPDATA\Spectrecoin"

  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\Spectrecoin" ""

  ;Request application privileges for Windows Vista
  RequestExecutionLevel user

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_LICENSE "LICENSE.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES

  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

Section "Spectrecoin" SecDummy

  SetOutPath "$INSTDIR"

  ;ADD YOUR OWN FILES HERE...
  File /r content\Spectrecoin\*
  SetOutPath $INSTDIR\Tor
  File /r content\Tor\*

  ;Store installation folder
  WriteRegStr HKCU "Software\Spectrecoin" "" $INSTDIR

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd

Section "Bootstrap Blockchain" SecBlockchain

  SetOutPath "$APPDATA"

  ;ADD YOUR OWN FILES HERE...

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall-BlockchainData.exe"

SectionEnd

;--------------------------------
;Descriptions

  ;Language strings
  LangString DESC_SecDummy ${LANG_ENGLISH} "The Spectrecoin wallet with all it's required components."
  LangString DESC_SecBlockchain ${LANG_ENGLISH} "The bootstrap blockchain data."

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDummy} $(DESC_SecDummy)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecBlockchain} $(DESC_SecBlockchain)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

Section "Uninstall"

  ;ADD YOUR OWN FILES HERE...

  Delete "$INSTDIR\Uninstall.exe"

  RMDir "$INSTDIR"

  DeleteRegKey /ifempty HKCU "Software\Spectrecoin"

SectionEnd