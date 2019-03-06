#!/usr/bin/tclsh

package require 9pm

9pm::shell::open "kdev"
9pm::ssh::connect machine 

proc disable_module {} {
    9pm::cmd::execute "modprobe -r tipc"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "modprobe -r tipc failed"
    }
    9pm::output::ok "TIPC module disabled"
}


set timeout 120
9pm::output::plan 1

disable_module
