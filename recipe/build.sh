#!/usr/bin/env bash

./configure --prefix="$PREFIX" --libdir="$PREFIX"/lib --disable-hardware-specific-code --disable-static || cat config.log

make -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
  make check -j${CPU_COUNT}
fi
make install
