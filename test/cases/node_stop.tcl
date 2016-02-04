#!/usr/bin/tclsh

package require 9pm

9pm::shell::open "virsh"

proc kill_domain {domain} {
    9pm::cmd::start "virsh dominfo node1"
    expect {
        -re {State:\s*running} {
            9pm::cmd::finish
            9pm::output::plan 2
            destroy_domain $domain
            undefine_domain $domain
            return
        }
        -re {State:\s*shut off} {
            9pm::cmd::finish
            9pm::output::plan 1
            9pm::output::info "Domain $domain is not running"
            undefine_domain $domain
            return
        }
        -re {no domain with matching name} {
            9pm::cmd::finish
            9pm::output::plan 0
            9pm::output::info "Domain $domain is not defined"
            return
        }
    }
    set code [9pm::cmd::finish]
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "virsh dominfo returned $code"
    }
}

proc destroy_domain {domain} {
    9pm::cmd::execute "virsh destroy $domain"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Domain could not be destroyed"
    }
    9pm::output::ok "Domain $domain have been destroyed"
}

proc undefine_domain {domain} {
    9pm::cmd::execute "virsh undefine $domain"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Domain could not be undefined"
    }
    9pm::output::ok "Domain $domain have been undefined"
}

set domain [9pm::conf::get machine HOSTNAME]
set xml [9pm::conf::get machine DOMAINXML]

kill_domain $domain
