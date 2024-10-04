//------------------------------------------------------------------------------
//
// CLASS: wishbone_agent
//
//------------------------------------------------------------------------------

class wishbone_agent extends uvm_agent;

  // This field determines whether an agent is active or passive.
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  // Master's id
  // protected int master_id;

  wishbone_monitor          monitor;
  wishbone_driver           driver;
  wishbone_sequencer        sequencer;
  
  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils(wishbone_agent)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build_phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor = wishbone_monitor::type_id::create("monitor", this);
    if(is_active == UVM_ACTIVE) 
      begin
        sequencer = wishbone_sequencer::type_id::create("sequencer", this);
        driver    = wishbone_driver::type_id::create("driver", this);
      end
  endfunction : build_phase
   
  // connect_phase
  virtual function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds the driver to the sequencer using consumer-producer interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // // assign the id of the agent's children
  // function void set_master_id(int i);
  //   if (is_active == UVM_ACTIVE) begin
  //     sequencer.master_id = i;
  //     driver.master_id = i;
  //   end
  // endfunction

endclass : wishbone_agent