#!/bin/sh

# Install Depot Tools
cd /usr/src && git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=/usr/src/depot_tools:$PATH
export PATH=/opt/devops/local/depot_tools:$PATH
# Install v8
cd /usr/src && fetch v8
cd /opt/devops/local/v8
cd /v8
git checkout refs/tags/7.1.11
gclient sync
./tools/dev/v8gen.py -vv x64.release -- is_component_build=true
time ninja -C out.gn/x64.release
time ./tools/run-tests.py --gn
mkdir -p /opt/v8/{lib,include}
cd /usr/src/v8
cp -v out.gn/x64.release/lib*.so out.gn/x64.release/*_blob.bin \
   out.gn/x64.release/icudtl.dat /opt/v8/lib/
cp -vR include/* /opt/v8/include/
# Install v8js 
echo "/usr/lib64" | pecl install v8js-1.0.0
echo extension=v8js.so > /etc/php.d/v8js.ini
php -m | grep v8