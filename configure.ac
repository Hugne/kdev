#                                               -*- Autoconf -*-
AC_PREREQ([2.64])

AC_INIT([kdev],
        [m4_esyscmd_s([./get-version])],
        [erik.hugne@gmail.com])
AC_CONFIG_SRCDIR([src/])
AC_CONFIG_HEADER([config.h])
AC_CONFIG_FILES([Makefile skel/Makefile src/Makefile src/dropbear/Makefile src/iproute2/Makefile src/busybox/Makefile src/linux/Makefile src/ethtool/Makefile src/bash/Makefile])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([foreign -Wall -Werror tar-ustar])
AM_MAINTAINER_MODE
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES(yes)])
m4_pattern_allow([AM_PROG_AR])
m4_include([m4/ax_prog_perl_modules.m4])
m4_include([m4/ax_prog_tcl.m4])
m4_include([m4/ax_prog_tcl_modules.m4])
AM_PROG_AR

# Configure libtool
LT_INIT

#######################
### Checks

# Checks for programs.
AC_PROG_CC
AC_PROG_CC_C99
AC_PROG_CXX
AM_PROG_CC_C_O
AC_PROG_LIBTOOL
AC_PROG_LN_S
AC_PROG_EGREP


AC_PREFIX_DEFAULT(/tmp)
####
#3pp modules, not automake
AC_CONFIG_SUBDIRS([src/linux src/dropbear src/busybox src/iproute2/iproute2 src/ethtool src/bash/bash])

####

# Check some compiler flags
AX_CFLAGS_GCC_OPTION([-fdiagnostics-show-option],[MORE_CFLAGS])
AX_CFLAGS_GCC_OPTION([-pipe],[MORE_CFLAGS])
AX_CFLAGS_GCC_OPTION([-Wall],[MORE_CFLAGS])
AX_CFLAGS_GCC_OPTION([-W],[MORE_CFLAGS])
AX_CFLAGS_GCC_OPTION([-Wextra],[MORE_CFLAGS])
AX_CFLAGS_GCC_OPTION([-Wformat],[MORE_CFLAGS])
AX_CFLAGS_GCC_OPTION([-Wformat-security],[MORE_CFLAGS])
AX_CFLAGS_GCC_OPTION([-Wfatal-errors],[MORE_CFLAGS])
AX_CFLAGS_GCC_OPTION([-Wcast-align],[MORE_CFLAGS])
AX_CFLAGS_GCC_OPTION([-Winline],[MORE_CFLAGS])
AX_CFLAGS_GCC_OPTION([-fstack-protector],[MORE_CFLAGS])
AX_CFLAGS_GCC_OPTION([-D_FORTIFY_SOURCE=2],[MORE_CPPFLAGS])
AX_CFLAGS_GCC_OPTION([-Wno-unused-parameter],[MORE_CFLAGS])
AX_CFLAGS_GCC_OPTION([-Wno-missing-field-initializers],[MORE_CFLAGS])
AX_LDFLAGS_OPTION([-Wl,-z,relro],[MORE_LDFLAGS])
AX_LDFLAGS_OPTION([-Wl,-z,now],[MORE_LDFLAGS])

dnl Enable _GNU_SOURCE and the like
AX_CFLAGS_GCC_OPTION([-D_GNU_SOURCE],[MORE_CPPFLAGS])    dnl GNU systems (asprintf, ...)
case $host_os in
   solaris*)
     AX_CFLAGS_GCC_OPTION([-D__EXTENSIONS__],[MORE_CPPFLAGS]) dnl (CMSG_*)
     AX_CFLAGS_GCC_OPTION([-D_XPG4_2],[MORE_CPPFLAGS])        dnl (CMSG_*)
     ;;
   hpux*)
     AX_CFLAGS_GCC_OPTION([-D_XOPEN_SOURCE=500],[MORE_CPPFLAGS])      dnl HP-UX
     AX_CFLAGS_GCC_OPTION([-D_XOPEN_SOURCE_EXTENDED],[MORE_CPPFLAGS]) dnl HP-UX
     ;;
esac

AC_CACHE_SAVE

PKG_CHECK_MODULES([LIBMNL], [libmnl])
PKG_CHECK_MODULES([LIBNCURSES], [ncurses])
AC_CHECK_PROG([PERL], perl, perl)
AS_IF([test -z "$PERL"], [AC_MSG_WARN([Perl missing!])])
AX_PROG_PERL_MODULES([YAML::XS] [TAP::Harness::JUnit], , AC_MSG_ERROR([perl modules required by 9pm missing!]))
AC_CHECK_PROG(BISON, bison, bison)
AS_IF([test -z "$BISON"], [AC_MSG_ERROR([bison missing!])])
AC_CHECK_PROG(FLEX, flex, flex)
AS_IF([test -z "$FLEX"], [AC_MSG_ERROR([flex missing!])])
AC_CHECK_PROG(EXPECT, expect, expect)
AS_IF([test -z "$EXPECT"], [AC_MSG_ERROR([expect missing!])])
AX_PROG_TCL
AX_PROG_TCL_MODULES([yaml] [Expect], , AC_MSG_ERROR([TCL modules required by 9pm missing!]))
AC_CACHE_SAVE

AC_SUBST([MORE_CFLAGS])
AC_SUBST([MORE_CPPFLAGS])
AC_SUBST([MORE_LDFLAGS])
AC_OUTPUT

cat <<EOF

------------------ Summary ------------------
 $PACKAGE_NAME version $PACKAGE_VERSION
  Prefix.........: $prefix
  C Compiler.....: $CC $MORE_CFLAGS $MORE_CPPFLAGS $CFLAGS $CPPFLAGS
  Linker.........: $LD $MORE_LDFLAGS $LDFLAGS $LIBS
---------------------------------------------

Check the above options and compile with:
 ${MAKE-make}

EOF
