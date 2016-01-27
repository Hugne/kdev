#!/usr/bin/tclsh

package require 9pm

9pm::shell::open "virsh"

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
#TODO: edit xml <name>$domain</name> to allow mutliple nodes 
9pm::output::plan 2
start_domain $domain $xml


