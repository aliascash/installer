;2020-03-08 HLXEasy

!macro PATH_MAKE_SYSTEM_FOLDER pszPath

    System::Call    "shlwapi::PathMakeSystemFolder(t '${pszPath}') i."

!macroend
