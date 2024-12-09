#!/usr/bin/env bash

autoreconf -vfi
chmod +x configure

./configure --prefix="$PREFIX" --libdir="$PREFIX"/lib --disable-hardware-specific-code --disable-static || cat config.log

[[ "$target_platform" == "win-64" ]] && patch_libtool

make -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" || "${CROSSCOMPILING_EMULATOR:-}" != "" ]]; then
  make check -j${CPU_COUNT}
fi
make install
