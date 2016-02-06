#!/usr/bin/tclsh

package require 9pm

9pm::shell::open "virsh"

proc kill_domain {hostname} {
    9pm::cmd::start "virsh dominfo $hostname"
    expect {
        -re {State:\s*running} {
            9pm::cmd::finish
            destroy_domain $hostname
            undefine_domain $hostname
            return
        }
        -re {State:\s*shut off} {
            9pm::cmd::finish
            9pm::output::skip "$hostname is not running"
            undefine_domain $hostname
            return
        }
        -re {no domain with matching name} {
            9pm::cmd::finish
            9pm::output::skip "$hostname is not running"
            9pm::output::skip "$hostname is not defined"
            return
        }
    }
    set code [9pm::cmd::finish]
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "virsh dominfo returned $code"
    }
}

proc destroy_domain {hostname} {
    9pm::cmd::execute "virsh destroy $hostname"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "$hostname could not be destroyed"
    }
    9pm::output::ok "$hostname have been destroyed"
}

proc undefine_domain {hostname} {
    9pm::cmd::execute "virsh undefine $hostname"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Domain could not be undefined"
    }
    9pm::output::ok "$hostname have been undefined"
}

set hostname [9pm::conf::get machine HOSTNAME]
set xml [9pm::conf::get machine DOMAINXML]
9pm::output::plan 2
kill_domain $hostname
