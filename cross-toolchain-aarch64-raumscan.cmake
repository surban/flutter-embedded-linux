cmake_minimum_required(VERSION 3.10)

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# Specify the sysroot.
set(target_sysroot /home/rs/raumscan-os/build-raumscan1/host/aarch64-buildroot-linux-gnu/sysroot)
set(CMAKE_SYSROOT ${target_sysroot})

# Use Buildroot's GCC cross-compiler.
set(toolchain_prefix /home/rs/raumscan-os/build-raumscan1/host/bin/aarch64-buildroot-linux-gnu-)
set(CMAKE_C_COMPILER ${toolchain_prefix}gcc)
set(CMAKE_CXX_COMPILER ${toolchain_prefix}g++)

# Point pkg-config at the sysroot so host /usr/include is never injected.
set(ENV{PKG_CONFIG_SYSROOT_DIR} ${target_sysroot})
set(ENV{PKG_CONFIG_PATH} "${target_sysroot}/usr/lib/pkgconfig:${target_sysroot}/usr/share/pkgconfig")

set(CMAKE_FIND_ROOT_PATH ${target_sysroot})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
