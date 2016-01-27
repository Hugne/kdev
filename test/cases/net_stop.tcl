#!/usr/bin/tclsh

package require 9pm

9pm::shell::open "virsh"

proc kill_net {} {
    9pm::cmd::start "virsh net-info default"
    expect {
        -re {Active:\s*yes} {
        9pm::cmd::finish
        9pm::cmd::execute "virsh net-destroy default"
        9pm::output::ok "Network default have been destroyed"
        return [kill_net]
        }
        -re {Active:\s*no} {
        9pm::cmd::finish
        9pm::cmd::execute "virsh net-undefine default"
	9pm::output::ok "Network default have been undefined"
        return
        }
    }
    set code [9pm::cmd::finish]
    9pm::output::warning "Network default could not be killed, virsh returned $code"
}

9pm::output::plan 2
kill_net
