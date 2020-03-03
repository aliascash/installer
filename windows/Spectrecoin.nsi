;NSIS Modern User Interface
;Spectrecoin installation script
;Written by HLXEasy

;--------------------------------
;Include Modern UI

    !include "MUI2.nsh"

    !include "FileFunc.nsh"
    !insertmacro GetTime
    !insertmacro un.GetTime

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

    !define MUI_ICON "images\spectrecoin.ico"
    !define MUI_HEADERIMAGE
    !define MUI_HEADERIMAGE_BITMAP "images\banner_150_57.bmp" ; optional
    !define MUI_HEADERIMAGE_BITMAP_NOSTRETCH
    !define MUI_HEADERIMAGE_UNBITMAP "images\banner_150_57.bmp" ; optional
    !define MUI_HEADERIMAGE_UNBITMAP_NOSTRETCH
    !define MUI_HEADERIMAGE_RIGHT
    !define MUI_HEADER_TRANSPARENT_TEXT
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

    ;Store installation folder
    WriteRegStr HKCU "Software\Spectrecoin" "" $INSTDIR

    ;Create uninstaller
    WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd

Section /o "Bootstrap Blockchain" SecBlockchain

    CreateDirectory "$APPDATA\Spectrecoin-test"
    SetOutPath "$APPDATA\Spectrecoin-test"

    ;Backup wallet.dat if existing
    IfFileExists wallet.dat 0 goAheadWithDownload
    MessageBox MB_OK "Create backup of wallet.dat"
    ${GetTime} "" "L" $0 $1 $2 $3 $4 $5 $6
    CopyFiles "wallet.dat" "wallet.dat.$2-$1-$0-$4$5$6"

    goAheadWithDownload:
    MessageBox MB_OK "Downloading blockchain"
    inetc::get /caption "Downloading bootstrap blockchain. Patience, this could take a while..." /canceltext "Cancel" "https://github.com/spectrecoin/spectre-builder/archive/1.2.zip" "$APPDATA\Spectrecoin-test\BootstrapChain.zip" /end
    Pop $1 # return value = exit code, "OK" means OK

    MessageBox MB_OK "Unzip blockchain"
    nsisunz::UnzipToStack "$APPDATA\Spectrecoin-test\BootstrapChain.zip" "$APPDATA\Spectrecoin-test\ziptest"
    Pop $0
    StrCmp $0 "success" ok
        DetailPrint "$0" ;print error message to log
        Goto skiplist
    ok:

    ; Print out list of files extracted to log
    next:
    Pop $0
        DetailPrint $0
        StrCmp $0 "" 0 next ; pop strings until a blank one arrives

    skiplist:

    ;Create uninstaller
    WriteUninstaller "$APPDATA\chain-test\Uninstall-BlockchainData.exe"

SectionEnd

Section "Start Menu Shortcuts"
    CreateDirectory "$SMPROGRAMS\Spectrecoin"
    CreateShortCut "$SMPROGRAMS\Spectrecoin\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
    CreateShortCut "$SMPROGRAMS\Spectrecoin\Spectrecoin.lnk" "$INSTDIR\Spectrecoin.exe" "" "$INSTDIR\Spectrecoin.exe" 0
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

Section un.install

    ;Generate list and include it in script at compile-time
    !execute 'include\unList.exe /DATE=1 /INSTDIR=content\Spectrecoin /LOG=Install.log /PREFIX="	" /MB=0'
	!include "include\Install.log"

    Delete "$INSTDIR\Uninstall.exe"

    RMDir "$INSTDIR"

    DeleteRegKey /ifempty HKCU "Software\Spectrecoin"

SectionEnd