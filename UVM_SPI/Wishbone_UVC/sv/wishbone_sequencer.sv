//------------------------------------------------------------------------------
//
// CLASS: wishbone_sequencer
//
//------------------------------------------------------------------------------

class wishbone_sequencer extends uvm_sequencer #(wishbone_trans);

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils(wishbone_sequencer)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : wishbone_sequencer