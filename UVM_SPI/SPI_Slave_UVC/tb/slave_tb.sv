class slave_tb extends uvm_env;
  `uvm_component_utils(slave_tb)

  slave_env slave;

  function new (string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    slave = slave_env::type_id::create("chan0", this);
  endfunction

endclass

