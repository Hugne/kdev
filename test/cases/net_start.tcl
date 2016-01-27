#!/usr/bin/tclsh

package require 9pm

9pm::shell::open "virsh"

proc start_net {} {
    9pm::cmd::execute "virsh net-define virsh/default.xml"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Network could not be defined" 
    }
    9pm::output::ok "Network defined from default.xml"
    9pm::cmd::execute "virsh net-start default"
    if {${?} != 0} {
       9pm::fatal 9pm::output::error "Network could not be started" 
    }
    9pm::output::ok "Network default started"
}

9pm::output::plan 2
start_net
