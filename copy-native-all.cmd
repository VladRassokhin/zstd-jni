@echo off

set /p version=<version

echo Copying Win32
call copy-native.cmd Win32 x86 %version%
IF ERRORLEVEL 1 EXIT 1

echo Copying x64
call copy-native.cmd x64 amd64 %version%
IF ERRORLEVEL 1 EXIT 1

echo Copying ARM64
call copy-native.cmd Arm64 aarch64 %version%
IF ERRORLEVEL 1 EXIT 1
