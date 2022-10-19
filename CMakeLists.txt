cmake_minimum_required(VERSION 3.5)
include(CheckCCompilerFlag)
project(zstd-jni C ASM)
file(STRINGS "version" NATIVE_VERSION)

set(JAVA_HOME $ENV{JAVA_HOME})
if(NOT JAVA_HOME)
  set(JAVA_HOME $ENV{JDK_HOME})
endif()
if(NOT JAVA_HOME)
  message(FATAL_ERROR "At least one of JAVA_HOME or JDK_HOME variables should be declared.")
endif()

file(GLOB_RECURSE SOURCES RELATIVE ${CMAKE_SOURCE_DIR} "src/main/native/*.c" "src/main/native/*.S")

add_library(${PROJECT_NAME} SHARED ${SOURCES})

set_target_properties(${PROJECT_NAME} PROPERTIES OUTPUT_NAME "lib${PROJECT_NAME}-${NATIVE_VERSION}")

target_include_directories(${PROJECT_NAME} PRIVATE "src/main/native" "src/main/native/common" "src/main/native/compress" "src/main/native/decompress" "src/main/native/dictBuilder" "src/main/native/legacy")
target_include_directories(${PROJECT_NAME} PRIVATE ${JAVA_HOME}/include ${JAVA_HOME}/include/win32 ${JAVA_HOME}/include/darwin ${JAVA_HOME}/include/linux)

add_compile_definitions("ZSTD_MULTITHREAD=1")
add_compile_definitions("ZSTD_LEGACY_SUPPORT=4")
CHECK_C_COMPILER_FLAG(-Oz COMPILER_SUPPORTS_OZ)
if(COMPILER_SUPPORTS_OZ)
    add_compile_options("-Oz")
endif()

target_compile_options(${PROJECT_NAME} PRIVATE "-std=c99")

if (WIN32)
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /MT")
    add_definitions("-D_JNI_IMPLEMENTATION_")
    target_compile_options(${PROJECT_NAME} PRIVATE "/sdl" "/Oi" "/Ob2" "/GL-" "/Zi" "/EHsc" "/Gy")
    target_link_options(${PROJECT_NAME} PRIVATE /MANIFEST:NO /INCREMENTAL:NO /OPT:NOREF /LTCG "/pdbaltpath:%_PDB%")
else()
    target_compile_options(${PROJECT_NAME} PRIVATE "-Wundef" "-Wshadow" "-Wcast-align" "-Wstrict-prototypes" "-Wno-unused-variable" "-Wpointer-arith" "-flto")
    target_link_options(${PROJECT_NAME} PRIVATE "-lpthread")
endif()

if (APPLE)
    target_link_options(${PROJECT_NAME} PRIVATE "-exported_symbols_list" "${CMAKE_SOURCE_DIR}/libzstd-jni.so.exported")
elseif (UNIX)
    target_link_options(${PROJECT_NAME} PRIVATE "-static-libgcc" "-Wl,--version-script=${CMAKE_SOURCE_DIR}/libzstd-jni.so.map")
endif()
