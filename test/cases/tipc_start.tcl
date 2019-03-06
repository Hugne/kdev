#!/usr/bin/tclsh

package require 9pm

9pm::shell::open "kdev"
9pm::ssh::connect machine 

proc enable_module {} {
    9pm::cmd::execute "modprobe tipc"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "modprobe tipc failed"
    }
    9pm::output::ok "TIPC module enabled"
}

proc enable_tipc { ns tipc_id}  {
    9pm::cmd::execute "ip netns exec $ns tipc node set identity $tipc_id"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to assign TIPC node id in namespace $ns"
    }
    9pm::cmd::execute "ip netns exec $ns tipc bearer enable media eth device veth0"
    if {${?} != 0} {
        9pm::fatal 9pm::output::error "Failed to move device to namespace $ns"
    }
    9pm::output::ok "Container: $ns \tTIPC ID: \[$tipc_id\]\t Bearer: veth0"
}


set timeout 120

set namespaces [9pm::conf::get machine NETNS]

9pm::output::debug $namespaces
9pm::output::plan [expr [dict size $namespaces] + 1]


enable_module
dict for {ns tipc_id} $namespaces {
    enable_tipc $ns $tipc_id
}
