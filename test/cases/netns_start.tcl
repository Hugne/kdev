#!/usr/bin/tclsh

package require 9pm

9pm::shell::open "kdev"
9pm::ssh::connect machine 

proc create_bridge { name } {
    9pm::cmd::execute "brctl addbr $name"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to create container bridge $name"
    }
    9pm::output::ok "Created container bridge $name"

}

proc create_ns { name } {
    9pm::cmd::execute "ip netns add $name"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to create namespace"
    }
    9pm::output::ok "Created network namespace $name"
}

proc create_veth { name bridge }  {
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

    9pm::cmd::execute "brctl addif $bridge $name"
    if {${?} != 0} {
	 9pm::fatal 9pm::output::error "Failed to add device $name to bridge $bridge"
    }
    9pm::output::ok "Veth device $name added to bridge $bridge"
}


set timeout 120

set namespaces {red green blue yellow}
9pm::output::plan [expr [llength $namespaces]*4+1]
set timeout 120

create_bridge "rainbow"
foreach ns $namespaces {
    create_ns $ns
    create_veth $ns "rainbow"
}
