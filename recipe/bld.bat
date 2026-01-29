@echo off
setlocal enabledelayedexpansion

:: Suppress specific MSVC warnings that correspond to the GCC/Clang flags
:: C4013: implicit function declaration (like -Wno-error=implicit-int)
:: C4133: incompatible pointer types (like -Wno-error=incompatible-pointer-types)
set "CFLAGS=%CFLAGS% /wd4013 /wd4133"
set "CXXFLAGS=%CXXFLAGS% /wd4013 /wd4133"

mkdir build
cd build

cmake -G Ninja ^
    %CMAKE_ARGS% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DBUILD_TOOLS=OFF ^
    -DBUILD_SHARED_LIBS=ON ^
    -DBLA_STATIC=OFF ^
    -DBLA_VENDOR=Generic ^
    -DBLAS_LIBRARIES="%LIBRARY_LIB:\=/%/blas.lib;%LIBRARY_LIB:\=/%/cblas.lib" ^
    -DLAPACK_LIBRARIES="%LIBRARY_LIB:\=/%/lapack.lib" ^
    -DENABLE_TESTS=OFF ^
    ..
if errorlevel 1 exit 1

cmake --build . --parallel %CPU_COUNT% --config Release
if errorlevel 1 exit 1

cmake --install . --config Release
if errorlevel 1 exit 1
