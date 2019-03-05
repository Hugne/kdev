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
    9pm::cmd::execute "brctl delbr $name"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to delete container bridge $name"
    }
    9pm::output::ok "Container bridge $name deleted"

}

set timeout 120

set namespaces {"red" "green" "blue" "yellow"}
9pm::output::plan [expr [llength $namespaces]+1]
set timeout 120

foreach ns $namespaces {
    destroy_ns $ns
}
destroy_bridge "rainbow"
