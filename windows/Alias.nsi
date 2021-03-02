;  SPDX-FileCopyrightText: © 2020 Alias developers
;  SPDX-FileCopyrightText: © 2018 Spectrecoin developers
;  SPDX-License-Identifier: MIT
;
;  NSIS Modern User Interface
;  Spectrecoin installation script
;
;  @author HLXEasy <hlxeasy@gmail.com>>
;
;--------------------------------
;Include Modern UI

    !include "MUI2.nsh"

    !include "FileFunc.nsh"
    !include "LogicLib.nsh"
    !include "nsDialogs.nsh"
    !include "include\nsProcess.nsh"
    !include "include\Time.nsh"
    !include "include\MUI_EXTRAPAGES.nsh"
    !insertmacro GetTime
    !insertmacro un.GetTime

;--------------------------------
;General

    ;Name and file
    Name "Alias"
    OutFile "Alias-Installer.exe"
    Unicode True

    ;Defaults
    InstallDir "$LOCALAPPDATA\Aliaswallet"
    !define APPDATA_FOLDER "$APPDATA\Aliaswallet"
    !define UninstId "Aliaswallet"

    ;To handle old installations, define some separate vars
    !define APPDATA_FOLDER_BEFORE_REBRANDING "$APPDATA\Spectrecoin"
    !define UninstIdBeforeRebranding "Spectrecoin"

    ;Get installation folder from registry if available
    InstallDirRegKey HKCU "Software\Aliaswallet" ""

    ;Request application privileges for Windows Vista
    RequestExecutionLevel user

    !include "include\uninstallHandling.nsi"
    !include "include\closeApplicationIfRunning.nsi"

    Var ChoosenTorFlavour

;--------------------------------
;Interface Settings

    !define MUI_ICON "images\alias-app.ico"
    !define MUI_WELCOMEFINISHPAGE_BITMAP "images\branding.bmp"
    !define MUI_HEADERIMAGE
    !define MUI_HEADERIMAGE_BITMAP "images\banner_150_57.bmp" ; optional
    !define MUI_HEADERIMAGE_BITMAP_NOSTRETCH
    !define MUI_HEADERIMAGE_UNBITMAP "images\banner_150_57.bmp" ; optional
    !define MUI_HEADERIMAGE_UNBITMAP_NOSTRETCH
    !define MUI_HEADERIMAGE_RIGHT
    !define MUI_HEADER_TRANSPARENT_TEXT
    !define MUI_ABORTWARNING
    !define MUI_FINISHPAGE_NOAUTOCLOSE
    !define MUI_FINISHPAGE_RUN "$INSTDIR\Alias.exe"

    !define MUI_UNFINISHPAGE_NOAUTOCLOSE
    !define MUI_UNWELCOMEFINISHPAGE_BITMAP "images\branding.bmp"

    ;Show all languages, despite user's codepage
    !define MUI_LANGDLL_ALLLANGUAGES

;--------------------------------
;Installer-Pages
    !insertmacro MUI_PAGE_WELCOME
    !insertmacro MUI_PAGE_LICENSE "LICENSE.txt"
    !insertmacro MUI_PAGE_README "README.txt"
    !insertmacro MUI_PAGE_COMPONENTS
    Page custom TorFlavourPage
    !insertmacro MUI_PAGE_DIRECTORY
    !insertmacro MUI_PAGE_INSTFILES

    ;Start the application
    !insertmacro MUI_PAGE_FINISH

;Uninstaller-Pages
    !insertmacro MUI_UNPAGE_WELCOME
    !insertmacro MUI_UNPAGE_README "README_UNINSTALL.txt"
    !insertmacro MUI_UNPAGE_CONFIRM
    !insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
;Languages

    !insertmacro MUI_LANGUAGE "English"
    !include "include\languages.nsh"

;--------------------------------
;Misc stuff

    !include "include\folderIcon.nsi"

;--------------------------------
;Installer Sections

Section "Alias" SectionWalletBinary
    ;Handle old executable from before project rebranding
    Push "Spectrecoin.exe"
    Call CloseRunningApplication
    Call CheckOldInstallationBeforeRebranding

    SetOutPath "$INSTDIR"

    Push "Alias.exe"
    Call CloseRunningApplication
    Call CheckPreviousInstallation

    ;All required files
    File /r content\Alias\*

    ${If} $ChoosenTorFlavour == "obfs4"
;    	MessageBox MB_OK "TorFlavour: $ChoosenTorFlavour"
    	Rename $INSTDIR\Tor\torrc-defaults $INSTDIR\Tor\torrc-defaults_default
    	Rename $INSTDIR\Tor\torrc-defaults_obfs4 $INSTDIR\Tor\torrc-defaults
    ${ElseIf} $ChoosenTorFlavour == "meek"
