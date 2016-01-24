# ===========================================================================
#   
# ===========================================================================
#
# SYNOPSIS
#
#   AX_PROG_TCL_MODULES([MODULES], [ACTION-IF-TRUE], [ACTION-IF-FALSE])
#
# DESCRIPTION
#
#   Checks to see if the given tcl modules are available. If true the shell
#   commands in ACTION-IF-TRUE are executed. If not the shell commands in
#   ACTION-IF-FALSE are run. Checking for modules will fail if $TCLSH is
#   not set.
#
#   MODULES is a space separated list of module names. To check for a
#   minimum version of a module, append the version number to the module
#   name, separated by an equals sign.
#
#   Example:
#
#     AX_PROG_TCL_MODULES(yaml, ,
#                           AC_MSG_WARN(Need some TCL modules)
#
# LICENSE
#
#   Copyright (c) 2016 Erik Hugne <erik.hugne@gmail.com>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved. This file is offered as-is, without any
#   warranty.

#serial 7

AU_ALIAS([AC_PROG_TCL_MODULES], [AX_PROG_TCL_MODULES])
AC_DEFUN([AX_PROG_TCL_MODULES],[dnl
m4_define([ax_tcl_modules])
m4_foreach([ax_tcl_module], m4_split(m4_normalize([$1])),
	  [
	   m4_append([ax_tcl_modules],
		     [']m4_bpatsubst(ax_tcl_module,=,[ ])[' ])
          ])

# Make sure we have perl
if test -z "$TCLSH"; then
AC_MSG_WARN(TCLSH is not set)
fi

if test "x$TCLSH" != x; then
  ax_tcl_modules_failed=0
  for ax_tcl_module in ax_tcl_modules; do
    AC_MSG_CHECKING(for tcl module $ax_tcl_module)

    # Would be nice to log result here, but can't rely on autoconf internals
   echo "if { [[ catch {package require $ax_tcl_module} ]] } { exit 2; }" | $TCLSH 
   if test $? -ne 0; then
      AC_MSG_RESULT(no);
      ax_tcl_modules_failed=1
   else
      AC_MSG_RESULT(ok);
    fi
  done

  # Run optional shell commands
  if test "$ax_perl_modules_failed" = 0; then
    :
    $2
  else
    :
    $3
  fi
else
  AC_MSG_WARN(could not find tcl)
fi])dnl
