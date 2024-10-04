`timescale 1ns/1ns

module demo_top;

  // UVM class library compiled in a package
  import uvm_pkg::*;

  // Bring in the rest of the library (macros and template classes)
  `include "uvm_macros.svh"

  import wishbone_pkg::*;
  `include "wishbone_tb.sv"
  `include "wishbone_test_lib.sv"
  
  bit clock;
  bit sck_o,ss_o,mosi_o,miso_i;

  wishbone_if vif(clock);

simple_spi #(.SS_WIDTH()) 
dut
(
  .dat_i(vif.dat_i),
  .cyc_i(vif.cyc_i),
  .stb_i(vif.stb_i),
  .adr_i(vif.adr_i),
  .we_i (vif.we_i),
  
  .inta_o(vif.inta_o),
  .dat_o(vif.dat_o),
  .ack_o(vif.ack_o),

   .clk_i(vif.clock),         // clock
   .rst_i(vif.rst_i),         // reset (synchronous active high)

   .sck_o(sck_o),         // serial clock output
   .ss_o(ss_o),         // slave select (active low)
   .mosi_o(mosi),        // MasterOut SlaveIN
   .miso_i(miso)         // MasterIn SlaveOut

  );
  
  initial begin
    wishbone_if_config::set(null,"*","vif", vif);
    run_test();
  end

  initial begin
    clock <= 1'b1;
  end

  //Generate Clock
  always
    #5 clock = ~clock;

endmodule