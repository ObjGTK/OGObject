include ../extra.mk

SHARED_LIB = ${OGOBJECT_SHARED_LIB}
STATIC_LIB = ${OGOBJECT_STATIC_LIB}
FRAMEWORK = ${OGOBJECT_FRAMEWORK}
LIB_MAJOR = 0
LIB_MINOR = 1

SRCS = OGErrorException.m \
	OGObjectInitializationFailedException.m \
	OGObjectInitializationRaceConditionException.m \
	OGObjectSignalNotFoundException.m \
	OGObject.m

INCLUDES = ${SRCS:.m=.h}

include ../buildsys.mk

LD = ${OBJC}
