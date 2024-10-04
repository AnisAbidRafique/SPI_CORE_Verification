
class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  SPI_tb tb;
  uvm_objection obj;

  function new(string name, uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_int::set(this, "*", "recording_detail", UVM_FULL);
    uvm_config_wrapper::set(this, "*wish*sequencer.run_phase",
                        "default_sequence",
                        wishbone_interrupt_zero_seq::get_type());
                        
    uvm_config_wrapper::set(this, "*slave*sequencer.run_phase",
                        "default_sequence",
                        spi_read_sequence_seq::get_type());

    tb = SPI_tb::type_id::create("tb", this);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    obj = phase.get_objection();
    obj.set_drain_time(this, 10ns);
  endtask

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction
endclass

