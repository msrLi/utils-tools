###############################################################################
# ruleBase.mk
# Binson 2020.07.21
###############################################################################

###############################################################################
# build flags set
###############################################################################
ASFLAGA +=  ${THIS_ASFLAGS} ${PLAT_ASFLAGS}
ifeq (on, $(DYNAMIC_SW))
CCFLAGS += -fPIC ${THIS_CCFLAGS} ${PLAT_CCFLAGS} -DITARGE_LIB_VERSION=\"$(VERSION)\"
else
CCFLAGS += ${THIS_CCFLAGS} ${PLAT_CCFLAGS} -DITARGE_LIB_VERSION=\"$(VERSION)\"
endif

############判断GCC版本是否大于4.9.0##############################
GCC_VER_GT490 := $(shell echo `${CC} -dumpversion | cut -f1-2 -d.` \>= 4.9 | sed -e 's/\./*100+/g' | bc )
ifeq ($(GCC_VER_GT490), 1)
CCFLAGS += -fdiagnostics-color=auto
endif

ifneq (${LIB_OBJS},)
LDFLAGS	:= -L${LIBS_DIR} -l${LOCAL_NAME} ${THIS_LDFLAGS} ${PLAT_LDFLAGS}
else
LDFLAGS	:= ${THIS_LDFLAGS} ${PLAT_LDFLAGS}
endif


###############################################################################
# build marco
###############################################################################
define my-dir
	$(shell pwd)
endef


define OBJ_BUILD_PATH
	$(shell mkdir -p ${1})
endef

define OBJ_BUILD_RULE
# Rule to build object file
# param 1: object dir
# param 2: source dir
# param 3: source and object name
${1}$(basename ${3}).o: ${2}${3}
	${AT}${ECHO} "Compiling [ ${3} $(basename ${3})]"
	${AT}${CC} ${CCFLAGS} -c $$< -o $$@
endef

define DEP_BUILD_RULE
# Rule to build denpend file
# param 1: depend dir
# param 2: source dir
# param 3: object dir
# param 4: source object and depend name
${1}$(basename ${4}).d: ${2}${4}
	${AT}${ECHO} Dependence [ ${4} $(basename ${4}) ]
	${AT}${MKDIR} -p ${1}
	${AT}${ECHO} -n ${3} > $$@
	${AT}${CC} ${CCFLAGS} -MM $$< >> $$@
endef

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
