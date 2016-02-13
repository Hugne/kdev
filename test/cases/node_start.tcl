#!/usr/bin/tclsh

package require 9pm

9pm::shell::open "virsh"

proc template {} {
    set path [file join [pwd] [info script]]
    return "[file dirname $path]/../virsh/node.xml"
}

proc createxml {} {
    set xml [template]
    set hostname [9pm::conf::get machine HOSTNAME]
    set mac [9pm::conf::get machine MAC]
    set rnd [9pm::misc::get::rand_str 8]
    set nodexml "/tmp/[file tail $xml].$rnd"
    9pm::cmd::execute "cp $xml $nodexml"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Node xml preparation failed"
    }
    9pm::cmd::execute "sed -i 's/<name><\\/name>/<name>$hostname<\\/name>/g' $nodexml"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to configure domain name"
    }
    9pm::cmd::execute "sed -i 's/<mac address=.*/<mac address=\"$mac\" \\/>/g' $nodexml"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to configure domain MAC address"
    }
    return $nodexml
}


proc launch_domain {} {
    set hostname [9pm::conf::get machine HOSTNAME]
    9pm::cmd::start "virsh dominfo $hostname"
    expect {
    -re {State:\s*running} {
        9pm::cmd::finish
        9pm::output::skip "define : Domain $hostname is already defined"
        9pm::output::skip "start: Domain $hostname is already running"
        9pm::output::warning "Node have NOT been restarted"
        return
    }
    -re {State:\s*shut off} {
        9pm::cmd::finish
        9pm::output::skip "define : Domain $hostname is already defined"
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
    set xml [createxml]
    
    9pm::cmd::execute "virsh define $xml"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Domain could not be defined"
        9pm::output::info "Check $xml for errors"
    }
    9pm::output::ok "Domain defined from $xml"
    9pm::cmd::execute "rm -f $xml"
}

proc start_domain {hostname} {
    9pm::cmd::execute "virsh start $hostname"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to start domain $hostname"
    }
    9pm::output::ok "Domain $hostname started"
}

proc check_domain_up {} {
    set ip [9pm::conf::get machine SSH_IP]
    set user [9pm::conf::get machine SSH_USER]
    set hostname [9pm::conf::get machine HOSTNAME]
    9pm::cmd::execute "ssh $ip -l $user -o StrictHostKeyChecking=no \
                       -o BatchMode=yes -o ConnectionAttempts=20 \
                       -o ConnectTimeout=3 hostname"
    if {${?} == 0} {
        9pm::output::ok "SSH connect success to $hostname ($ip)"
        return 
    }
    9pm::output::error "SSH connection to $hostname ($ip) failed"
}

#TODO: edit xml <name>$domain</name> to allow mutliple nodes 

9pm::output::plan 3
launch_domain
set timeout 120
check_domain_up
