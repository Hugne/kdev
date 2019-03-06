#!/usr/bin/tclsh

package require 9pm

9pm::shell::open "kdev"
9pm::ssh::connect machine 

proc create_bridge { name } {
    9pm::cmd::execute "brctl addbr $name"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to create container bridge $name"
    }
    9pm::cmd::execute "ip link set $name up"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to bring bridge $name up"
    }
    9pm::output::ok "Created container bridge $name"
}

proc create_ns { name bridge } {
    9pm::cmd::execute "ip netns add $name"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to create namespace"
    }
    9pm::output::debug "Created network namespace $name"
    9pm::cmd::execute "ip link add $name type veth peer name veth0"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to create veth device pair"
    }
    9pm::output::debug "Created veth device pair for NS $name"
    9pm::cmd::execute "ip link set veth0 netns $name"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to move device to namespace $name"
    }
    9pm::output::debug "Veth device moved to namespace $name"

    9pm::cmd::execute "brctl addif $bridge $name"
    if {${?} != 0} {
	 9pm::fatal 9pm::output::error "Failed to add device $name to bridge $bridge"
    }
    9pm::output::debug "Veth device $name added to bridge $bridge"
    9pm::cmd::execute "ip netns exec $name ip link set veth0 up"
    if {${?} != 0} {
	 9pm::fatal 9pm::output::error "Failed to bring up veth0 in ns $name"
    }
    9pm::cmd::execute "ip link set $name up"
    if {${?} != 0} {
	    9pm::fatal:: 9pm::output::error "Failed to bring device $name up"
    }
    9pm::output::ok "Namespace $name created with VETH device link"
}


set timeout 120
set namespaces [9pm::conf::get machine NETNS]

9pm::output::plan [expr [dict size $namespaces]+1]
set timeout 120

create_bridge "rainbow"
dict for {ns tipc_id} $namespaces {
    create_ns $ns "rainbow"
}
