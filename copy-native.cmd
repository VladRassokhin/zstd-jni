@echo off

set build_arch=%1%
set target_arch=%2%
set version=%3%
set configuration=Release

md target/classes/win/%target_arch%/
copy build-%build_arch%/%configuration%/libzstd-jni-%version%.dll target/classes/win/%target_arch%/
