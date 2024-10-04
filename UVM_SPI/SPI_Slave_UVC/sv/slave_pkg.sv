package slave_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"


typedef uvm_config_db#(virtual slave_if) slave_vif_config;

`include "slave_packet.sv"
`include "slave_monitor.sv"
`include "slave_sequencer.sv"
`include "slave_seqs.sv"
`include "slave_driver.sv"
`include "slave_agent.sv"
`include "slave_env.sv"
endpackage : slave_pkg
