###############################################################################
# rule_cpp.mk
# Itarge 2011.08.08
###############################################################################
-include $(PLATFORM_PATH)/build_ignore.mk
include ${RULES_DIR}/ruleBase.mk

LOCAL_PATH      = $(call my-dir)
LOCAL_NAME      = $(notdir ${LOCAL_PATH})

BLANK_VERSION   = $(shell echo $(VERSION) | tr '.' ' ')

DYNAMIC_LINKNAME = lib$(LOCAL_MODULE).so
DYNAMIC_REALNAME = lib$(LOCAL_MODULE).so.$(VERSION)
DYNAMIC_SONAME   = lib$(LOCAL_MODULE).so.$(word 1, $(BLANK_VERSION))

###############################################################################
# build tools set
###############################################################################
# AR      = ${COMPILE_PREFIX}ar
# AS      = ${COMPILE_PREFIX}as
CC      = ${COMPILE_PREFIX}gcc
LD      = ${COMPILE_PREFIX}g++


###############################################################################
# Output dir set
###############################################################################
LIB_SRCS_C :=
LIB_SRCS_C += $(foreach subdir,${LOCAL_SRC_PATH},  $(filter-out $(LIB_IGNORE_FILE),$(wildcard ${subdir}/*.c)))
# LIB_SRCS_C      = $(filter-out $(LIB_IGNORE_FILE),$(wildcard ${LOCAL_SRC_PATH}/*.c))

LIB_SRCS_BASENAME = $(basename $(notdir ${LIB_SRCS_C}))
LIB_OBJS_DIR    = ${BUILD_DIR}/${LOCAL_NAME}/objs
# LIB_OBJS        = $(addprefix ${LIB_OBJS_DIR}/,$(addsuffix .o,${LIB_SRCS_CPP}))
LIB_OBJS        += $(addprefix ${LIB_OBJS_DIR}/,$(addsuffix .o,$(basename ${LIB_SRCS_C})))

LIB_DEPS_DIR    = ${BUILD_DIR}/${LOCAL_NAME}/deps
LIB_DEPS        += $(addprefix ${LIB_DEPS_DIR}/,$(addsuffix .d,$(basename ${LIB_SRCS_C})))


LIBS_DIR        = ${BUILD_DIR}/${LOCAL_NAME}/libs
LIB_BUILD       = ${LIBS_DIR}/${LOCAL_MODULE}


BUILD_DIR_FILES = $(shell ls -A ${BUILD_DIR})

###############################################################################
# build rule 
###############################################################################
.PHONY: all clean lib build_path

ifeq (install, $(wildcard install))
all:	lib exe test
	${AT}${ECHO} build ${LOCAL_NAME} done
	sh -C ${LOCAL_PATH}/${ITG_INSTALL} ${BUILD_DIR} ${LOCAL_NAME}
else
all: 	lib exe test
	${AT}${ECHO} build ${LOCAL_NAME} done
endif

clean:
ifeq (${BUILD_DIR_FILES}, ${LOCAL_NAME})
	${AT}${RM} ${BUILD_DIR}
else
	${AT}${RM} ${BUILD_DIR}/${LOCAL_NAME}
endif
	${AT}${ECHO} clean ${LOCAL_NAME} done

ifneq (${LIB_OBJS},)
lib:	build_path ${LOCAL_MODULE}
else
lib:	build_path
endif

${LOCAL_MODULE}: ${LIB_OBJS}
	${AT}${ECHO} "lib path"
	${AT}${LD} -shared -Wl,-soname,$(DYNAMIC_SONAME) -o $(LIBS_DIR)/$(DYNAMIC_REALNAME) $(LIB_OBJS)
	${AT}${CD} $(LIBS_DIR); ${AT}${LN} $(DYNAMIC_REALNAME) $(DYNAMIC_SONAME)
	${AT}${CD} $(LIBS_DIR); ${AT}${LN} $(DYNAMIC_SONAME)   $(DYNAMIC_LINKNAME)
	${AT}${ECHO} build ${LOCAL_MODULE} done

$(foreach dep,${LIB_SRCS_C},$(eval $(call DEP_BUILD_RULE,${LIB_DEPS_DIR}/$(dir ${dep}),${LOCAL_PATH}/$(dir ${dep}),${LIB_OBJS_DIR}/$(dir ${dep}),$(notdir ${dep}))))
$(foreach obj,${LIB_SRCS_C},$(eval $(call OBJ_BUILD_RULE,${LIB_OBJS_DIR}/$(dir ${obj}),${LOCAL_PATH}/$(dir ${obj}),$(notdir ${obj}))))
-include ${LIB_DEPS}

build_path:
	${AT}${MKDIR} ${LIBS_DIR}
	${AT}${MKDIR} ${LIB_OBJS_DIR}
	${AT}${MKDIR} ${LIB_DEPS_DIR}
	$(foreach obj,${LIB_SRCS_C},$(eval $(call OBJ_BUILD_PATH,${LIB_OBJS_DIR}/$(dir ${obj}))))


