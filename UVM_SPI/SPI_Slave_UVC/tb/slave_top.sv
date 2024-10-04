module slave_top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import slave_pkg::*;

  `include "slave_tb.sv"
  `include "test_lib.sv"

  bit sck_o; 
  slave_if slave_vif(sck_o);

  initial begin
    slave_vif_config::set(null,"*","vif", slave_vif);
    run_test();
  end

  always
    #50 sck_o = ~sck_o;

endmodule