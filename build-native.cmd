@echo off
setlocal

set arch=%1%
set system_version=%2%
set configuration=Release

SET BUILD_DIR=build-%arch%

IF EXIST "%BUILD_DIR%" RMDIR /S /Q "%BUILD_DIR%"
MKDIR "%BUILD_DIR%" & CD "%BUILD_DIR%"

cmake -G "Visual Studio 15 2017" -T v141,host=x64 -A %arch% -DCMAKE_SYSTEM_VERSION=%system_version% ..
IF ERRORLEVEL 1 EXIT 1

cmake --build . --config %configuration% -- -clp:ShowCommandLine
IF ERRORLEVEL 1 EXIT 2


endlocal
