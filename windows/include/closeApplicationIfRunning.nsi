;  SPDX-FileCopyrightText: © 2020 Alias developers
;  SPDX-FileCopyrightText: © 2018 Spectrecoin developers
;  SPDX-License-Identifier: MIT
;
;  @author HLXEasy <hlxeasy@gmail.com>>
;
!macro myfunc un
Function ${un}CloseRunningApplication
    Pop $0
;    MessageBox MB_OK "Checking for running $0"
    DetailPrint "$(FIND_WALLET_PROCESS)"
    ${nsProcess::FindProcess} "$0" $R0

    ${If} $R0 == 0
;        MessageBox MB_OK "Aliaswallet is running. Closing it down"
        DetailPrint "$(WALLET_RUNNING_SHUT_IT_DOWN)"
        ${nsProcess::CloseProcess} "$0" $R0
        DetailPrint "$(WAIT_FOR_WALLET_SHUT_DOWN)"
        Sleep 10000
    ${Else}
;        MessageBox MB_OK "$0 was not found to be running"
        DetailPrint "$(NOT_RUNNING_AT_THE_MOMENT)"
    ${EndIf}

    ${nsProcess::Unload}
FunctionEnd
!macroend

!insertmacro myfunc ""
!insertmacro myfunc "un."
