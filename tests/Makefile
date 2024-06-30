include ../extra.mk

PROG_NOINST = tests${PROG_SUFFIX}

SRCS = OGObjectTests.m			\
       OGGObjectTests.m			\
       OGWrapperTests.m

include ../buildsys.mk

run:
	rm -f libogobject.so.0
	if test -f ../src/libogobject.so; then \
		${LN_S} ../src/libogobject.so libogobject.so.0; \
	fi
	LD_LIBRARY_PATH=.$${LD_LIBRARY_PATH+:}$$LD_LIBRARY_PATH \
	DYLD_FRAMEWORK_PATH=.:$$DYLD_FRAMEWORK_PATH \
	DYLD_LIBRARY_PATH=.$${DYLD_LIBRARY_PATH+:}$$DYLD_LIBRARY_PATH \
	LIBRARY_PATH=.$${LIBRARY_PATH+:}$$LIBRARY_PATH \
	./${PROG_NOINST} ${TESTCASES}; EXIT=$$?; \
	rm -f libogobject.so.0; \
	exit $$EXIT

CPPFLAGS += -I../src				\
	    -DPROG_SUFFIX=\"${PROG_SUFFIX}\"

LIBS := -lobjfwtest		\
	${TESTS_LIBS}		\
	${LIBS}

LD = ${OBJC}
