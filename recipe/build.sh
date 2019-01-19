#!/usr/bin/env bash

if [[ $(uname) == Darwin || $(uname) == Linux ]]; then 
  autoreconf -ivf
else
  chmod +x configure
fi

export CFLAGS="-O2 -g $CFLAGS"

case `uname` in
    Darwin|Linux)
        ./configure --prefix="$PREFIX" --libdir="$PREFIX"/lib --disable-hardware-specific-code
        ;;
    MINGW*)
        export PATH="$PREFIX/Library/bin:$BUILD_PREFIX/Library/bin:$PATH"
        export CC=clang-cl
        export RANLIB=llvm-ranlib
        export AS=llvm-as
        export AR=llvm-ar
        export LD=lld-link
        export CFLAGS="-MD -I$PREFIX/Library/include -O2"
        export LDFLAGS="$LDFLAGS -L$PREFIX/Library/lib"
        clang --version
        llvm-as --version
        llvm-ar --version
        ./configure --prefix="$PREFIX/Library" --libdir="$PREFIX/Library/lib" --disable-hardware-specific-code
        ;;
esac


make -j${CPU_COUNT}
make check -j${CPU_COUNT}
make install

if [[ `uname` == MINGW* ]]; then
    mv "$LIBRARY_LIB/gf2x.lib" "$LIBRARY_LIB/gf2x_static.lib"
    mv "$LIBRARY_LIB/gf2x.dll.lib" "$LIBRARY_LIB/gf2x.lib"
fi
