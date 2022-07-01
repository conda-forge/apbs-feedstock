#!/bin/bash

set -e

cd apbs

# does not work in a separate ./build directory
cmake ${CMAKE_ARGS} \
  -DBUILD_TOOLS:BOOL=OFF \
  -DBUILD_SHARED_LIBS:BOOL=ON \
  -DBUILD_SUPERLU:BOOL=OFF \
  -DPYTHON_VERSION=${PY_VER} \
  -DCMAKE_INSTALL_PREFIX:PATH=${PREFIX} \
  ..

make
make install
