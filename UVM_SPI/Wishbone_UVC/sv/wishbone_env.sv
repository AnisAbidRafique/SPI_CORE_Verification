//------------------------------------------------------------------------------
//
// CLASS: wishbone_env
//
//------------------------------------------------------------------------------

class wishbone_env extends uvm_env;

  // Components of the environment
  wishbone_agent my_agent;
  `uvm_component_utils(wishbone_env)
   
  // Constructor - required syntax for UVM automation and utilities
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional class methods
  extern virtual function void build_phase(uvm_phase phase);
  // extern virtual function void connect_phase(uvm_phase phase);

endclass : wishbone_env

  // UVM build_phase
  function void wishbone_env::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(),"Building wishbone ENV",UVM_HIGH)
     my_agent = wishbone_agent::type_id::create("my_agent",this);
  endfunction : build_phase