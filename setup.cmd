@ECHO OFF

SET "BATPATH=%~dp0"
SET "BATPATH=%BATPATH:~0,-1%"

SET "BIN=%BATPATH%\bin"
SET "DOWNLOADS=%BATPATH%\downloads"
SET "SETUP_TEMP=%BATPATH%\temp"
SET "OUT_DIR=%BATPATH%\output"


SET "MSYS_SERVER=http://repo.msys2.org/distrib/x86_64"
SET "MSYS_FILE_NAME=msys2-base-x86_64-20161025.tar.xz"
SET "MSYS_URL=%MSYS_SERVER%/%MSYS_FILE_NAME%"

SET "DEVKITARM_URL=https://sourceforge.net/projects/devkitpro/files/devkitARM/devkitARM_r45/devkitARM_r45-win32.exe/download"
SET "DEVKITARM_FILENAME=devkitARM_r45-win32.exe"

SET "LIBFATNDS_URL=https://sourceforge.net/projects/devkitpro/files/libfat/1.0.14/libfat-nds-1.0.14.tar.bz2/download"
SET "LIBFATNDS_FILENAME=libfat-nds-1.0.14.tar.bz2"

SET "MAXMODNDS_URL=https://sourceforge.net/projects/devkitpro/files/maxmod/maxmod-nds-1.0.9.tar.bz2/download"
SET "MAXMODNDS_FILENAME=maxmod-nds-1.0.9.tar.bz2"

ECHO Creating directories...
PAUSE

IF NOT EXIST "%DOWNLOADS%" (
    MKDIR "%DOWNLOADS%"
)

IF NOT EXIST "%DOWNLOADS%\msys" (
    MKDIR "%DOWNLOADS%\msys"
)

IF NOT EXIST "%DOWNLOADS%\devkitPro" (
    MKDIR "%DOWNLOADS%\devkitPro"
)

IF EXIST "%SETUP_TEMP%\" (
    ECHO Clearing temp dir...
    RMDIR /S /Q "%SETUP_TEMP%\"
)
IF NOT EXIST "%SETUP_TEMP%" (
    MKDIR "%SETUP_TEMP%"
)

IF NOT EXIST "%OUT_DIR%" (
    MKDIR "%OUT_DIR%"
)

IF NOT EXIST "%OUT_DIR%\src" (
    MKDIR "%OUT_DIR%\src"
)

ECHO.
ECHO Downloading MSYS2...
SET "MSYS_BASE=%DOWNLOADS%\msys\%MSYS_FILE_NAME%"
IF NOT EXIST "%MSYS_BASE%" (
    ECHO Downloading MSYS setup from %MSYS_URL% to %MSYS_BASE%...
    "%BIN%\curl.exe" --output "%MSYS_BASE%" --url "%MSYS_URL%"
)

ECHO.
ECHO Extracting MSYS2...
REM extract msys
"%BIN%\7z.exe" x "%MSYS_BASE%" "-o%SETUP_TEMP%"

FOR /F %%i IN ("%MSYS_BASE%") do SET "MSYS_BASE_BASE=%%~ni"
ECHO MSYS_BASE_BASE: %MSYS_BASE_BASE%
REM MSYS tar file contains a single msys64 directory
"%BIN%\7z.exe" x "%SETUP_TEMP%\%MSYS_BASE_BASE%" "-o%OUT_DIR%"

REM MSYS2 initial launch

PUSHD "%OUT_DIR%\msys64"
SET "MSYS_BIN=%OUT_DIR%\msys64\usr\bin"
SET "MSYSTEM=MSYS"
SET "CONTITLE=MSYS2 MSYS"

ECHO.
ECHO MSYS2 setup 1/4: Initial MSYS2 launch...
START "" /WAIT "%MSYS_BIN%\mintty.exe" -i /msys2.ico -s 160,50 /usr/bin/bash --login -c "exit"

