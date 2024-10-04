// typedef enum bit { HBUS_READ, HBUS_WRITE } hbus_read_write_enum;

//------------------------------------------------------------------------------
//
// CLASS: wishbone_transaction
//
//------------------------------------------------------------------------------

class wishbone_trans extends uvm_sequence_item;     

  rand bit [7:0]            dat_i;
  rand bit                  cyc_i;
  rand bit                  stb_i;
  rand bit [1:0]            adr_i;
  rand bit                  we_i;
  rand bit                  rst_i;
  
  bit                       inta_o;
  bit [7:0]                 dat_o;
  bit                       ack_o;
//   rand hbus_read_write_enum hwr_rd;
//   rand int unsigned         wait_between_cycle;
 
//   constraint c_wait { wait_between_cycle >0; wait_between_cycle <= 3 ; }
  //constraint c_addr_range { haddr >=0; haddr < 2'h2000 ; }

  `uvm_object_utils_begin(wishbone_trans)
    `uvm_field_int(dat_i, UVM_DEFAULT + UVM_BIN)
    `uvm_field_int(cyc_i, UVM_DEFAULT)
    `uvm_field_int(stb_i, UVM_DEFAULT)
    `uvm_field_int(adr_i, UVM_DEFAULT + UVM_BIN)
    `uvm_field_int(we_i, UVM_DEFAULT)
    `uvm_field_int(rst_i, UVM_DEFAULT)

    `uvm_field_int(inta_o, UVM_DEFAULT)
    `uvm_field_int(dat_o, UVM_DEFAULT + UVM_BIN)
    `uvm_field_int(ack_o, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor - required syntax for UVM automation and utilities
  function new (string name = "wishbone_trans");
    super.new(name);
  endfunction : new

endclass : wishbone_trans