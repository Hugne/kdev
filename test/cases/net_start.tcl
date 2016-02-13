#!/usr/bin/tclsh

package require 9pm

9pm::shell::open "virsh"

proc launch_net {} {
    9pm::cmd::start "virsh net-info default"
    expect {
        -re {Active:\s*yes} {
            9pm::cmd::finish
            9pm::output::skip "net-define : Network default is already defined"
            9pm::output::skip "net-start : Network default is already active"
            return
        }
        -re {Active:\s*no} {
            9pm::cmd::finish
            9pm::output::skip "define : Network default is already defined"
            start_net "default"
            return
        }
        -re {no network with matching name} {
            9pm::cmd::finish
            define_net "virsh/default.xml"
            start_net "default"
            return
        }
    }
    set code [9pm::cmd::finish]
    if {$code != 0} {
        9pm::fatal 9pm::output::error "virsh net-info returned $code"
    }
}

proc define_net {xml} {
    9pm::cmd::execute "virsh net-define $xml"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Network could not be defined" 
    }
    9pm::output::ok "Network defined from $xml"
}

proc start_net {name} {
    9pm::cmd::execute "virsh net-start $name"
    if {${?} != 0} {
       9pm::fatal 9pm::output::error "Network could not be started" 
    }
    9pm::output::ok "Network default started"
}

9pm::output::plan 2
launch_net
