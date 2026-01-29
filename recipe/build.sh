#!/bin/bash

set -e

export CFLAGS="${CFLAGS} -Wno-error=implicit-int -Wno-error=incompatible-pointer-types"

# Help CMake find BLAS/LAPACK in the conda environment
export BLAS_LIBRARIES="${PREFIX}/lib/libblas${SHLIB_EXT};${PREFIX}/lib/libcblas${SHLIB_EXT}"
export LAPACK_LIBRARIES="${PREFIX}/lib/liblapack${SHLIB_EXT}"

if [[ $build_platform != $target_platform ]]; then
  EXTRA_CMAKE_ARGS="${EXTRA_CMAKE_ARGS} -DFLOAT_EPSILON_COMPILED=1"
  EXTRA_CMAKE_ARGS="${EXTRA_CMAKE_ARGS} -DFLOAT_EPSILON_COMPILED__TRYRUN_OUTPUT=2.22e-16"
  EXTRA_CMAKE_ARGS="${EXTRA_CMAKE_ARGS} -DDOUBLE_EPSILON_COMPILED=1"
  EXTRA_CMAKE_ARGS="${EXTRA_CMAKE_ARGS} -DDOUBLE_EPSILON_COMPILED__TRYRUN_OUTPUT=2.22e-16"
fi

# does not work in a separate ./build directory
cmake                                   \
  ${CMAKE_ARGS}                         \
  -G Ninja                              \
  -Bbuild                               \
  -DBUILD_TOOLS:BOOL=OFF                \
  -DBUILD_SHARED_LIBS:BOOL=ON           \
  -DBLA_STATIC=OFF                      \
  -DBLA_VENDOR=Generic                  \
  -DBLAS_LIBRARIES="${PREFIX}/lib/libblas${SHLIB_EXT};${PREFIX}/lib/libcblas${SHLIB_EXT}" \
  -DLAPACK_LIBRARIES="${PREFIX}/lib/liblapack${SHLIB_EXT}" \
  -DENABLE_TESTS=OFF                    \
  -DCMAKE_INSTALL_PREFIX:PATH=${PREFIX} \
  ${EXTRA_CMAKE_ARGS}                   \
  -S .

cmake --build build --parallel ${CPU_COUNT} --config Release
cmake --install build --config Release
