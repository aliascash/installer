;  SPDX-FileCopyrightText: © 2020 Alias developers
;  SPDX-FileCopyrightText: © 2020 Spectrecoin developers
;  SPDX-License-Identifier: MIT
;
;  @author HLXEasy <hlxeasy@gmail.com>>
;
;  based on https://nsis.sourceforge.io/Auto-uninstall_old_before_installing_new

!macro UninstallExisting exitcode uninstcommand
Push `${uninstcommand}`
Call UninstallExisting
Pop ${exitcode}
!macroend

Function UninstallExisting
Exch $1 ; uninstcommand
Push $2 ; Uninstaller
Push $3 ; Len
StrCpy $3 ""
StrCpy $2 $1 1
StrCmp $2 '"' qloop sloop
sloop:
	StrCpy $2 $1 1 $3
	IntOp $3 $3 + 1
	StrCmp $2 "" +2
	StrCmp $2 ' ' 0 sloop
	IntOp $3 $3 - 1
	Goto run
qloop:
	StrCmp $3 "" 0 +2
	StrCpy $1 $1 "" 1 ; Remove initial quote
	IntOp $3 $3 + 1
	StrCpy $2 $1 1 $3
	StrCmp $2 "" +2
	StrCmp $2 '"' 0 qloop
run:
	StrCpy $2 $1 $3 ; Path to uninstaller
	StrCpy $1 161 ; ERROR_BAD_PATHNAME
	GetFullPathName $3 "$2\.." ; $InstDir
	IfFileExists "$2" 0 +4
	ExecWait '"$2" /S _?=$3' $1 ; This assumes the existing uninstaller is a NSIS uninstaller, other uninstallers don't support /S nor _?=
	IntCmp $1 0 "" +2 +2 ; Don't delete the installer if it was aborted
	Delete "$2" ; Delete the uninstaller
	RMDir "$3" ; Try to delete $InstDir
	RMDir "$3\.." ; (Optional) Try to delete the parent of $InstDir
Pop $3
Pop $2
Exch $1 ; exitcode
FunctionEnd


;Function .onInit
Function CheckPreviousInstallation
ReadRegStr $0 HKCU "Software\Aliaswallet\${UninstId}" "UninstallString"
${If} $0 != ""
    MessageBox MB_OKCANCEL|MB_ICONQUESTION "$(PREVIOUS_VERSION_FOUND)" /SD IDOK IDOK uninstallPreviousVersion
	    Abort

	uninstallPreviousVersion:
	!insertmacro UninstallExisting $0 $0
	${If} $0 <> 0
		MessageBox MB_YESNO|MB_ICONSTOP "$(UNINSTALL_FAILED)" /SD IDYES IDYES +2
			Abort
	${EndIf}
${EndIf}
FunctionEnd

Function CheckOldInstallationBeforeRebranding
ReadRegStr $0 HKCU "Software\Spectrecoin\${UninstIdBeforeRebranding}" "UninstallString"
${If} $0 != ""
    MessageBox MB_OKCANCEL|MB_ICONQUESTION "$(VERSION_FROM_BEFORE_REBRANDING_FOUND)" /SD IDOK IDOK uninstallPreviousVersion
	    Abort

	uninstallPreviousVersion:
	!insertmacro UninstallExisting $0 $0
	${If} $0 <> 0
		MessageBox MB_YESNO|MB_ICONSTOP "$(UNINSTALL_FAILED)" /SD IDYES IDYES +2
			Abort
	${EndIf}
${EndIf}
FunctionEnd
