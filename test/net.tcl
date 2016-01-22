#!/usr/bin/tclsh

# Source the 9pm library
package require 9pm

# Open a shell with a name of our choice, lets call it "foobar"
9pm::shell::open "virsh"


set test [9pm::cmd::execute "virsh net-destroy default"]
puts "$test"
set test [9pm::cmd::execute "virsh net-undefine default"]
puts "$test"
set test [9pm::cmd::execute "virsh net-define default.xml"]
puts "$test"
set test [9pm::cmd::execute "virsh net-start default"]
puts "$test"
set test [9pm::cmd::execute "virsh net-autostart default"]
puts "$test"
