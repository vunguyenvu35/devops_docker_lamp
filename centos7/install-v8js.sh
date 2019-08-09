#!/bin/sh

cd /tmp

# Install depot_tools first (needed for source checkout)
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=`pwd`/depot_tools:"$PATH"

# Download v8
fetch v8
cd v8

# (optional) If you'd like to build a certain version:
git checkout 6.4.388.18
gclient sync

# use libicu of operating system
export GYP_DEFINES="use_system_icu=1"

# Build (with internal snapshots)
export GYPFLAGS="-Dv8_use_external_startup_data=0"
make native library=shared snapshot=on -j8

# Install to /usr
sudo mkdir -p /usr/lib /usr/include
sudo cp out/native/lib.target/lib*.so /usr/lib/
sudo cp -R include/* /usr/include
echo -e "create /usr/lib/libv8_libplatform.a\naddlib out/native/obj.target/tools/gyp/libv8_libplatform.a\nsave\nend" | sudo ar -M

cd /tmp
git clone https://github.com/phpv8/v8js.git
cd v8js
phpize
./configure
make
make test
sudo make install