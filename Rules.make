PLATFORM_TOP_PATH = $(shell pwd)

# common variables
PLATFORM_PATH = ${PLATFORM_TOP_PATH}/${TARGET_CPU_DIR}
ITARGE_BUILD_OBJS_PATH = /home/${USER}/build/platform_v2/${TARGET_CPU_DIR}
PLATFORM_RELEASE_DIRECTORY = ${PLATFORM_PATH}/platform_release
PLATFORM_SYSROOT_DIRECTORY = ${PLATFORM_RELEASE_DIRECTORY}/rootfs
# get svn or git-svn version
PLATFORM_RELEASE_SVN_VERSION=$(shell LC_ALL=C svn info | grep "Last Changed Rev" | sed -e "s/Last Changed Rev: //g")
ifeq ( ,${PLATFORM_RELEASE_SVN_VERSION})
    PLATFORM_RELEASE_SVN_VERSION=$(shell LC_ALL=C git svn info | grep "Last Changed Rev" | sed -e "s/Last Changed Rev: //g")
endif

# private variables for nxp ASC8852AET platform
ifeq (${TARGET_CPU}, ASC8852A)
    TARGET_CPU_DIR = ASC8852A
    TOOLCHAIN_PATH = ${PLATFORM_RELEASE_DIRECTORY}/toolchain/arm-eabi-uclibc/usr
    COMPILE_PREFIX = arm-linux-
    PORTING_COMPILE_PREFIX = arm-linux
    PORTING_INSTALL_DIR=${TOOLCHAIN_PATH}/arm-linux
    ARCH = arm
    ITE_MACHINE_ID = 1200
endif

# private variables for DM8168 platform
ifeq (${TARGET_CPU}, DM8168)
    TARGET_CPU_DIR = DM8168
    TOOLCHAIN_PATH = ${PLATFORM_RELEASE_DIRECTORY}/toolchain/arm-arago-linux-gnueabi
    COMPILE_PREFIX = arm-arago-linux-gnueabi-
    PORTING_COMPILE_PREFIX = arm-arago-linux-gnueabi
    PORTING_INSTALL_DIR=${TOOLCHAIN_PATH}/arm-arago-linux-gnueabi
    ARCH = arm
endif

# private variables for V5 platform
ifeq (${TARGET_CPU}, V5)
    TARGET_CPU_DIR = V5
    TOOLCHAIN_PATH = ${PLATFORM_RELEASE_DIRECTORY}/toolchain/arm-linux-gnueabi
    COMPILE_PREFIX = arm-linux-gnueabi-
    PORTING_COMPILE_PREFIX = arm-linux-gnueabi
    PORTING_INSTALL_DIR=${TOOLCHAIN_PATH}/arm-linux-gnueabi
    ARCH = arm
endif

# private variables for TX1 platform
ifeq (${TARGET_CPU}, TX1)
    TARGET_CPU_DIR = TX1
    TOOLCHAIN_64BIT_PATH = ${PLATFORM_RELEASE_DIRECTORY}/toolchain/gcc-linaro-4.9.4-2017.01-x86_64_aarch64-linux-gnu
    TOOLCHAIN_32BIT_PATH = ${PLATFORM_RELEASE_DIRECTORY}/toolchain/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf
    COMPILE_64BIT_PREFIX = ${TOOLCHAIN_64BIT_PATH}/bin/aarch64-linux-gnu-
    TOOLCHAIN_PATH = ${TOOLCHAIN_64BIT_PATH}
    COMPILE_PREFIX = aarch64-linux-gnu-
    PORTING_COMPILE_PREFIX = aarch64-linux-gnu
    PORTING_INSTALL_DIR=${TOOLCHAIN_PATH}/aarch64-linux-gnu
    CROSS32CC = ${TOOLCHAIN_32BIT_PATH}/bin/arm-linux-gnueabihf-gcc
    ARCH = arm64
    export CROSS32CC
    ITE_MACHINE_ID = 1000
endif

