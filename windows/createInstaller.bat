:: Helper script to build Spectrecoin on Windows using VS2017 and QT.

IF "%NSISDIR%" == "" GOTO NONSIS
:YESNSIS

set CALL_DIR=%cd%

"%NSISDIR%\makensisw.exe" Spectrecoin.nsi

echo "Everything is OK"
GOTO END

:NONSIS
@ECHO The NSISDIR environment variable was NOT detected!

:END
cd %CALL_DIR%
