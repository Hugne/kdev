#!/usr/bin/tclsh

package require 9pm

9pm::shell::open "virsh"

proc define_domain {domain xml} {
    9pm::cmd::execute "virsh define $xml"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to define $domain from $xml"
    }
    9pm::output::ok "$domain defined from $xml"
}


proc start_domain {domain xml} {
    9pm::cmd::execute "virsh start $domain"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to start domain $domain"
    }
    9pm::output::ok "Domain $domain started"
}

set domain [9pm::conf::get machine HOSTNAME]
set xml [9pm::conf::get machine DOMAINXML]
#TODO: edit xml <name>$domain</name> to allow mutliple nodes 

9pm::output::plan 2
define_domain $domain $xml
start_domain $domain $xml