# private variables for TX2 platform
ifeq (${TARGET_CPU}, TX2)
    TARGET_CPU_DIR = TX2
    TOOLCHAIN_64BIT_PATH = ${PLATFORM_RELEASE_DIRECTORY}/toolchain/gcc-4.8.5-aarch64-unknown-linux-gnu
    COMPILE_64BIT_PREFIX = ${TOOLCHAIN_64BIT_PATH}/bin/aarch64-linux-gnu-
    TOOLCHAIN_PATH = ${TOOLCHAIN_64BIT_PATH}
    COMPILE_PREFIX = aarch64-linux-gnu-
    PORTING_COMPILE_PREFIX = aarch64-linux-gnu
    PORTING_INSTALL_DIR=${TOOLCHAIN_PATH}/aarch64-unknown-linux-gnu
    ARCH = arm64
endif

# private variables for HI3519AV101 platform
ifeq (${TARGET_CPU}, HI3519AV101)
    TARGET_CPU_DIR = HI3519AV101
    TOOLCHAIN_PATH = ${PLATFORM_RELEASE_DIRECTORY}/toolchain/arm-hisiv500-linux/target
    COMPILE_PREFIX = arm-hisiv500-linux-
    PORTING_COMPILE_PREFIX = arm-hisiv500-linux
    PORTING_INSTALL_DIR=${PLATFORM_RELEASE_DIRECTORY}/toolchain/arm-hisiv500-linux/arm-hisiv500-linux-uclibcgnueabi
    ITE_OPENCV_ENABLE = 1
    ARCH = arm
    ITE_MACHINE_ID = 1100
endif

# private variables for HI3559AV100 platform
ifeq (${TARGET_CPU}, HI3559AV100)
    TARGET_CPU_DIR = HI3559AV100
    TOOLCHAIN_PATH = ${PLATFORM_RELEASE_DIRECTORY}/toolchain/aarch64-himix100-linux
    COMPILE_PREFIX = aarch64-himix100-linux-
    PORTING_COMPILE_PREFIX = aarch64-himix100-linux
    PORTING_INSTALL_DIR=${TOOLCHAIN_PATH}/aarch64-linux-gnu
    ITE_OPENCV_ENABLE = 1
    ARCH = arm64
    ITE_MACHINE_ID = 1301
endif

# private variables for HI3519AV100 platform
ifeq (${TARGET_CPU}, HI3519AV100)
    TARGET_CPU_DIR = HI3519AV100
    TOOLCHAIN_PATH = ${PLATFORM_RELEASE_DIRECTORY}/toolchain/arm-himix200-linux
    COMPILE_PREFIX = arm-himix200-linux-
    PORTING_COMPILE_PREFIX = arm-himix200-linux
    PORTING_INSTALL_DIR=${TOOLCHAIN_PATH}/arm-linux-gnueabi
    ARCH = arm
endif

# private variables for HOST platform
ifeq (${TARGET_CPU}, HOST)
    TARGET_CPU_DIR = HOST
    TOOLCHAIN_PATH = ${PLATFORM_RELEASE_DIRECTORY}/toolchain
    COMPILE_PREFIX =
    PORTING_COMPILE_PREFIX =
    PORTING_INSTALL_DIR=${PLATFORM_RELEASE_DIRECTORY}/toolchain
    ARCH =
    ITE_MACHINE_ID = 1400
endif

export GCC_COLORS='error=01;31:warning=01;33:note=01;36:caret=01;32:locus=01:quote=01'
export ARCH TARGET_CPU TOOLCHAIN_64BIT_PATH COMPILE_64BIT_PREFIX TOOLCHAIN_PATH COMPILE_PREFIX
export PORTING_COMPILE_PREFIX PORTING_INSTALL_DIR
export TARGET_CPU_DIR PLATFORM_TOP_PATH PLATFORM_PATH PLATFORM_RELEASE_DIRECTORY PLATFORM_SYSROOT_DIRECTORY ITARGE_BUILD_OBJS_PATH
export PATH := ${TOOLCHAIN_PATH}/bin:${PATH}
export PKG_CONFIG_LIBDIR := ${PORTING_INSTALL_DIR}/lib
export PKG_CONFIG_PATH := ${PORTING_INSTALL_DIR}/lib/pkgconfig:${PKG_CONFIG_PATH}
export PLATFORM_RELEASE_SVN_VERSION
export ITE_OPENCV_ENABLE ITE_MACHINE_ID
