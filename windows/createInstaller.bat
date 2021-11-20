:: ===========================================================================
::  SPDX-FileCopyrightText: © 2020 Alias developers
::  SPDX-FileCopyrightText: © 2018 Spectrecoin developers
::  SPDX-License-Identifier: MIT
::
::  @author HLXEasy <hlxeasy@gmail.com>>
::
::  Helper script to build an Alias Windows installer.
:: ===========================================================================

IF "%INNOSETUP_DIR%" == "" GOTO NOINNOSETUP
:YESINNOSETUP

set CALL_DIR=%cd%
set SRC_DIR=%cd%\windows
cd
cd %SRC_DIR%

"%INNOSETUP_DIR%\Compil32.exe" Alias.iss

echo "Everything is OK"
GOTO END

:NOINNOSETUP
@ECHO The INNOSETUP_DIR environment variable was NOT detected!

:END
cd %CALL_DIR%