ECHO MSYS2 setup 2/4: Updating stage 1/2 (you may need to click X to close the console window at the end)...
START "" /WAIT "%MSYS_BIN%\mintty.exe" -i /msys2.ico -s 160,50 /usr/bin/bash --login -c "pacman --noconfirm -Syuu || read -n1 -r -p ""Press any key to continue..."" key"

REM User will probably have to close and restart
ECHO MSYS2 setup 3/4: Updating stage 2/2...
START "" /WAIT "%MSYS_BIN%\mintty.exe" -i /msys2.ico -s 160,50 /usr/bin/bash --login -c "pacman --noconfirm -Syuu || read -n1 -r -p ""Press any key to continue..."" key"

REM Install some stuff
ECHO MSYS2 setup 4/4: Installing development tools...
START "" /WAIT "%MSYS_BIN%\mintty.exe" -i /msys2.ico -s 160,50 /usr/bin/bash --login -c "pacman --noconfirm -S man-pages-posix git base-devel gcc mingw-w64-x86_64-gcc python2 zip tar || read -n1 -r -p ""Press any key to continue..."" key"
POPD

ECHO MSYS2 installed.

ECHO.
ECHO Ready to download:
PAUSE

REM Download devkitPro files
ECHO.
PUSHD "%DOWNLOADS%\devkitPro"
IF NOT EXIST "%DEVKITARM_FILENAME%" (
    ECHO Downloading %DEVKITARM_FILENAME%...
    "%BIN%\curl.exe" -L -O -J "%DEVKITARM_URL%"
)

IF NOT EXIST "%LIBFATNDS_FILENAME%" (
    ECHO Downloading %LIBFATNDS_FILENAME%...
    "%BIN%\curl.exe" -L -O -J "%LIBFATNDS_URL%"
)

IF NOT EXIST "%MAXMODNDS_FILENAME%" (
    ECHO Downloading %MAXMODNDS_FILENAME%...
    "%BIN%\curl.exe" -L -O -J "%MAXMODNDS_URL%"
)
POPD

ECHO.
ECHO Ready to install devkitARM:
PAUSE

REM extract devkitARM
ECHO Installing devkitARM:
"%BIN%\7z.exe" x "%DOWNLOADS%\devkitPro\%DEVKITARM_FILENAME%" "-o%OUT_DIR%\devkitPro\"

ECHO devkitARM installed.

ECHO.
ECHO Ready to download and build components:
PAUSE

SUBST T: "%OUT_DIR%"
PUSHD T:\

SET "PATH=%MSYS_BIN%;%PATH%"
SET "DEVKITPRO=/t/devkitPro"
SET "DEVKITARM=%DEVKITPRO%/devkitARM"


REM download and build libnds
ECHO.
ECHO Downloading ahezard/libnds source...
"%MSYS_BIN%\git.exe" clone "https://github.com/ahezard/libnds.git" "T:\src\libnds"
ECHO Compiling and installing ahezard/libnds...
START "" /WAIT "%MSYS_BIN%\mintty.exe" -i /msys2.ico -s 160,50 /usr/bin/bash --login -c "cd ""/t/src/libnds/"" && make && make install"

REM extract libfat-nds into libnds
ECHO.
ECHO Installing libfat-nds:
"%BIN%\7z.exe" x "%DOWNLOADS%\devkitPro\%LIBFATNDS_FILENAME%" "-o%SETUP_TEMP%"
FOR /F %%i IN ("%LIBFATNDS_FILENAME%") do SET "LIBFATNDS_FILENAME_BASE=%%~ni"
"%BIN%\7z.exe" x "%SETUP_TEMP%\%LIBFATNDS_FILENAME_BASE%" "-o%OUT_DIR%\devkitPro\libnds\"

