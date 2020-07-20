#/**
# * @file rule_base.mk
# * @brief rule_base.mk
# * @author  binsonli <binson666@163.com>
# * @version 1.0.0
# * @date 2020-07-20
# */

##############################################################################
# PATH 
##############################################################################
LIBS_BUILD_DIR  = ${BUILD_DIR}/.build/${THIS_OBJ_NAME}/libs

###############################################################################
# build tools set
###############################################################################
MAKE    = make
ECHO    = @echo
RM      = @rm -rf
MKDIR   = @mkdir -p
LN		= ln -sf
CD		= cd

ITG_INSTALL = install

AR      = ${COMPILE_PREFIX}ar
AS      = ${COMPILE_PREFIX}as
CC      = ${COMPILE_PREFIX}g++
LD      = ${COMPILE_PREFIX}g++

OBJDUMP = ${COMPILE_PREFIX}objdump

ifneq (debug, $(RELEASE_TYPE))
STRIP   = ${COMPILE_PREFIX}strip
else
STRIP   = echo 
endif

###############################################################################
# build marco
###############################################################################
define OBJ_C_BUILD_RULE
# Rule to build object file
# param 1: object dir
# param 2: source dir
# param 3: source and object name
${1}/${3}.o: ${2}/${3}.c
	${AT}${ECHO} Compiling [ ${3} ]
	${AT}${CC} ${CCFLAGS} -c $$< -o $$@
endef

define DEP_C_BUILD_RULE
# Rule to build denpend file
# param 1: depend dir
# param 2: source dir
# param 3: object dir
# param 4: source object and depend name
${1}/${4}.d: ${2}/${4}.c
	${AT}${ECHO} Dependence [ ${4} ]
	${AT}${MKDIR} ${1}
	${AT}${ECHO} -n ${3}/ > $$@
	${AT}${CC} ${CCFLAGS} -MM $$< >> $$@
endef

define TEST_C_BUILD_RULE
# Rule to build object file
# param 1: target dir
# param 2: object dir
# param 3: source dir
# param 4: source and object name
${2}/${4}.o: ${3}/${4}.c
	${AT}${ECHO} Compiling [ ${4} ]
	${AT}${CC} ${CCFLAGS} -c $$< -o $$@
	${AT}${LD} -o ${1}/${4} ${2}/${4}.o ${LDFLAGS}
endef

define OBJ_CPP_BUILD_RULE
# Rule to build object file
# param 1: object dir
# param 2: source dir
# param 3: source and object name
${1}/${3}.o: ${2}/${3}.cpp
	${AT}${ECHO} Compiling [ ${3} ]
	${AT}${CC} ${CCFLAGS} -c $$< -o $$@
endef

define DEP_CPP_BUILD_RULE
# Rule to build denpend file
# param 1: depend dir
# param 2: source dir
# param 3: object dir
# param 4: source object and depend name
${1}/${4}.d: ${2}/${4}.cpp
	${AT}${ECHO} Dependence [ ${4} ]
	${AT}${MKDIR} ${1}
	${AT}${ECHO} -n ${3}/ > $$@
	${AT}${CC} ${CCFLAGS} -MM $$< >> $$@
endef

define TEST_CPP_BUILD_RULE
# Rule to build object file
# param 1: target dir
# param 2: object dir
# param 3: source dir
# param 4: source and object name
${2}/${4}.o: ${3}/${4}.cpp
	${AT}${ECHO} Compiling [ ${4} ]
	${AT}${CC} ${CCFLAGS} -c $$< -o $$@
	${AT}${LD} -o ${1}/${4} ${2}/${4}.o ${LDFLAGS}
endef