;    	MessageBox MB_OK "TorFlavour: $ChoosenTorFlavour"
    	Rename $INSTDIR\Tor\torrc-defaults $INSTDIR\Tor\torrc-defaults_default
    	Rename $INSTDIR\Tor\torrc-defaults_meek $INSTDIR\Tor\torrc-defaults
    ${Else}
;    	MessageBox MB_OK "TorFlavour: $ChoosenTorFlavour"
    ${EndIf}

    ;Store installation folder on registry
    WriteRegStr HKCU "Software\Aliaswallet" "" $INSTDIR
    WriteRegStr HKCU "Software\Aliaswallet\${UninstId}" "DisplayName" "Alias"
    WriteRegStr HKCU "Software\Aliaswallet\${UninstId}" "UninstallString" '"$INSTDIR\Uninstall.exe"'
    WriteRegStr HKCU "Software\Aliaswallet\${UninstId}" "QuietUninstallString" '"$INSTDIR\Uninstall.exe" /S'

    ;Create ini file
    WriteINIStr "$INSTDIR\Desktop.ini" ".ShellClassInfo" "IconFile" "$INSTDIR\Alias.exe"
    WriteINIStr "$INSTDIR\Desktop.ini" ".ShellClassInfo" "IconIndex" "0"
    !insertmacro PATH_MAKE_SYSTEM_FOLDER "$INSTDIR"

    ;Create startmenu entries
    CreateDirectory "$SMPROGRAMS\Alias"
    CreateShortCut "$SMPROGRAMS\Alias\Uninstall.lnk" "$INSTDIR\Uninstall.exe" "" "$INSTDIR\Uninstall.exe" 0
    CreateShortCut "$SMPROGRAMS\Alias\Alias.lnk" "$INSTDIR\Alias.exe" "" "$INSTDIR\Alias.exe" 0

    ;Create uninstaller
    WriteUninstaller "$INSTDIR\Uninstall.exe"

    ;Handle data dir from before rebranding
    IfFileExists "${APPDATA_FOLDER}" nothingToDo
;        MessageBox MB_OK "${APPDATA_FOLDER} not found"
        IfFileExists "${APPDATA_FOLDER_BEFORE_REBRANDING}" "" nothingToDo
;            MessageBox MB_OK "${APPDATA_FOLDER_BEFORE_REBRANDING} found"
            Rename "${APPDATA_FOLDER_BEFORE_REBRANDING}" "${APPDATA_FOLDER}"
    nothingToDo:
SectionEnd

Section /o "Bootstrap Blockchain" SectionBlockchain

    ;Define required space as blockchain will be downloaded separately during installation
    ;Bootstrap archive is around 1.2G, which is 1200000K
    ;Extracted chain is around 1.6G, which is 1600000K
    AddSize 2800000

    Push "Alias.exe"
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
    ;Change from spectreproject.io to alias.cash as soon as the new page is online,
    ;Otherwise download won't work!
    inetc::get /caption "Downloading bootstrap blockchain. Patience, this could take a while..." /canceltext "Cancel" "https://download.alias.cash/files/bootstrap/BootstrapChain.zip" "${APPDATA_FOLDER}\BootstrapChain.zip" /end
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

Var Dialog
Var TorFlavour

Function TorFlavourPage
    SectionGetFlags ${SectionWalletBinary} $R0
    IntOp $R0 $R0 & ${SF_SELECTED}
    IntCmp $R0 ${SF_SELECTED} show
        Abort
    show:
    !insertmacro MUI_HEADER_TEXT $(PAGE_TOR_FLAVOUR_TITLE) $(PAGE_TOR_FLAVOUR_SUBTITLE)

    nsDialogs::Create 1018
    Pop $Dialog

    ${If} $Dialog == error
        Abort
    ${EndIf}

    ${NSD_CreateGroupBox} 10% 10u 80% 62u "$(TOR_FLAVOUR_TITLE)"
    Pop $0
        ${NSD_CreateRadioButton} 20% 26u 40% 6% "$(TOR_FLAVOUR_DEFAULT)"
            Pop $TorFlavour
            ${NSD_AddStyle} $TorFlavour ${WS_GROUP}
            ${NSD_OnClick} $TorFlavour TorFlavour1Click
            ${NSD_Check} $TorFlavour
        ${NSD_CreateRadioButton} 20% 40u 40% 6% "$(TOR_FLAVOUR_OBFS4)"
            Pop $TorFlavour
            ${NSD_OnClick} $TorFlavour TorFlavour2Click
        ${NSD_CreateRadioButton} 20% 54u 40% 6% "$(TOR_FLAVOUR_MEEK)"
            Pop $TorFlavour
            ${NSD_OnClick} $TorFlavour TorFlavour3Click
    nsDialogs::Show