REM extract maxmod-nds into libnds
ECHO.
ECHO Installing maxmod-nds:
"%BIN%\7z.exe" x "%DOWNLOADS%\devkitPro\%MAXMODNDS_FILENAME%" "-o%SETUP_TEMP%"
FOR /F %%i IN ("%MAXMODNDS_FILENAME%") do SET "MAXMODNDS_FILENAME_BASE=%%~ni"
"%BIN%\7z.exe" x "%SETUP_TEMP%\%MAXMODNDS_FILENAME_BASE%" "-o%OUT_DIR%\devkitPro\libnds\"


REM Checkout and build ctrulib
ECHO.
ECHO Downloading ctrulib source...
"%MSYS_BIN%\git.exe" clone "https://github.com/smealum/ctrulib.git" "T:\src\ctrulib"
REM Checkout last revision before devkitARM r46 changes
CD "T:\src\ctrulib"
"%MSYS_BIN%\git.exe" checkout -f 396d341a8f8430c2724c6e9d596488f0160a6062
ECHO Compiling and installing ctrulib...
START "" /WAIT "%MSYS_BIN%\mintty.exe" -i /msys2.ico -s 160,50 /usr/bin/bash --login -c "cd ""/t/src/ctrulib/libctru/"" && make && make install"

REM Checkout and build citro3d
ECHO.
ECHO Downloading citro3d source...
"%MSYS_BIN%\git.exe" clone "https://github.com/fincs/citro3d.git" "T:\src\citro3d"
ECHO Compiling and installing ctrulib...
START "" /WAIT "%MSYS_BIN%\mintty.exe" -i /msys2.ico -s 160,50 /usr/bin/bash --login -c "cd ""/t/src/citro3d/"" && make && make install"

REM Checkout and build 3ds_portlibs
ECHO.
ECHO Downloading 3ds_portlibs (freetype, libjpeg-turbo, libpng) source...
"%MSYS_BIN%\git.exe" clone "https://github.com/devkitPro/3ds_portlibs.git" "T:\src\3ds_portlibs"
REM Checkout last revision before devkitARM r46 changes
CD "T:\src\3ds_portlibs"
"%MSYS_BIN%\git.exe" checkout -f 9f06d968b75158f6938cf0d704ef66b0c3e1bad8
ECHO Compiling and installing 3ds_portlibs...
START "" /WAIT "%MSYS_BIN%\mintty.exe" -i /msys2.ico -s 160,50 /usr/bin/bash --login -c "cd ""/t/src/3ds_portlibs/"" && make zlib && make install-zlib && make freetype libjpeg-turbo libpng && make install"

REM Checkout and build sf2dlib
ECHO.
ECHO Downloading sf2dlib source...
"%MSYS_BIN%\git.exe" clone "https://github.com/xerpi/sf2dlib.git" "T:\src\sf2dlib"
ECHO Compiling and installing sf2dlib...
START "" /WAIT "%MSYS_BIN%\mintty.exe" -i /msys2.ico -s 160,50 /usr/bin/bash --login -c "cd ""/t/src/sf2dlib/libsf2d/"" && make && make install"

REM Checkout and build sfillib
ECHO.
ECHO Downloading sfillib source...
"%MSYS_BIN%\git.exe" clone "https://github.com/xerpi/sfillib.git" "T:\src\sfillib"
ECHO Compiling and installing sfillib...
START "" /WAIT "%MSYS_BIN%\mintty.exe" -i /msys2.ico -s 160,50 /usr/bin/bash --login -c "cd ""/t/src/sfillib/libsfil/"" && make && make install"

REM Checkout and build sftdlib
ECHO.
ECHO Downloading sftdlib source...
"%MSYS_BIN%\git.exe" clone "https://github.com/xerpi/sftdlib.git" "T:\src\sftdlib"
ECHO Compiling and installing sftdlib...
START "" /WAIT "%MSYS_BIN%\mintty.exe" -i /msys2.ico -s 160,50 /usr/bin/bash --login -c "cd ""/t/src/sftdlib/libsftd/"" && make && make install"


REM Native tools used in app build

