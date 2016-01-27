#!/usr/bin/tclsh

package require 9pm

9pm::shell::open "virsh"

proc kill_domain {domain} {
    9pm::cmd::start "virsh dominfo node1"
    expect {
        -re {State:\s*running} {
            9pm::cmd::finish
            9pm::cmd::execute "virsh destroy $domain"
            9pm::output::ok "Domain $domain have been destroyed"
            return [kill_domain $domain]
        }
        -re {State:\s*shut off} {
            9pm::cmd::finish
            9pm::cmd::execute "virsh undefine $domain"
            9pm::output::ok "Domain $domain have been undefined"
            return
        }
    }
    set code [9pm::cmd::finish]
    9pm::output::warning "Domain $domain could not be killed, virsh returned $code"
}

set domain [9pm::conf::get machine HOSTNAME]
set xml [9pm::conf::get machine DOMAINXML]

9pm::output::plan 2
kill_domain $domain
