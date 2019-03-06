#!/usr/bin/tclsh

package require 9pm

9pm::shell::open "kdev"
9pm::ssh::connect machine 

proc destroy_ns { name } {
    9pm::cmd::execute "ip netns delete $name"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to delete namespace"
    }
    9pm::output::ok "Created network namespace $name"
}

proc destroy_bridge { name } {
    9pm::cmd::execute "ip link set $name down"
    if {${?} != 0} {
         9pm::fatal 9pm::output::error "Failed to bring down $name"
    }
    9pm::cmd::execute "brctl delbr $name"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to delete container bridge $name"
    }
    9pm::output::ok "Container bridge $name deleted"

}

set timeout 120

set namespaces [9pm::conf::get machine NETNS]

9pm::output::plan [expr [dict size $namespaces]+1]
set timeout 120

dict for {ns tipc_id} $namespaces {
    destroy_ns $ns
}
destroy_bridge "rainbow"
