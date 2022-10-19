@echo off

echo Building Win32
call build-native.cmd Win32 8.1
IF ERRORLEVEL 1 EXIT 1

echo Building x64
call build-native.cmd x64 8.1
IF ERRORLEVEL 1 EXIT 1

echo Building ARM64
call build-native.cmd Arm64 10.0.14393.0
IF ERRORLEVEL 1 EXIT 1
