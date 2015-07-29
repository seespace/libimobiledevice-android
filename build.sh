#/bin/bash
set -e

ROOT_DIR=$(pwd)
export ANDROID_NDK_ROOT=/Users/Yoshi/Develop/opt/android-ndk
export TOOLCHAIN=arm-linux-androideabi
export ANDROID_API=android-19
export ANDROID_ARCH=arm

OUT_DIR=$ROOT_DIR/out
mkdir -p $OUT_DIR
TOOLCHAIN_DIR=$OUT_DIR/toolchain
mkdir -p $TOOLCHAIN_DIR
INSTALL_DIR=$OUT_DIR/fsroot
mkdir -p $INSTALL_DIR

$ANDROID_NDK_ROOT/build/tools/make-standalone-toolchain.sh --platform=$ANDROID_API --stl=gnustl --toolchain=$TOOLCHAIN-4.9 --arch=$ANDROID_ARCH --install-dir=$TOOLCHAIN_DIR
ANDROID_SYSROOT=$TOOLCHAIN_DIR/sysroot
export PATH=$PATH:$TOOLCHAIN_DIR/bin
export CFLAGS="--sysroot=$ANDROID_SYSROOT -L$INSTALL_DIR/lib -pthread -I$ROOT_DIR/glob -I$TOOLCHAIN_DIR/include/c++/4.9"
export CPPFLAGS=$CFLAGS
export CXXFLAGS=$CFLAGS
export ac_cv_func_malloc_0_nonnull=yes
export ac_cv_func_realloc_0_nonnull=yes

export libxml2_LIBS="-lxml2"
export libxml2_CFLAGS="-L$INSTALL_DIR/lib -I$INSTALL_DIR/include/libxml2"
export libusbmuxd_LIBS="-lusbmuxd"
export libusbmuxd_CFLAGS="-L$INSTALL_DIR/lib -I$INSTALL_DIR/include"
export openssl_LIBS="-lssl -lcrypto"
export openssl_CFLAGS="-L$INSTALL_DIR/lib -I$INSTALL_DIR/include"
export libplist_LIBS="-lplist"
export libplist_CFLAGS="-L$INSTALL_DIR/lib -I$INSTALL_DIR/include"
export libplistmm_LIBS="-lplist++"
export libplistmm_CFLAGS="-L$INSTALL_DIR/lib -I$INSTALL_DIR/include"
export libimobiledevice_LIBS="-limobiledevice"
export libimobiledevice_CFLAGS="-L$INSTALL_DIR/lib -I$INSTALL_DIR/include"

# build openssl
. ./setenv-android.sh
cd $ROOT_DIR/openssl
./config shared no-ssl2 no-ssl3 no-comp no-hw no-engine --openssldir=$INSTALL_DIR
make depend
make all
make install_sw CC=$ANDROID_TOOLCHAIN/arm-linux-androideabi-gcc RANLIB=$ANDROID_TOOLCHAIN/arm-linux-androideabi-ranlib

# build glob
cd $ROOT_DIR/glob
$TOOLCHAIN-gcc -c -I$ANDROID_SYSROOT/usr/include -I. glob.c
chmod +x glob.o

# build libxml2
cd $ROOT_DIR/libxml2
LIBS=$ROOT_DIR/glob/glob.o ./autogen.sh --host=$TOOLCHAIN --with-sysroot=$ANDROID_SYSROOT --prefix=$INSTALL_DIR --without-python
make
make install

# build libusb
cd $ROOT_DIR/libusb
./autogen.sh --host=$TOOLCHAIN --with-sysroot=$ANDROID_SYSROOT --prefix=$INSTALL_DIR --without-python --enable-udev=no
make
make install

# build libplist
cd $ROOT_DIR/libplist
./autogen.sh --host=$TOOLCHAIN --with-sysroot=$ANDROID_SYSROOT --prefix=$INSTALL_DIR --without-cython 
make
make install

# build libusbmuxd
rm -f $INSTALL_DIR/lib/libplist.la
cd $ROOT_DIR/libusbmuxd
./autogen.sh --host=$TOOLCHAIN --with-sysroot=$ANDROID_SYSROOT --prefix=$INSTALL_DIR
make
make install

# build libimobiledevice
cd $ROOT_DIR/libimobiledevice
./autogen.sh --host=$TOOLCHAIN --with-sysroot=$ANDROID_SYSROOT --prefix=$INSTALL_DIR --without-cython
make
make install

# build usbmuxd
rm -f $INSTALL_DIR/lib/libimobiledevice.la
cd $ROOT_DIR/usbmuxd
./autogen.sh --host=$TOOLCHAIN --with-sysroot=$ANDROID_SYSROOT --prefix=$INSTALL_DIR --without-cython
make
make install