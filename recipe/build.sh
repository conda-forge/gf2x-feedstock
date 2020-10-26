#!/usr/bin/env bash

autoreconf -i
chmod +x configure

export CFLAGS="-g $CFLAGS"

if [[ "$target_platform" == win-* ]]; then
  ./configure --prefix="$PREFIX" --libdir="$PREFIX"/lib --disable-hardware-specific-code
  patch_libtool
else
  ./configure --prefix="$PREFIX" --libdir="$PREFIX"/lib --disable-hardware-specific-code --disable-static
fi

make -j${CPU_COUNT}
make check -j${CPU_COUNT}
make install
