@ECHO OFF

SET "BATPATH=%~dp0"
SET "BATPATH=%BATPATH:~0,-1%"

SET "BIN=%BATPATH%\bin"
SET "OUT_DIR=%BATPATH%\output"
SET "MSYS_BIN=%OUT_DIR%\msys64\usr\bin"

IF NOT EXIST "%OUT_DIR%" (
    ECHO %OUT_DIR% doesn't exist - did you run setup?
    EXIT
)

SUBST T: "%OUT_DIR%"

SET "PATH=%MSYS_BIN%;%PATH%"
SET "DEVKITPRO=/t/devkitPro"
SET "DEVKITARM=%DEVKITPRO%/devkitARM"

ECHO Launching MSYS2 terminal
ECHO Leave this console open - it will close automatically when MSYS2/mintty exits.

SET "MSYSTEM=MSYS" & SET "CHERE_INVOKING=1" & START "" /WAIT "%MSYS_BIN%\mintty.exe" -d -i /msys2.ico -s 160,50 --dir T:\src /usr/bin/bash --login -i

POPD
SUBST T: /D
