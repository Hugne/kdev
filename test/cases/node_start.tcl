#!/usr/bin/tclsh

package require 9pm

9pm::shell::open "virsh"

proc launch_domain {} {
    set hostname [9pm::conf::get machine HOSTNAME]
    9pm::cmd::start "virsh dominfo $hostname"
    expect {
    -re {State:\s*running} {
        9pm::cmd::finish
        9pm::output::info "Domain $hostname is already defined"
        9pm::output::skip "Domain $hostname is already running"
        9pm::output::warning "Node have NOT been restarted"
        return
    }
    -re {State:\s*shut off} {
        9pm::cmd::finish
        9pm::output::skip "Domain $hostname is already defined"
        start_domain $hostname
        return
    }
    -re {no domain with matching name} {
        9pm::cmd::finish
        define_domain
        start_domain $hostname
        return
    }
    }
    set code [9pm::cmd::finish]
    if {$code != 0} {
        9pm::fatal 9pm::output::error "virsh dominfo returned $code"
    }
}

proc define_domain {} {
    set xml [9pm::conf::get machine DOMAINXML]
    9pm::cmd::execute "virsh define $xml"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Domain could not be defined"
    }
    9pm::output::ok "Domain defined from $xml"
}

proc start_domain {hostname} {
    9pm::cmd::execute "virsh start $hostname"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to start domain $hostname"
    }
    9pm::output::ok "Domain $hostname started"
}

proc check_domain_up {retries} {
    set ip [9pm::conf::get machine SSH_IP]
    set hostname [9pm::conf::get machine HOSTNAME]
    9pm::cmd::execute "ping $ip -c 1 -W 3"
    if {${?} == 0} {
        9pm::output::ok "Echo reply from $hostname"
        return 
    }
    puts "retries is $retries" 
    if {$retries > 0} {
        9pm::output::info "No echo reply from $hostname, still trying" 
        return [check_domain_up [expr $retries - 1]]
    }
    9pm::output::error "No echo reply received from $hostname"
}

#TODO: edit xml <name>$domain</name> to allow mutliple nodes 

9pm::output::plan 3
launch_domain
check_domain_up 10
