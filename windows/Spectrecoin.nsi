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

    ;Default data folder
    !define APPDATA_FOLDER "$APPDATA\Spectrecoin-test"


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

Section "Spectrecoin" SectionWalletBinary

    SetOutPath "$INSTDIR"

    ;All required files
    File /r content\Spectrecoin\*

    ;Store installation folder on registry
    WriteRegStr HKCU "Software\Spectrecoin" "" $INSTDIR

    ;Create startmenu entries
    CreateDirectory "$SMPROGRAMS\Spectrecoin"
    CreateShortCut "$SMPROGRAMS\Spectrecoin\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
    CreateShortCut "$SMPROGRAMS\Spectrecoin\Spectrecoin.lnk" "$INSTDIR\Spectrecoin.exe" "" "$INSTDIR\Spectrecoin.exe" 0

    ;Create uninstaller
    WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd

Section /o "Bootstrap Blockchain" SectionBlockchain

    CreateDirectory "${APPDATA_FOLDER}"
    SetOutPath "${APPDATA_FOLDER}"

    ;Backup wallet.dat if existing
    IfFileExists wallet.dat 0 goAheadWithDownload
;    MessageBox MB_OK "Create backup of wallet.dat"
    ${GetTime} "" "L" $0 $1 $2 $3 $4 $5 $6
    CopyFiles "wallet.dat" "wallet.dat.$2-$1-$0-$4$5$6"

    goAheadWithDownload:
;    MessageBox MB_OK "Downloading blockchain"
    Delete "$APPDATA_FOLDER\BootstrapChain.zip"
    inetc::get /caption "Downloading bootstrap blockchain. Patience, this could take a while..." /canceltext "Cancel" "https://github.com/spectrecoin/spectre-builder/archive/1.2.zip" "${APPDATA_FOLDER}\BootstrapChain.zip" /end
    Pop $1 # return value = exit code, "OK" means OK

    ;Remove existing blockchain data
    RMDir /r "$APPDATA_FOLDER\txleveldb"
    Delete "$APPDATA_FOLDER\blk0001.dat"

    ;Extract bootstrap chain archive
;    MessageBox MB_OK "Unzip blockchain"
    nsisunz::UnzipToStack "${APPDATA_FOLDER}\BootstrapChain.zip" "${APPDATA_FOLDER}\ziptest"
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

SectionEnd

;--------------------------------
;Descriptions

    ;Language strings
    LangString DESC_SectionWalletBinary ${LANG_ENGLISH} "The Spectrecoin wallet with all it's required components."
    LangString DESC_SectionBlockchain ${LANG_ENGLISH} "The bootstrap blockchain data."

    ;Assign language strings to sections
    !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
        !insertmacro MUI_DESCRIPTION_TEXT ${SectionWalletBinary} $(DESC_SectionWalletBinary)
        !insertmacro MUI_DESCRIPTION_TEXT ${SectionBlockchain} $(DESC_SectionBlockchain)
    !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

Section un.SectionWalletBinary

    ;Generate list and include it in script at compile-time
    !execute 'include\unList.exe /DATE=1 /INSTDIR=content\Spectrecoin /LOG=Install.log /PREFIX="	" /MB=0'
	!include "include\Install.log"

    Delete "$INSTDIR\Uninstall.exe"

    RMDir "$INSTDIR"

    Delete "$SMPROGRAMS\Spectrecoin\Uninstall.lnk"
    Delete "$SMPROGRAMS\Spectrecoin\Spectrecoin.lnk"
    RMDir "$SMPROGRAMS\Spectrecoin"

    DeleteRegKey /ifempty HKCU "Software\Spectrecoin"

SectionEnd
