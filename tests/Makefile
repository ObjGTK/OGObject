include ../extra.mk

PROG_NOINST = tests${PROG_SUFFIX}

SRCS = OGObjectTests.m			\
       OGGObjectTests.m			\
       OGWrapperTests.m

include ../buildsys.mk

run:
	rm -f libogobject.so.0
	rm -f libogobject0.dll
	rm -f libobjfw.0.dylib
	if test -f ../src/libogobject.so; then \
		${LN_S} ../src/libogobject.so libogobject.so.0; \
	fi
	if test -f ../src/libogobject0.dll; then \
		${LN_S} ../src/libogobject0.dll libogobject0.dll; \
	fi
	if test -f ../src/libogobject.dylib; then \
		${LN_S} ../src/libogobject.dylib libogobject.0.dylib; \
	fi
	LD_LIBRARY_PATH=.$${LD_LIBRARY_PATH+:}$$LD_LIBRARY_PATH \
	DYLD_FRAMEWORK_PATH=.:$$DYLD_FRAMEWORK_PATH \
	DYLD_LIBRARY_PATH=.$${DYLD_LIBRARY_PATH+:}$$DYLD_LIBRARY_PATH \
	LIBRARY_PATH=.$${LIBRARY_PATH+:}$$LIBRARY_PATH \
	./${PROG_NOINST} ${TESTCASES}; EXIT=$$?; \
	rm -f libogobject.so.0; \
	rm -f libogobject0.dll \
	rm -f libobjfw.0.dylib \
	exit $$EXIT

CPPFLAGS += -I../src				\
	    -DPROG_SUFFIX=\"${PROG_SUFFIX}\"

LIBS := -lobjfwtest		\
	${TESTS_LIBS}		\
	${LIBS}

LD = ${OBJC}
