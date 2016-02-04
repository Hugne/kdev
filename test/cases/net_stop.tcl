#!/usr/bin/tclsh

package require 9pm

9pm::shell::open "virsh"

proc kill_net {} {
    9pm::cmd::start "virsh net-info default"
    expect {
        -re {Active:\s*yes} {
        9pm::cmd::finish
        9pm::output::plan 2
        destroy_net
        undefine_net
        return
        }
        -re {Active:\s*no} {
        9pm::cmd::finish
        9pm::output::plan 1
        9pm::output::info "Network default is not active"
        undefine_net
        return
        }
        -re {no network with matching name} {
        9pm::cmd::finish
        9pm::output::plan 0
        9pm::output::info "Network default is not defined"
        }
    }
    set code [9pm::cmd::finish]
    9pm::output::warning "Network default could not be killed, virsh returned $code"
}

proc destroy_net {} {
    9pm::cmd::execute "virsh net-destroy default"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Network could not be destroyed"
    }
    9pm::output::ok "Network default have been destroyed"
}

proc undefine_net {} {
    9pm::cmd::execute "virsh net-undefine default"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Network could not be undefined"
    }
    9pm::output::ok "Network default have been undefined"

}
kill_net
