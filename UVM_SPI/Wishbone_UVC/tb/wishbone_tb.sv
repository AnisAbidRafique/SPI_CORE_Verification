class wishbone_demo_tb extends uvm_env;

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils(wishbone_demo_tb)

  // hbus environment
  wishbone_env wishbone_bus;

  // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  // Additional class methods
  extern virtual function void build_phase(uvm_phase phase);

endclass : wishbone_demo_tb

  // UVM build() phase
  function void wishbone_demo_tb::build_phase(uvm_phase phase);
    super.build_phase(phase);
    wishbone_bus = wishbone_env::type_id::create("wishbone_bus", this);
  endfunction : build_phase