include ../extra.mk

PROG_NOINST = tests${PROG_SUFFIX}

SRCS = OGObjectTests.m			\
       OGGObjectTests.m			\
       OGWrapperTests.m

include ../buildsys.mk

run:
	./${PROG_NOINST} ${TESTCASES}; EXIT=$$?; \
	exit $$EXIT

CPPFLAGS += -I../src				\
	    -DPROG_SUFFIX=\"${PROG_SUFFIX}\"

LIBS := -lobjfwtest		\
	${TESTS_LIBS}		\
	${LIBS}

LD = ${OBJC}
