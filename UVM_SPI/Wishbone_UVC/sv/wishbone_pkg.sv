package wishbone_pkg;

 import uvm_pkg::*;
 `include "uvm_macros.svh"

  typedef uvm_config_db#(virtual wishbone_if) wishbone_if_config;

  `include "wishbone_transaction.sv"
  `include "wishbone_monitor.sv"
  `include "wishbone_sequencer.sv"
  `include "wishbone_driver.sv"
  `include "wishbone_agent.sv"
  `include "wishbone_seqs.sv"
  
  `include "wishbone_env.sv"

endpackage : wishbone_pkg