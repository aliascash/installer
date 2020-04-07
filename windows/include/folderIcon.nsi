;  SPDX-FileCopyrightText: © 2020 The Spectrecoin developers
;  SPDX-License-Identifier: MIT/X11
;
;  @author   HLXEasy <helix@spectreproject.io>
;

!macro PATH_MAKE_SYSTEM_FOLDER pszPath

    System::Call    "shlwapi::PathMakeSystemFolder(t '${pszPath}') i."

!macroend
