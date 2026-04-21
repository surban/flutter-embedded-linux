#!/bin/bash
#
# Build the Flutter embedded-linux engine wrapper (libflutter_elinux_wayland.so)
# for x64 and/or arm64, and install it alongside headers and C++ client wrapper
# sources into the flutter-elinux cache so the runner compiles against the
# matching ABI.
#
# Usage: ./build.sh [x64|arm64|all]   (default: all)

ENGINE_VERSION=cb4b5fff73

set -e
cd -- "$( dirname -- "${BASH_SOURCE[0]}" )"

CACHE_DIR=~/flutter-elinux/flutter/bin/cache/artifacts/engine
COMMON_DIR="$CACHE_DIR/elinux-common"

# -----------------------------------------------------------------------------
# build_arch <arch>
#
# arch: x64 | arm64
# -----------------------------------------------------------------------------
build_arch() {
  local arch="$1"
  local engine_dir="engine/$ENGINE_VERSION/$arch"
  local build_dir="build-$arch"

  # Download prebuilt Flutter engine.
  mkdir -p "$engine_dir"
  if ! [ -f "$engine_dir/libflutter_engine.so" ] ; then
    (cd "$engine_dir" && \
      wget "https://github.com/sony/flutter-embedded-linux/releases/download/$ENGINE_VERSION/elinux-$arch-release.zip" && \
      unzip "elinux-$arch-release.zip" libflutter_engine.so)
  fi

  # Configure toolchain.
  local -a cmake_args=(
    -DBUILD_ELINUX_SO=ON
    -DBACKEND_TYPE=WAYLAND
    -DCMAKE_BUILD_TYPE=Release
    -DFLUTTER_RELEASE=ON
    -DFLUTTER_EMBEDDER_LIB="$PWD/$engine_dir/libflutter_engine.so"
  )
  if [ "$arch" = "arm64" ]; then
    cmake_args+=(-DCMAKE_TOOLCHAIN_FILE=../cross-toolchain-aarch64-raumscan.cmake)
  fi

  # Build.
  mkdir -p "$build_dir"
  (cd "$build_dir" && cmake "${cmake_args[@]}" .. && cmake --build . --parallel)

  # Install the .so into each flavor of the cache.
  for flavor in debug profile release; do
    cp -fv "$build_dir/libflutter_elinux_wayland.so" \
      "$CACHE_DIR/elinux-$arch-$flavor/"
  done
}

# -----------------------------------------------------------------------------
# install_common
#
# Install embedder headers and C++ client wrapper sources (arch-independent)
# into the flutter-elinux cache so the runner compiles against the same ABI
# as the .so files installed above.
# -----------------------------------------------------------------------------
install_common() {
  mkdir -p "$COMMON_DIR/cpp_client_wrapper/include/flutter"

  # Public C headers.
  cp -fv \
    src/flutter/shell/platform/linux_embedded/public/flutter_elinux.h \
    src/flutter/shell/platform/linux_embedded/public/flutter_platform_views.h \
    src/flutter/shell/platform/common/public/flutter_export.h \
    src/flutter/shell/platform/common/public/flutter_messenger.h \
    src/flutter/shell/platform/common/public/flutter_plugin_registrar.h \
    src/flutter/shell/platform/common/public/flutter_texture_registrar.h \
    "$COMMON_DIR/"

  # C++ client wrapper headers (elinux-specific + shared with desktop common).
  cp -fv \
    src/client_wrapper/include/flutter/*.h \
    src/flutter/shell/platform/common/client_wrapper/include/flutter/*.h \
    "$COMMON_DIR/cpp_client_wrapper/include/flutter/"

  # C++ client wrapper sources and private headers (compiled into the runner;
  # must match headers).
  cp -fv \
    src/client_wrapper/*.cc \
    src/flutter/shell/platform/common/client_wrapper/*.cc \
    src/flutter/shell/platform/common/client_wrapper/*.h \
    "$COMMON_DIR/cpp_client_wrapper/"
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------
target="${1:-all}"
case "$target" in
  x64)   build_arch x64 ;;
  arm64) build_arch arm64 ;;
  all)   build_arch x64 ; build_arch arm64 ;;
  *)     echo "Usage: $0 [x64|arm64|all]" >&2 ; exit 1 ;;
esac

install_common
