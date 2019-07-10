PLATFORM_TOP_PATH = $(shell pwd)

# common variables
PLATFORM_PATH = ${PLATFORM_TOP_PATH}/target
PLATFORM_RULE = ${PLATFORM_TOP_PATH}/makerules

export GCC_COLORS='error=01;31:warning=01;33:note=01;36:caret=01;32:locus=01:quote=01'

export PLATFORM_TOP_PATH PLATFORM_PATH PLATFORM_RULE
