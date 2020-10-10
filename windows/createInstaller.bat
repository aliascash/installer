:: ===========================================================================
::  SPDX-FileCopyrightText: © 2020 Alias developers
::  SPDX-FileCopyrightText: © 2018 Spectrecoin developers
::  SPDX-License-Identifier: MIT
::
::  @author HLXEasy <hlxeasy@gmail.com>>
::
::  Helper script to build Spectrecoin on Windows using VS2017 and QT.
:: ===========================================================================

IF "%NSIS_DIR%" == "" GOTO NONSIS
:YESNSIS

set CALL_DIR=%cd%
set SRC_DIR=%cd%\windows
cd
cd %SRC_DIR%

"%NSIS_DIR%\makensis.exe" /V4 Alias.nsi

echo "Everything is OK"
GOTO END

:NONSIS
@ECHO The NSIS_DIR environment variable was NOT detected!

:END
cd %CALL_DIR%