REM makerom
ECHO.
ECHO Downloading makerom source...
"%MSYS_BIN%\git.exe" clone "https://github.com/profi200/Project_CTR.git" "T:\src\Project_CTR"
ECHO Compiling and installing makerom...
SET "MSYSTEM=MINGW64"
START "" /WAIT "%MSYS_BIN%\mintty.exe" -i /mingw64.exe,0 -s 160,50 /usr/bin/bash --login -c "cd ""/t/src/Project_CTR/makerom/"" && make && cp makerom.exe /usr/bin/"

REM make_cia
ECHO.
ECHO Downloading make_cia source...
"%MSYS_BIN%\git.exe" clone "https://github.com/noxiousninja/ctr_toolkit.git" "T:\src\ctr_toolkit"
ECHO Compiling and installing make_cia...
SET "MSYSTEM=MINGW64"
START "" /WAIT "%MSYS_BIN%\mintty.exe" -i /mingw64.exe,0 -s 160,50 /usr/bin/bash --login -c "cd ""/t/src/ctr_toolkit/make_cia/"" && make && cp make_cia.exe /usr/bin/"

REM bannertool
ECHO.
ECHO Downloading bannertool source...
"%MSYS_BIN%\git.exe" clone --recursive "https://github.com/Steveice10/bannertool.git" "T:\src\bannertool"
ECHO Compiling and installing bannertool...
SET "MSYSTEM=MINGW64"
START "" /WAIT "%MSYS_BIN%\mintty.exe" -i /mingw64.exe,0 -s 160,50 /usr/bin/bash --login -c "cd ""/t/src/bannertool/"" && make && cp output/windows-x86_64/bannertool.exe /usr/bin/"

ECHO.
ECHO.
ECHO Prereqs ready, now for TWLoader:
PAUSE

REM TWLoader
ECHO.
ECHO Downloading TWLoader source...
"%MSYS_BIN%\git.exe" clone --recursive "https://github.com/Robz8/TWLoader.git" "T:\src\TWLoader"
SET "MSYSTEM=MSYS"

REM Compile twlnand-side
ECHO.
ECHO Compiling TWLoader/twlnand-side:
START "" /WAIT "%MSYS_BIN%\mintty.exe" -i /msys2.ico -s 160,50 /usr/bin/bash --login -c "cd ""/t/src/TWLoader/twlnand-side/"" && make && ./patch_ndsheader_dsiware.py TWLapp-hb.nds --mode dsi --maker 01 --code TWLD --title ""TWLOADER-TWL"" --out TWLapp.nds && make_cia --srl=""TWLapp.nds"" && cp ""TWLapp.cia"" ""../7zfile/sdroot/TWLoader - TWLNAND side.cia"""

REM Compile NTR_Launcher
ECHO.
ECHO Compiling TWLoader/NTR_Launcher:
START "" /WAIT "%MSYS_BIN%\mintty.exe" -i /msys2.ico -s 160,50 /usr/bin/bash --login -c "cd ""/t/src/TWLoader/NTR_Launcher/"" && make && cp ""NTR_Launcher.nds"" ""../7zfile/sdroot/_nds/twloader/NTR_Launcher.nds"""

REM Compile gui
ECHO.
ECHO Compiling TWLoader/gui:
START "" /WAIT "%MSYS_BIN%\mintty.exe" -i /msys2.ico -s 160,50 /usr/bin/bash --login -c "cd ""/t/src/TWLoader/gui/"" && make && cp ""TWLoader.cia"" ""../7zfile/sdroot/TWLoader.cia"""

REM Compile flashcard-side
ECHO.
ECHO Compiling TWLoader/flashcard-side:
START "" /WAIT "%MSYS_BIN%\mintty.exe" -i /msys2.ico -s 160,50 /usr/bin/bash --login -c "cd ""/t/src/TWLoader/flashcard-side/"" && make && cp ""flashcard-side.nds"" ""../7zfile/flashcardroot/_nds/twloader.nds"" ; read -n1 -r -p ""Press any key to continue..."" key"

POPD
SUBST T: /D
