//------------------------------------------------------------------------------
//
// CLASS: wishbone_monitor
//
//------------------------------------------------------------------------------

class wishbone_monitor extends uvm_monitor;

  // This property is the virtual interfaced needed for this component to drive 
  // and view HDL signals. 
  virtual wishbone_if vif;
  int packet_count = 1;

  // This port is used to connect the monitor to the scoreboard
  uvm_analysis_port #(wishbone_trans) item_collected_port;

  //  Current monitored transaction  
  wishbone_trans item;

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils(wishbone_monitor)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction : new

  function void build_phase(uvm_phase phase);
    if (!wishbone_if_config::get(this, get_full_name(),"vif", vif))
      `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
  endfunction: build_phase

  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    // phase.raise_objection(this, get_type_name());
    super.run_phase(phase);
    `uvm_info("MONITOR_CLASS", "Inside Run Phase!", UVM_LOW)
    @(negedge vif.clock);

    forever 
    begin
      item = wishbone_trans::type_id::create("item");
    
      
    //   wait(!vif.reset);
      
      //sample inputs
      @(posedge vif.clock);
      

      item.dat_i   = vif.dat_i;
      item.cyc_i   = vif.cyc_i;
      item.stb_i   = vif.stb_i;
      item.adr_i   = vif.adr_i;
      item.we_i    = vif.we_i;
      item.rst_i   = vif.rst_i;
      
      //sample output
      @(negedge vif.clock);
   
      item.dat_o   = vif.dat_o;
      item.inta_o  = vif.inta_o;
      item.ack_o   = vif.ack_o;
      
      // send item to scoreboard
      item_collected_port.write(item);
      `uvm_info(get_type_name(), $sformatf("Sending Packet :\n%s \n packet no: %d \n", item.sprint(),packet_count), UVM_LOW)
      packet_count++;
    //   phase.drop_objection(this, get_type_name());
    end
        
  endtask: run_phase

  // // run_phase
  // virtual task run_phase(uvm_phase phase);
  //   fork
  //     collect_transactions();
  //   join
  // endtask : run_phase

  // // Collect transactions
  // virtual protected task collect_transactions();
  //  // Create Transaction
  //  tr_collect = hbus_transaction::type_id::create("tr_collect", this);
  //  forever begin 
  //   fork  
  //   begin
  //      @(posedge vif.reset)  // Wait on Reset active
  //         `uvm_info(get_type_name(), "Reset Active", UVM_MEDIUM)
  //      @(negedge vif.reset)  // Wait on Reset deactive
  //      `uvm_info(get_type_name(), "Reset Deasserted", UVM_MEDIUM)
  //   end
  //   begin
  //     fork
  //       // collect transaction
  //       vif.collect_packet(tr_collect.haddr, tr_collect.hwr_rd, tr_collect.hdata);
  //       begin
  //         @(posedge vif.monstart) void'(this.begin_tr(tr_collect, "HBUS_Monitor_Transaction"));
  //         `uvm_info(get_type_name(), "Collecting Transaction", UVM_LOW)
  //       end
  //     join
  //     if (tr_collect.hwr_rd == HBUS_WRITE)
  //       num_write_trans++;
  //     else  
  //       num_read_trans++;
  //     void'(this.end_tr(tr_collect));
  //     `uvm_info(get_type_name(), $sformatf("transaction collected :\n%s",tr_collect.sprint()), UVM_LOW)
  //     if (checks_enable) perform_checks();
  //     if (coverage_enable) perform_coverage();
  //     // Broadcast transaction to the rest of the environment
  //     item_collected_port.write(tr_collect);
  //   end
  //  join_any
  //  disable fork;
  // end
  // endtask : collect_transactions

  // // UVM report_phase
  // function void report_phase(uvm_phase phase);
  //   `uvm_info(get_type_name(), $sformatf("Report: HBUS Monitor Collected %0d WRITE and %0d READ Transactions", num_write_trans, num_read_trans), UVM_LOW)
  // endfunction : report_phase

endclass : wishbone_monitor
