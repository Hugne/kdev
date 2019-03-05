#!/usr/bin/tclsh

package require 9pm

9pm::shell::open "kdev"
9pm::ssh::connect machine 

proc create_ns { name } {
    9pm::cmd::execute "ip netns add $name"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to create namespace"
    }
    9pm::output::ok "Created network namespace $name"
}

proc create_veth { name }  {
    9pm::cmd::execute "ip link add $name type veth peer name veth1"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to create veth device pair"
    }
    9pm::output::ok "Created veth device pair for NS $name"
    9pm::cmd::execute "ip link set veth1 netns $name"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to move device to namespace $name"
    }
    9pm::output::ok "Veth device moved to namespace $name"

}


set timeout 120

set namespaces {red green blue yellow}
9pm::output::plan [expr [llength $namespaces]*3]
set timeout 120

foreach ns $namespaces {
    create_ns $ns
    create_veth $ns
}
