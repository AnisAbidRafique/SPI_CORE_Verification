//----------------------------------------------------------------
//
// TEST: demo_base_test - Base test
//
//----------------------------------------------------------------
class demo_base_test extends uvm_test;

  `uvm_component_utils(demo_base_test)

  wishbone_demo_tb tb;

  function new(string name = "demo_base_test", 
    uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Enable transaction recording for everything
    uvm_config_int::set(this,"*", "recording_detail", UVM_FULL);
    // Create the tb
    tb = wishbone_demo_tb::type_id::create("tb", this);
  endfunction : build_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

  function void check_phase(uvm_phase phase);
    check_config_usage();
  endfunction

  task run_phase(uvm_phase phase);
      uvm_objection obj = phase.get_objection();
      obj.set_drain_time(this, 10ns);
  endtask

endclass : demo_base_test

//----------------------------------------------------------------
// TEST: wishbone_basic_test
//----------------------------------------------------------------
class wishbone_basic_test extends demo_base_test;

  `uvm_component_utils(wishbone_basic_test)

  function new(string name = "wishbone_basic_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    // Set the default sequence for the master and slave
    uvm_config_wrapper::set(this, "tb.wishbone_bus.my_agent.sequencer.run_phase",
                            "default_sequence",
                            wishbone_interrupt_zero_seq::get_type());

    // Create the tb
    super.build_phase(phase);
  endfunction : build_phase

endclass : wishbone_basic_test