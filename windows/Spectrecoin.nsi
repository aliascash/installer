;NSIS Modern User Interface
;Spectrecoin installation script
;Written by HLXEasy

;--------------------------------
;Include Modern UI

    !include "MUI2.nsh"

    !include "FileFunc.nsh"
    !include "LogicLib.nsh"
    !include "nsProcess.nsh"
    !include "include\MUI_EXTRAPAGES.nsh"
    !insertmacro GetTime
    !insertmacro un.GetTime

;--------------------------------
;General

    ;Name and file
    Name "Spectrecoin"
    OutFile "Spectrecoin-Installer.exe"
    Unicode True

    ;Defaults
    InstallDir "$LOCALAPPDATA\Spectrecoin"
    !define APPDATA_FOLDER "$APPDATA\Spectrecoin"
    !define UninstId "Spectrecoin"

    ;Get installation folder from registry if available
    InstallDirRegKey HKCU "Software\Spectrecoin" ""

    ;Request application privileges for Windows Vista
    RequestExecutionLevel user

    !include "include\uninstallHandling.nsi"
    !include "include\closeApplicationIfRunning.nsi"

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

    Push "Spectrecoin.exe"
    Call CloseRunningApplication
    Call CheckPreviousInstallation

    ;All required files
    File /r content\Spectrecoin\*

    ;Store installation folder on registry
    WriteRegStr HKCU "Software\Spectrecoin" "" $INSTDIR
    WriteRegStr HKCU "Software\Spectrecoin\${UninstId}" "DisplayName" "Spectrecoin"
    WriteRegStr HKCU "Software\Spectrecoin\${UninstId}" "UninstallString" '"$INSTDIR\Uninstall.exe"'
    WriteRegStr HKCU "Software\Spectrecoin\${UninstId}" "QuietUninstallString" '"$INSTDIR\Uninstall.exe" /S'

    ;Create startmenu entries
    CreateDirectory "$SMPROGRAMS\Spectrecoin"
    CreateShortCut "$SMPROGRAMS\Spectrecoin\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
    CreateShortCut "$SMPROGRAMS\Spectrecoin\Spectrecoin.lnk" "$INSTDIR\Spectrecoin.exe" "" "$INSTDIR\Spectrecoin.exe" 0

    ;Create uninstaller
    WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd

Section /o "Bootstrap Blockchain" SectionBlockchain

    ;Define required space as blockchain will be downloaded separately during installation
    ;Bootstrap archive is around 1.2G, which is 1200000K
    ;Extracted chain is around 1.6G, which is 1600000K
    AddSize 2800000

    Push "Spectrecoin.exe"
    Call CloseRunningApplication

    CreateDirectory "${APPDATA_FOLDER}"
    SetOutPath "${APPDATA_FOLDER}"

    ;Backup wallet.dat if existing
    IfFileExists wallet.dat 0 checkForExistingBootstrapArchive
;        MessageBox MB_OK "Create backup of wallet.dat"
        ${GetTime} "" "L" $0 $1 $2 $3 $4 $5 $6
        IntCmp $4 9 0 0 +2
        StrCpy $4 '0$4'
        CopyFiles "wallet.dat" "wallet.dat.$2-$1-$0-$4$5$6"

    checkForExistingBootstrapArchive:
    IfFileExists "${APPDATA_FOLDER}\BootstrapChain.zip" 0 goAheadWithBootstrapDownload
        MessageBox MB_YESNO|MB_ICONQUESTION "Found existing bootstrap archive. Remove it and download new one?" /SD IDNO IDNO goAheadWithBootstrapExtraction
            Delete "${APPDATA_FOLDER}\BootstrapChain.zip"

    goAheadWithBootstrapDownload:
    inetc::get /caption "Downloading bootstrap blockchain. Patience, this could take a while..." /canceltext "Cancel" "https://download.spectreproject.io/files/bootstrap/BootstrapChain.zip" "${APPDATA_FOLDER}\BootstrapChain.zip" /end
    Pop $1 # return value = exit code, "OK" means OK

    goAheadWithBootstrapExtraction:
    ;Remove existing blockchain data
    RMDir /r "${APPDATA_FOLDER}\txleveldb"
    Delete "${APPDATA_FOLDER}\blk0001.dat"

    ;Extract bootstrap chain archive
;    MessageBox MB_OK "Unzip blockchain"
    DetailPrint "Extracting blockchain data..."
    nsisunz::UnzipToStack "${APPDATA_FOLDER}\BootstrapChain.zip" "${APPDATA_FOLDER}"
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
    LangString DESC_SectionWalletBinary ${LANG_ENGLISH} "The Spectrecoin wallet software with all it's required components."
    LangString DESC_SectionBlockchain ${LANG_ENGLISH} "The bootstrap blockchain data. Download may take some time as it's a 1.2G archive."

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

    DeleteRegKey HKCU "Software\Spectrecoin\${UninstId}"
    DeleteRegKey /ifempty HKCU "Software\Spectrecoin"

SectionEnd
