#!/bin/bash

ENGINE_VERSION=cb4b5fff73

set -e

# Download Flutter engine
mkdir -p engine/$ENGINE_VERSION/x64
pushd engine/$ENGINE_VERSION/x64
if ! [ -f libflutter_engine.so ] ; then
    wget https://github.com/sony/flutter-embedded-linux/releases/download/$ENGINE_VERSION/elinux-x64-release.zip
    unzip elinux-x64-release.zip libflutter_engine.so
fi
popd

# Build Flutter embedder
mkdir -p build
cd build
cp -fv ../engine/$ENGINE_VERSION/x64/libflutter_engine.so .
cmake -DBUILD_ELINUX_SO=ON -DBACKEND_TYPE=WAYLAND -DCMAKE_BUILD_TYPE=Release -DFLUTTER_RELEASE=ON ..
cmake --build . --parallel

# Install Flutter embedder
cp -fv libflutter_elinux_wayland.so ~/flutter-elinux/flutter/bin/cache/artifacts/engine/elinux-x64-debug/
cp -fv libflutter_elinux_wayland.so ~/flutter-elinux/flutter/bin/cache/artifacts/engine/elinux-x64-profile/
cp -fv libflutter_elinux_wayland.so ~/flutter-elinux/flutter/bin/cache/artifacts/engine/elinux-x64-release/

cp -fv libflutter_elinux_wayland.so /workspaces/raumscan/apps/raumscan/flutter-elinux-engine-lib/x64/
