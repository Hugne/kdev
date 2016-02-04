#!/usr/bin/tclsh

package require 9pm

9pm::shell::open "virsh"

proc launch_domain {domain xml} {
    9pm::cmd::start "virsh dominfo $domain"
    expect {
    -re {State:\s*running} {
        9pm::cmd::finish
        9pm::output::plan 0
        9pm::output::info "Domain $domain is already running"
        return
    }
    -re {State:\s*shut off} {
        9pm::cmd::finish
        9pm::output::plan 1
        9pm::output::info "Domain $domain is already defined"
        start_domain $domain
        return
    }
    -re {no domain with matching name} {
        9pm::cmd::finish
        9pm::output::plan 2
        define_domain $xml
        start_domain $domain
        return
    }
    }
    set code [9pm::cmd::finish]
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "virsh dominfo returned $code"
    }
}

proc define_domain {xml} {
    9pm::cmd::execute "virsh define $xml"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Domain could not be defined"
    }
    9pm::output::ok "Domain defined from $xml"
}

proc start_domain {domain} {
    9pm::cmd::execute "virsh start $domain"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to start domain $domain"
    }
    9pm::output::ok "Domain $domain started"
}

set domain [9pm::conf::get machine HOSTNAME]
set xml [9pm::conf::get machine DOMAINXML]
#TODO: edit xml <name>$domain</name> to allow mutliple nodes 

launch_domain $domain $xml
