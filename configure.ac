AC_INIT(OGObject, 0.1, objfw@devbeejohn.de)
AC_CONFIG_SRCDIR(src)
AC_CONFIG_AUX_DIR(build-aux)
AC_CONFIG_MACRO_DIR(build-aux/m4)

for i in configure.ac build-aux/m4/*; do
	AS_IF([test $i -nt configure], [
		AC_MSG_ERROR([$i is newer than configure! Run ./autogen.sh!])
	])
done

BUILDSYS_INIT

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
CPPFLAGS="$CPPFLAGS $OBJCPPFLAGS"
CPPFLAGS="$CPPFLAGS $($OBJFW_CONFIG $OBJFW_CONFIG_FLAGS --cppflags)"
OBJCFLAGS="$OBJCFLAGS $($OBJFW_CONFIG $OBJFW_CONFIG_FLAGS --objcflags)"
LDFLAGS="$LDFLAGS $($OBJFW_CONFIG $OBJFW_CONFIG_FLAGS --ldflags)"
FRAMEWORK_LIBS="$($OBJFW_CONFIG $OBJFW_CONFIG_FLAGS --framework-libs) $LIBS"
LIBS="$($OBJFW_CONFIG $OBJFW_CONFIG_FLAGS --libs --rpath) $LIBS"

AX_CHECK_COMPILER_FLAGS(-Wno-deprecated-declarations,
	[OBJCFLAGS="$OBJCFLAGS -Wno-deprecated-declarations"])

AX_CHECK_COMPILER_FLAGS(-Wno-deprecated,
	[OBJCFLAGS="$OBJCFLAGS -Wno-deprecated"])

AC_CHECK_TOOL(AR, ar)
AC_PROG_RANLIB

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
	AC_SUBST(OGOBJECT_STATIC_LIB, "libogobject.a")
])

AC_ARG_WITH(gobject, AS_HELP_STRING([--with-gobject=PREFIX],
	[build with gobject-2.0 in the specified prefix]))
AS_IF([test x"$with_gobject" != x"no" -a x"$with_gobject" != x""], [
 	OGOBJECT_CPPFLAGS="$OGOBJECT_CPPFLAGS -I$with_gobject/include"
	OGOBJECT_LIBS="$OGOBJECT_LIBS -L$with_gobject/lib"
    CPPFLAGS=" -I$with_gobject/include $CPPFLAGS"
    LIBS="-L$with_gobject/lib $LIBS"
    FRAMEWORK_LIBS="-L$with_gobject/lib $FRAMEWORK_LIBS"
])

PKG_CHECK_MODULES([gobject2], [gobject-2.0 >= 2.78.0], [
	OGOBJECT_CPPFLAGS="$OGOBJECT_CPPFLAGS $gobject2_CFLAGS"
	OGOBJECT_LIBS="$OGOBJECT_LIBS $gobject2_LIBS"
	CPPFLAGS="$CPPFLAGS $gobject2_CFLAGS"
	LIBS="$LIBS $gobject2_LIBS"
	FRAMEWORK_LIBS="$FRAMEWORK_LIBS $gobject2_LIBS"
], [
	AC_MSG_ERROR(You need gobject-2.0 >= 2.78.0 installed!)
])

AS_IF([test x"$GOBJC" = x"yes"], [
	OBJCFLAGS="$OBJCFLAGS -Wwrite-strings -Wpointer-arith -Werror"
])

dnl We don't call AC_PROG_CPP, but only AC_PROG_OBJCPP and set CPP to OBJCPP
dnl and add OBJCPPFLAGS to CPPFLAGS, thus we need to AC_SUBST these ourself.
AC_SUBST(CPP)
AC_SUBST(CPPFLAGS)

AC_SUBST(OGOBJECT_CPPFLAGS)
AC_SUBST(OGOBJECT_LIBS)

AC_CONFIG_FILES([buildsys.mk extra.mk OGObject.oc])
AC_OUTPUT
