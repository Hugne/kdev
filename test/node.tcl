#!/usr/bin/tclsh

package require 9pm

9pm::shell::open "virsh"

proc kill_domain {domain} {
    9pm::cmd::start "virsh dominfo node1"
    #TODO: there's a race here, if the script is run multiple times in rapid succession
    expect {
        -re {State:\s*running} {
            9pm::cmd::finish
            9pm::cmd::execute "virsh destroy $domain"
            9pm::output::ok "Domain $domain have been destroyed"
            kill_domain $domain
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

proc start_domain {domain xml} {
    9pm::cmd::execute "virsh define $xml"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to define domain $domain from $xml"
    }
    9pm::output::ok "Domain $domain defined from $xml"
    9pm::cmd::execute "virsh start $domain"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to start domain $domain"
        kill_domain node1
    }
    9pm::output::ok "Domain $domain started"
}

set domain [9pm::conf::get machine HOSTNAME]
set xml [9pm::conf::get machine DOMAINXML]
kill_domain $domain
#TODO: edit xml <name>$domain</name> to allow mutliple nodes 
start_domain $domain $xml