FunctionEnd

Function TorFlavour1Click
	Pop $TorFlavour
	StrCpy $ChoosenTorFlavour "default"
;	MessageBox MB_OK "TorFlavour1Click: $TorFlavour"
FunctionEnd
Function TorFlavour2Click
	Pop $TorFlavour
	StrCpy $ChoosenTorFlavour "obfs4"
;	MessageBox MB_OK "TorFlavour2Click: $TorFlavour"
FunctionEnd
Function TorFlavour3Click
	Pop $TorFlavour
	StrCpy $ChoosenTorFlavour "meek"
;	MessageBox MB_OK "TorFlavour3Click: $TorFlavour"
FunctionEnd

; Check if blockchain is already existing
Var currentTime
Var yesterday
Var fileTime1
Var fileTime2
Var fileTime3

Function .onInit
    ; Get current date
    ${time::GetLocalTime} $currentTime
;    MessageBox MB_OK 'time::GetLocalTime$\n$$currentTime={$currentTime}'

    ; Subtract 1 day from current date
    ${time::MathTime} "date($currentTime) - date(1.0.0 0:0:0) = date" $yesterday

    IfFileExists "${APPDATA_FOLDER}\blk0001.dat" blockchainAlreadyExists
        ;blk0001.dat file not found, so check if there might be one on the old location
        ;from before project rebranding
        IfFileExists "${APPDATA_FOLDER_BEFORE_REBRANDING}\blk0001.dat" blockchainAlreadyExistsOnOldLocation
            ;blk0001.dat file not found, so activate bootstrap installation section
            SectionSetFlags ${SectionBlockchain} ${SF_SELECTED}
            goto exit
        blockchainAlreadyExistsOnOldLocation:
            ; Get timestamps from blk0001.dat on old location
            ${time::GetFileTime} "${APPDATA_FOLDER_BEFORE_REBRANDING}\blk0001.dat" $fileTime1 $fileTime2 $fileTime3
;            MessageBox MB_OK 'time::GetFileTime$\n$$fileTime1={$fileTime1}$\n$$fileTime2={$fileTime2}$\n$$fileTime3={$fileTime3}'

            ; Check if last write access is older than 1 day. If yes, activate bootstrap installation section
            ${time::MathTime} "second($yesterday) - second($fileTime2) =" $0
            IntCmp $0 0 exit exit
;                MessageBox MB_OK 'Last write access older than one day' IDOK
                SectionSetFlags ${SectionBlockchain} ${SF_SELECTED}
    blockchainAlreadyExists:
        ; Get timestamps from blk0001.dat
        ${time::GetFileTime} "${APPDATA_FOLDER}\blk0001.dat" $fileTime1 $fileTime2 $fileTime3
;        MessageBox MB_OK 'time::GetFileTime$\n$$fileTime1={$fileTime1}$\n$$fileTime2={$fileTime2}$\n$$fileTime3={$fileTime3}'

        ; Check if last write access is older than 1 day. If yes, activate bootstrap installation section
        ${time::MathTime} "second($yesterday) - second($fileTime2) =" $0
        IntCmp $0 0 exit exit
;            MessageBox MB_OK 'Last write access older than one day' IDOK
            SectionSetFlags ${SectionBlockchain} ${SF_SELECTED}
    exit:
FunctionEnd

;--------------------------------
;Descriptions

    ;Assign language strings to sections
    !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
        !insertmacro MUI_DESCRIPTION_TEXT ${SectionWalletBinary} $(DESC_SectionWalletBinary)
        !insertmacro MUI_DESCRIPTION_TEXT ${SectionBlockchain} $(DESC_SectionBlockchain)
    !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

Section un.SectionWalletBinary

    Push "Alias.exe"
    Call un.CloseRunningApplication

    ;Generate list and include it in script at compile-time
    !execute 'include\unList.exe /DATE=1 /INSTDIR=content\Alias /LOG=Install.log /PREFIX="	" /MB=0'
	!include "include\Install.log"

    RMDir /r "$INSTDIR\Tor"

    Delete "$INSTDIR\Uninstall.exe"

    ;Do _NOT_ use /r here as this might remove way too much,
    ;depending on choosen install location!
    RMDir "$INSTDIR"

    Delete "$SMPROGRAMS\Alias\Uninstall.lnk"
    Delete "$SMPROGRAMS\Alias\Alias.lnk"
    RMDir "$SMPROGRAMS\Alias"

    DeleteRegKey HKCU "Software\Aliaswallet\${UninstId}"
    DeleteRegKey /ifempty HKCU "Software\Aliaswallet"

SectionEnd
