:: ===========================================================================
::  SPDX-FileCopyrightText: © 2020 Alias developers
::  SPDX-FileCopyrightText: © 2018 Spectrecoin developers
::  SPDX-License-Identifier: MIT
::
::  @author HLXEasy <hlxeasy@gmail.com>>
::
::  Helper script to build an Alias Windows installer.
:: ===========================================================================

@echo off

set CALL_DIR=%cd%
set SRC_DIR=%cd%\windows
cd
cd %SRC_DIR%

where /q ISCC.exe
IF ERRORLEVEL 1 (
    IF "%INNOSETUP_DIR%" == "" GOTO NOINNOSETUP
    :YESINNOSETUP
    "%INNOSETUP_DIR%\ISCC.exe" Alias.iss
) ELSE (
    ISCC.exe Alias.iss
)

echo "Everything is OK"
GOTO END

:NOINNOSETUP
@ECHO INNOSETUP_DIR environment variable not detected and ISCC.exe is not on PATH!

:END
cd %CALL_DIR%
