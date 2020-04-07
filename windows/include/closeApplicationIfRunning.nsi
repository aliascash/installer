;  SPDX-FileCopyrightText: © 2020 The Spectrecoin developers
;  SPDX-License-Identifier: MIT/X11
;
;  @author   HLXEasy <helix@spectreproject.io>
;
!macro myfunc un
Function ${un}CloseRunningApplication
    Pop $0
;    MessageBox MB_OK "Checking for running $0"
    DetailPrint "Checking for running $0"
    ${nsProcess::FindProcess} "$0" $R0

    ${If} $R0 == 0
;        MessageBox MB_OK "Spectrecoin is running. Closing it down"
        DetailPrint "Spectrecoin is running. Closing it down"
        ${nsProcess::CloseProcess} "$0" $R0
        DetailPrint "Waiting for Spectrecoin to close"
        Sleep 10000
    ${Else}
;        MessageBox MB_OK "$0 was not found to be running"
        DetailPrint "$0 was not found to be running"
    ${EndIf}

    ${nsProcess::Unload}
FunctionEnd
!macroend

!insertmacro myfunc ""
!insertmacro myfunc "un."
