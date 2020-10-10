;  SPDX-FileCopyrightText: © 2020 Alias developers
;  SPDX-FileCopyrightText: © 2020 Spectrecoin developers
;  SPDX-License-Identifier: MIT
;
;  @author HLXEasy <hlxeasy@gmail.com>>
;
!macro PATH_MAKE_SYSTEM_FOLDER pszPath

    System::Call    "shlwapi::PathMakeSystemFolder(t '${pszPath}') i."

!macroend
