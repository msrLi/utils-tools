###############################################################################
# rule.mk
# Binsonli 20200721
# build shared library
###############################################################################
include ${RULES_DIR}/rule_base.mk

LOCAL_PATH := $(call my-dir)
LOCAL_NAME := $(notdir ${LOCAL_PATH})

DYNAMIC_LINKNAME = lib$(LOCAL_MODULE).so
DYNAMIC_REALNAME = lib$(LOCAL_MODULE).so.$(VERSION)
DYNAMIC_SONAME   = lib$(LOCAL_MODULE).so.$(word 1, $(BLANK_VERSION))

LIBS_DIR        = ${BUILD_DIR}/${LOCAL_NAME}/libs
LIB_SRCS 		:=  ${LOVALLOCAL_SRC_FILES_PATH}
LIB_SRCS		+= 	$(foreach VAR, ${LOCAL_SRC_DIRS}, $(wildcard ${VAR}/*.c))
LIB_SRCS        += 	$(foreach VAR, ${LOCAL_SRC_DIRS}, $(wildcard ${VAR}/*.cpp))

# LIB_SRCS        = $(basename $(notdir $(filter-out $(LIB_IGNORE_FILE),$(wildcard ${LIB_SRCS_DIR}/*.c))))  //去掉后缀
LIB_OBJS_DIR    = ${BUILD_DIR}/${LOCAL_NAME}/objs
LIB_OBJS        = $(addprefix ${LIB_OBJS_DIR}/,$(addsuffix .o,$(basename ${LIB_SRCS})))


LIB_DEPS_DIR    = ${BUILD_DIR}/${LOCAL_NAME}/deps
LIB_DEPS_FILE   = $(addprefix ${LIB_DEPS_DIR}/,$(addsuffix .d,$(basename ${LIB_SRCS})))

###############################################################################
# build flags set
###############################################################################
ASFLAGA += ${THIS_ASFLAGS} ${PLAT_ASFLAGS}
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
LDFLAGS	:= -L${LIBS_DIR} -l${THIS_NAME} ${THIS_LDFLAGS} ${PLAT_LDFLAGS}
else
LDFLAGS	:= ${THIS_LDFLAGS} ${PLAT_LDFLAGS}
endif

# $(foreach dep,${LIB_SRCS},$(eval $(call PRINT_ITEM,${dep})))

###############################################################################
# build rule 
###############################################################################
.PHONY: all libs clean build_path 

all:	build_path libs
	echo ${LIB_DEPS_FILE}


# @ echo ${LIB_SRCS}
# @ echo ${LIB_OBJS}
# @ echo $(LIB_DEPS_FILE)

ifneq (${LIB_OBJS},)
libs:	build_path ${LOCAL_MODULE}
	echo Binson 
else
libs:	build_path
endif

${LOCAL_MODULE}: ${LIB_OBJS}
	@echo test
	${AT}${LD} -shared -Wl,-soname,$(DYNAMIC_SONAME) -o $(LIBS_DIR)/$(DYNAMIC_REALNAME) $(LIB_OBJS)
	${AT}${CD} $(LIBS_DIR); ${AT}${LN} $(DYNAMIC_REALNAME) $(DYNAMIC_SONAME)
	${AT}${CD} $(LIBS_DIR); ${AT}${LN} $(DYNAMIC_SONAME)   $(DYNAMIC_LINKNAME)
	${AT}${ECHO} build ${LOCAL_MODULE} done



# build_libs
build_libs: $(LOCAL_MODULE)

# $(foreach dep,${LIB_SRCS}, $(shell "echo binson ${dep}))
$(foreach dep,${LIB_SRCS},$(eval $(call DEP_BUILD_RULE,${LIB_DEPS_DIR},${LOCAL_PATH},${LIB_OBJS_DIR},${dep})))
# $(foreach dep,${LIB_SRCS},$(eval $(call DEP_BUILD_RULE,${LIB_DEPS_DIR},${LOCAL_PATH},${LIB_OBJS_DIR},${dep}, $(notdir ${dep}))))
$(foreach obj,${LIB_SRCS},$(eval $(call OBJ_BUILD_RULE,${LIB_OBJS_DIR},${LIB_SRCS_DIR},${obj})))
-include ${LIB_DEPS_FILE}

build_path:
	$(foreach obj,${LIB_SRCS},$(eval $(call BUILD_PATH,${LIB_OBJS_DIR},${obj})))
	$(foreach dep,${LIB_SRCS},$(eval $(call BUILD_PATH,${LIB_DEPS_DIR},${dep})))