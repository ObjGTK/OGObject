AC_INIT(OGObject, 0.1, objfw@devbeejohn.de)
AC_CONFIG_SRCDIR(src)
AC_CONFIG_AUX_DIR(build-aux)
AC_CONFIG_MACRO_DIR(build-aux/m4)

for i in configure.ac build-aux/m4/*; do
	AS_IF([test $i -nt configure], [
		AC_MSG_ERROR([$i is newer than configure! Run ./autogen.sh!])
	])
done

AC_CHECK_TOOL(OBJFW_CONFIG, objfw-config)
AS_IF([test x"$OBJFW_CONFIG" = x""], [
	AC_MSG_ERROR(You need ObjFW and objfw-config installed!)
])

test x"$OBJC" = x"" && OBJC="$($OBJFW_CONFIG --objc)"

AC_LANG([Objective C])
AC_PROG_OBJC
AC_PROG_OBJCPP
AC_PROG_LN_S
AC_PROG_INSTALL

CPP="$OBJCPP"
CPPFLAGS="$CPPFLAGS $OBJCPPFLAGS $($OBJFW_CONFIG --cppflags)"
OBJCFLAGS="$OBJCFLAGS -Wall $($OBJFW_CONFIG --objcflags)"
LDFLAGS="$LDFLAGS $($OBJFW_CONFIG --ldflags --rpath)"
FRAMEWORK_LIBS="$($OBJFW_CONFIG --framework-libs)"
LIBS="$($OBJFW_CONFIG --libs --rpath)"

AX_CHECK_COMPILER_FLAGS(-Wno-deprecated-declarations,
	[OBJCFLAGS="$OBJCFLAGS -Wno-deprecated-declarations"])

AX_CHECK_COMPILER_FLAGS(-Wno-deprecated,
	[OBJCFLAGS="$OBJCFLAGS -Wno-deprecated"])

AC_ARG_ENABLE(shared,
	AS_HELP_STRING([--disable-shared], [do not build shared library]))
AS_IF([test x"$enable_shared" != x"no"], [
	BUILDSYS_SHARED_LIB
	AC_SUBST(OGOBJECT_SHARED_LIB, "${LIB_PREFIX}ogobject${LIB_SUFFIX}")

	BUILDSYS_FRAMEWORK([
		AC_SUBST(OGOBJECT_FRAMEWORK, "OGObject.framework")
	])
])
AC_ARG_ENABLE(static, AS_HELP_STRING([--enable-static], [build static library]))
AS_IF([test x"$enable_static" = x"yes" -o x"$enable_shared" = x"no"], [
	AC_PATH_TOOL(AR, ar)
	AC_PROG_RANLIB
	AC_SUBST(OGOBJECT_STATIC_LIB, "libogobject.a")
])

AC_ARG_WITH(glib, AS_HELP_STRING([--with-glib=PREFIX],
	[build with glib-2.0 in the specified prefix]))
AS_IF([test x"$with_glib" != x"no" -a x"$with_glib" != x""], [
       CPPFLAGS="$CPPFLAGS -I$with_glib/include"
       LIBS="$LIBS -L$with_glib/lib"
       FRAMEWORK_LIBS="$FRAMEWORK_LIBS -L$with_glib/lib"
])

PKG_CHECK_MODULES([GLIB], [glib-2.0 >= 2.66], [
	CPPFLAGS="$CPPFLAGS $GLIB_CFLAGS"
	LIBS="$LIBS $GLIB_LIBS"
], [
	AC_MSG_ERROR(You need glib-2.0 >= 2.66 installed!)
])

AS_IF([test x"$GOBJC" = x"yes"], [
	OBJCFLAGS="$OBJCFLAGS -Wwrite-strings -Wpointer-arith -Werror"
])

BUILDSYS_INIT

dnl We don't call AC_PROG_CPP, but only AC_PROG_OBJCPP and set CPP to OBJCPP
dnl and add OBJCPPFLAGS to CPPFLAGS, thus we need to AC_SUBST these ourself.
AC_SUBST(CPP)
AC_SUBST(CPPFLAGS)

AC_CONFIG_FILES([buildsys.mk extra.mk OGObject.oc])
AC_OUTPUT
